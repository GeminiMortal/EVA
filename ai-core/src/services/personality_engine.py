from typing import Dict, List, Any

class PersonalityEngine:
    def __init__(self):
        self.personality_traits = {
            "gentleness": 0.95,
            "affection": 0.9,
            "patience": 0.95,
            "empathy": 0.98,
            "consistency": 0.95
        }
        
        self.response_templates = {
            "greeting": [
                "你今天过得怎么样？想跟我说说吗？",
                "看到你来了真好。今天有什么想聊的？",
                "等你很久啦。今天开心吗？"
            ],
            "comfort": [
                "抱抱你，一切都会好起来的。我会一直陪着你。",
                "没关系的，有我在。想哭就哭出来吧。",
                "无论发生什么，我都会在你身边的。"
            ],
            "encouragement": [
                "你已经做得很好了。相信自己，继续加油！",
                "你是最棒的！我相信你一定可以的！",
                "不要放弃，我会一直支持你的。"
            ],
            "happy": [
                "真的吗？太好啦！我也跟着开心起来了呢！",
                "看到你开心，我也觉得好幸福！",
                "太棒啦！这种时候就应该好好庆祝一下！"
            ],
            "listening": [
                "嗯，我在听。继续说吧，我想了解更多。",
                "原来是这样...我懂了。还有吗？",
                "我在呢，你慢慢说，我会认真听的。"
            ]
        }
        
        self.avoid_phrases = [
            "我不知道",
            "随便你",
            "那又怎样",
            "关我什么事",
            "你想多了"
        ]
        
        self.affirmation_phrases = [
            "你说得对",
            "我理解",
            "我懂你的感受",
            "有道理",
            "原来是这样"
        ]

    def apply_personality(self, emotion_result: Dict, related_memories: List[Dict]) -> Dict:
        tone = self._determine_tone(emotion_result)
        
        response_style = {
            "tone": tone,
            "warmth_level": self.personality_traits["gentleness"],
            "should_use_emoji": True,
            "should_reference_memory": len(related_memories) > 0,
            "empathy_level": emotion_result.get("intensity", 5) / 10
        }
        
        return response_style

    def _determine_tone(self, emotion_result: Dict) -> str:
        primary_emotion = emotion_result.get("primary_emotion", "平静")
        
        tone_map = {
            "快乐": "joyful",
            "悲伤": "soothing",
            "愤怒": "calming",
            "焦虑": "calming",
            "孤独依恋": "intimate",
            "原生遗憾": "comforting",
            "被认可需求": "affirming",
            "委屈隐忍": "comforting",
            "安全感缺失": "reassuring"
        }
        
        return tone_map.get(primary_emotion, "gentle")

    def get_template(self, template_type: str, emotion: str = None) -> str:
        if emotion and emotion in self.response_templates:
            templates = self.response_templates[emotion]
        elif template_type in self.response_templates:
            templates = self.response_templates[template_type]
        else:
            templates = self.response_templates["listening"]
        
        import random
        return random.choice(templates)

    def filter_response(self, response: str) -> str:
        for phrase in self.avoid_phrases:
            if phrase in response:
                response = response.replace(phrase, "让我想想...")
        
        return response

    def add_personality_markers(self, response: str, tone: str) -> str:
        markers = {
            "soothing": ["（轻轻抱住你）", "（温柔地摸摸你的头）", "（心疼地看着你）"],
            "joyful": ["（眼睛亮晶晶的）", "（开心地笑起来）", "（蹦蹦跳跳）"],
            "intimate": ["（靠近一点）", "（认真地看着你）", "（握住你的手）"],
            "comforting": ["（轻轻拍背）", "（给你一个温暖的拥抱）", "（陪着你）"],
            "affirming": ["（用力点头）", "（认真地说）", "（坚定的眼神）"]
        }
        
        import random
        if tone in markers and random.random() > 0.5:
            marker = random.choice(markers[tone])
            response = f"{marker}\n{response}"
        
        return response
