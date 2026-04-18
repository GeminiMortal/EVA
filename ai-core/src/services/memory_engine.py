import faiss
import numpy as np
from typing import List, Dict, Optional
import json
import os
from datetime import datetime

class MemoryEngine:
    def __init__(self):
        self.dimension = 384
        self.index = None
        self.memory_store = {}
        self.user_indices = {}
        self.data_path = "../data"
        
        os.makedirs(self.data_path, exist_ok=True)
        self._init_index()

    def _init_index(self):
        self.index = faiss.IndexFlatL2(self.dimension)
        
        index_path = os.path.join(self.data_path, "faiss_index.bin")
        if os.path.exists(index_path):
            try:
                self.index = faiss.read_index(index_path)
                print("FAISS索引加载成功")
            except:
                print("FAISS索引加载失败，创建新索引")
        
        store_path = os.path.join(self.data_path, "memory_store.json")
        if os.path.exists(store_path):
            try:
                with open(store_path, 'r', encoding='utf-8') as f:
                    self.memory_store = json.load(f)
                print("记忆存储加载成功")
            except:
                self.memory_store = {}

    def load_index(self):
        print("记忆引擎初始化完成")

    def _text_to_vector(self, text: str) -> np.ndarray:
        vector = np.random.randn(self.dimension).astype('float32')
        vector = vector / np.linalg.norm(vector)
        return vector.reshape(1, -1)

    async def save_memory(self, memory_data: Dict) -> str:
        memory_id = f"mem_{datetime.now().strftime('%Y%m%d%H%M%S')}_{np.random.randint(1000)}"
        
        vector = self._text_to_vector(memory_data["content"])
        
        memory_record = {
            "memory_id": memory_id,
            "user_id": memory_data["user_id"],
            "content": memory_data["content"],
            "memory_type": memory_data.get("memory_type", "event"),
            "emotion": memory_data.get("emotion", "neutral"),
            "importance": memory_data.get("importance", 5),
            "vector": vector.tolist(),
            "created_at": datetime.now().isoformat(),
            "recalled_count": 0,
            "last_recalled_at": None
        }
        
        self.memory_store[memory_id] = memory_record
        
        self.index.add(vector)
        
        user_id = memory_data["user_id"]
        if user_id not in self.user_indices:
            self.user_indices[user_id] = []
        self.user_indices[user_id].append(len(self.index.ntotal) - 1)
        
        self._save_to_disk()
        
        return memory_id

    def retrieve_memories(self, user_id: str, query_text: str, top_k: int = 5) -> List[Dict]:
        if user_id not in self.user_indices or len(self.user_indices[user_id]) == 0:
            return []
        
        query_vector = self._text_to_vector(query_text)
        
        user_mem_ids = self.user_indices[user_id]
        if len(user_mem_ids) == 0:
            return []
        
        user_vectors = []
        user_memory_list = []
        for idx in user_mem_ids:
            if idx < len(self.index.ntotal):
                for mem_id, mem in self.memory_store.items():
                    if mem["user_id"] == user_id:
                        user_memory_list.append(mem)
                        user_vectors.append(np.array(mem["vector"]).reshape(1, -1))
        
        if len(user_vectors) == 0:
            return []
        
        user_index = faiss.IndexFlatL2(self.dimension)
        user_index.add(np.vstack(user_vectors))
        
        distances, indices = user_index.search(query_vector, min(top_k, len(user_vectors)))
        
        results = []
        for i, idx in enumerate(indices[0]):
            if idx < len(user_memory_list):
                memory = user_memory_list[idx]
                memory["similarity"] = float(1.0 / (1.0 + distances[0][i]))
                results.append(memory)
                
                memory_id = memory["memory_id"]
                if memory_id in self.memory_store:
                    self.memory_store[memory_id]["recalled_count"] += 1
                    self.memory_store[memory_id]["last_recalled_at"] = datetime.now().isoformat()
        
        self._save_to_disk()
        
        return results

    def get_user_memories(self, user_id: str, memory_type: Optional[str] = None, limit: int = 20) -> List[Dict]:
        memories = []
        for mem_id, mem in self.memory_store.items():
            if mem["user_id"] == user_id:
                if memory_type is None or mem["memory_type"] == memory_type:
                    memories.append(mem)
        
        memories.sort(key=lambda x: x.get("importance", 0) * -1)
        return memories[:limit]

    def _save_to_disk(self):
        try:
            index_path = os.path.join(self.data_path, "faiss_index.bin")
            faiss.write_index(self.index, index_path)
            
            store_path = os.path.join(self.data_path, "memory_store.json")
            with open(store_path, 'w', encoding='utf-8') as f:
                json.dump(self.memory_store, f, ensure_ascii=False, indent=2)
                
            user_indices_path = os.path.join(self.data_path, "user_indices.json")
            with open(user_indices_path, 'w', encoding='utf-8') as f:
                json.dump(self.user_indices, f)
        except Exception as e:
            print(f"保存记忆数据失败: {e}")
