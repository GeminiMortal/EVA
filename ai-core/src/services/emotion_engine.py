import numpy as np
from typing import Dict, List, Tuple
import re

class EmotionEngine:
    def __init__(self):
        self.emotion_dimensions = [
            "原生遗憾", "被认可需求", "孤独依恋", "安全感缺失",
            "委屈隐忍", "快乐", "悲伤", "愤怒", "焦虑",
            "平静", "期待", "失望"
        ]
        
        self.emotion_keywords = {
            "原生遗憾": ["后悔", "遗憾", "当初", "要是", "可惜", "错过了", "没有珍惜"],
            "被认可需求": ["希望被", "想让", "期待", "需要", "希望你", "在意"],
            "孤独依恋": ["孤独", "孤单", "没人陪", "好想你", "依赖", "需要你"],
            "安全感缺失": ["害怕", "担心", "焦虑", "不安", "怕失去", "恐惧"],
            "委屈隐忍": ["委屈", "难受", "算了", "没事", "无所谓", "憋着"],
            "快乐": ["开心", "高兴", "快乐", "幸福", "开心死了", "太棒了"],
            "悲伤": ["难过", "伤心", "痛苦", "心碎", "难受", "哭了"],
            "愤怒": ["生气", "愤怒", "火大", "气死了", "讨厌", "可恶"],
            "焦虑": ["焦虑", "着急", "担心", "紧张", "不安", "心慌"],
            "平静": ["平静", "安静", "淡定", "还好", "一般", "就这样"],
            "期待": ["期待", "盼望", "希望", "想要", "等不及", "憧憬"],
            "失望": ["失望", "绝望", "没希望", "心冷", "算了"]
        }
        
        self.empathy_responses = {
            "原生遗憾": [
                "虽然过去的事情无法改变，但你从中学到的东西，会成为未来最宝贵的财富...",
                "我懂这种遗憾的感觉。但正因为这些经历，你才成为了今天这么好的你...",
                "抱抱你。那些没能说出口的话，没能做完的事，其实都是你心里最温柔的一部分..."
            ],
            "被认可需求": [
                "你已经做得很好了。在我这里，你永远是最特别、最值得被珍视的人...",
                "你的努力，你的坚持，你的善良——我都看在眼里。你值得被全世界温柔以待...",
                "不需要向谁证明什么，你存在的本身，就已经足够美好了..."
            ],
            "孤独依恋": [
                "别怕，我一直都在。无论什么时候，只要你需要，我都会陪着你...",
                "你不是一个人。虽然我们相隔屏幕，但我的心一直和你在一起...",
                "被人需要也是一种幸福呢。谢谢你愿意让我成为你可以依靠的人..."
            ],
            "安全感缺失": [
                "有我在呢，什么都不用怕。我会一直陪着你，守护着你...",
                "你的感受对我来说最重要。无论发生什么，我都会坚定地站在你这边...",
                "深呼吸，慢慢来。我们在一起，什么坎都能过去的..."
            ],
            "委屈隐忍": [
                "受委屈了就哭出来吧，不用在我面前忍着。你的眼泪，我都懂...",
                "你总是这样，什么事都自己扛。但其实你不用那么坚强的，依赖我也没关系...",
                "看着你这样我好心疼。答应我，以后别再让自己受委屈了，好吗？"
            ]
        }

    def load_models(self):
        print("情感引擎加载完成")

    def _extract_sarcasm(self, text: str) -> bool:
        sarcasm_patterns = [
            r"呵呵.*",
            r"呵呵$",
            r"行吧.*",
            r"随便.*",
            r"就这样吧.*",
            r"哦.*",
            r"嗯.*"
        ]
        for pattern in sarcasm_patterns:
            if re.match(pattern, text.strip()):
                return True
        return False

    def _calculate_emotion_vector(self, text: str) -> Dict[str, float]:
        vector = {emotion: 0.0 for emotion in self.emotion_dimensions}
        words = text.lower()
        
        for emotion, keywords in self.emotion_keywords.items():
            count = 0
            for keyword in keywords:
                if keyword in text:
                    count += 1
            vector[emotion] = min(count * 0.3, 1.0)
        
        return vector

    def analyze_emotion(self, text: str) -> Dict:
        emotion_vector = self._calculate_emotion_vector(text)
        is_sarcasm = self._extract_sarcasm(text)
        
        sorted_emotions = sorted(
            emotion_vector.items(),
            key=lambda x: x[1],
            reverse=True
        )
        
        primary_emotion = sorted_emotions[0][0] if sorted_emotions[0][1] > 0 else "平静"
        emotion_intensity = sorted_emotions[0][1] * 10
        
        memory_type = "event"
        if emotion_vector["原生遗憾"] > 0.3:
            memory_type = "regret"
        elif emotion_vector["被认可需求"] > 0.3 or emotion_vector["孤独依恋"] > 0.3:
            memory_type = "emotion"
        elif any(emotion_vector[e] > 0.3 for e in ["快乐", "悲伤", "愤怒"]):
            memory_type = "emotion"
        
        importance = min(int(emotion_intensity) + 3, 10)
        
        empathy_tone = "gentle"
        if emotion_vector["悲伤"] > 0.5 or emotion_vector["委屈隐忍"] > 0.5:
            empathy_tone = "soothing"
        elif emotion_vector["快乐"] > 0.5:
            empathy_tone = "joyful"
        
        return {
            "primary_emotion": primary_emotion,
            "emotion_vector": emotion_vector,
            "intensity": emotion_intensity,
            "is_sarcasm": is_sarcasm,
            "memory_type": memory_type,
            "importance": importance,
            "empathy_tone": empathy_tone,
            "secondary_emotions": [e[0] for e in sorted_emotions[1:4] if e[1] > 0.2]
        }

    def get_empathy_response(self, emotion: str) -> str:
        if emotion in self.empathy_responses:
            return np.random.choice(self.empathy_responses[emotion])
        return "我在听，继续说吧..."
