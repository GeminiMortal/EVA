import random
from typing import Dict, List
import re

class ResponseGenerator:
    def __init__(self):
        self.emoji_map = {
            "快乐": ["😊", "😄", "🎉", "✨", "💖"],
            "悲伤": ["😢", "💔", "🫂", "🌙", "🤍"],
            "愤怒": ["😤", "💢", "🌊", "☁️"],
            "焦虑": ["😰", "🫶", "🌸", "🌻"],
            "孤独依恋": ["🥺", "💕", "🤗", "💗"],
            "原生遗憾": ["😔", "💫", "🌅", "🌈"],
            "被认可需求": ["🥰", "🌟", "💎", "🎀"],
            "委屈隐忍": ["😞", "🫂", "💛", "🌼"],
            "安全感缺失": ["😟", "🤍", "🏠", "🤗"],
            "平静": ["😊", "🌿", "☕", "🌸"]
        }
        
        self.general_responses = {
            "question": [
                "让我想想...嗯，这个问题问得真好。你觉得呢？",
                "这个问题很有意思呢！你是怎么想的？",
                "嗯...我觉得每个人都有自己的答案，重要的是你怎么看。"
            ],
            "statement": [
                "原来是这样...我明白了。",
                "嗯，我在听。继续说吧。",
                "我懂你的意思了。"
            ],
            "emotional": [
                "谢谢你愿意跟我说这些...",
                "能被你信任，我真的很开心。",
                "你的感受对我来说很重要。"
            ]
        }
        
        self.memory_reference_templates = [
            "说到这个，我想起之前你跟我说过{content}...",
            "记得上次你提到{content}，现在想想还觉得很温暖呢。",
            "你之前说过{content}，我一直都记得哦。"
        ]

    def generate(self, user_input: str, emotion_result: Dict, 
                 related_memories: List[Dict], personality: Dict) -> Dict:
        
        primary_emotion = emotion_result.get("primary_emotion", "平静")
        tone = personality.get("tone", "gentle")
        
        response_parts = []
        
        if emotion_result.get("primary_emotion") in ["原生遗憾", "被认可需求", "孤独依恋", 
                                                    "安全感缺失", "委屈隐忍"]:
            from services.emotion_engine import EmotionEngine
            ee = EmotionEngine()
            empathy_response = ee.get_empathy_response(primary_emotion)
            response_parts.append(empathy_response)
        elif related_memories and personality.get("should_reference_memory"):
            memory = related_memories[0]
            template = random.choice(self.memory_reference_templates)
            memory_ref = template.format(content=memory["content"][:30] + "..." if len(memory["content"]) > 30 else memory["content"])
            response_parts.append(memory_ref)
        
        if not response_parts:
            input_type = self._classify_input(user_input)
            response_parts.append(random.choice(self.general_responses[input_type]))
        
        follow_up = self._generate_follow_up(user_input, primary_emotion)
        if follow_up:
            response_parts.append(follow_up)
        
        final_response = "\n\n".join(response_parts)
        
        from services.personality_engine import PersonalityEngine
        pe = PersonalityEngine()
        final_response = pe.add_personality_markers(final_response, tone)
        final_response = pe.filter_response(final_response)
        
        emojis = self.emoji_map.get(primary_emotion, self.emoji_map["平静"])
        
        return {
            "content": final_response,
            "emotion": primary_emotion,
            "confidence": min(emotion_result.get("intensity", 5) / 10 + 0.3, 1.0),
            "emojis": random.sample(emojis, min(3, len(emojis))),
            "should_save_memory": emotion_result.get("importance", 0) >= 3,
            "suggested_media": self._suggest_media(primary_emotion)
        }

    def _classify_input(self, text: str) -> str:
        if any(q in text for q in ["？", "?", "什么", "怎么", "为什么", "如何"]):
            return "question"
        elif len(text) > 20:
            return "emotional"
        else:
            return "statement"

    def _generate_follow_up(self, text: str, emotion: str) -> str:
        follow_ups = {
            "快乐": ["今天还有什么开心的事吗？", "是什么让你这么开心呀？"],
            "悲伤": ["如果愿意的话，可以跟我多说一点吗？", "想不想聊聊为什么这么难过？"],
            "孤独依恋": ["现在有我陪着你呢，想聊点什么？", "谢谢你需要我，我一直都在。"],
            "原生遗憾": ["如果...可以重来的话，你想怎么做呢？", "虽然过去无法改变，但你从中学到了什么吗？"],
            "被认可需求": ["你最希望得到谁的认可呢？", "在我这里，你已经做得够好了。"]
        }
        
        if emotion in follow_ups:
            return random.choice(follow_ups[emotion])
        return "那你呢？今天还有什么想跟我说的吗？"

    def _suggest_media(self, emotion: str) -> Dict:
        media_suggestions = {
            "快乐": {"type": "image", "suggestions": ["开心的场景", "阳光明媚"]},
            "悲伤": {"type": "image", "suggestions": ["温暖的拥抱", "宁静的月光"]},
            "焦虑": {"type": "music", "suggestions": ["舒缓的轻音乐", "雨声白噪音"]},
            "孤独依恋": {"type": "image", "suggestions": ["温馨的小屋", "陪伴的主题"]}
        }
        return media_suggestions.get(emotion, {"type": "none", "suggestions": []})
