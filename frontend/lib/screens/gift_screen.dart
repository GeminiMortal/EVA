import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../theme/app_theme.dart';

class Gift {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int affectionBonus;
  final String category;

  Gift({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.affectionBonus,
    required this.category,
  });
}

class GiftScreen extends StatefulWidget {
  const GiftScreen({super.key});

  @override
  State<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  String _selectedCategory = 'all';
  
  final List<String> _categories = ['all', 'token', 'box', 'costume', 'special'];
  final List<String> _categoryLabels = ['全部', '心意信物', '专属礼盒', '亲密装扮', '特别礼物'];
  
  final List<Gift> _sampleGifts = [
    Gift(
      id: '1',
      name: '永恒之心',
      description: '一颗代表永恒陪伴的心',
      price: 52,
      imageUrl: '❤️',
      affectionBonus: 52,
      category: 'token',
    ),
    Gift(
      id: '2',
      name: '甜蜜糖果盒',
      description: '装满甜蜜的糖果礼盒',
      price: 99,
      imageUrl: '🍬',
      affectionBonus: 99,
      category: 'box',
    ),
    Gift(
      id: '3',
      name: '温柔拥抱',
      description: '给你一个温暖的虚拟拥抱',
      price: 13.14,
      imageUrl: '🤗',
      affectionBonus: 30,
      category: 'special',
    ),
    Gift(
      id: '4',
      name: '星空物语',
      description: '陪你一起看星空',
      price: 131.4,
      imageUrl: '✨',
      affectionBonus: 131,
      category: 'token',
    ),
    Gift(
      id: '5',
      name: '浪漫情书',
      description: 'EVE写给你的专属情书',
      price: 29.9,
      imageUrl: '💌',
      affectionBonus: 50,
      category: 'special',
    ),
    Gift(
      id: '6',
      name: '甜蜜蛋糕',
      description: '为你定制的甜蜜蛋糕',
      price: 66.6,
      imageUrl: '🎂',
      affectionBonus: 66,
      category: 'box',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredGifts = _selectedCategory == 'all'
        ? _sampleGifts
        : _sampleGifts.where((g) => g.category == _selectedCategory).toList();
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('心意礼物'),
      ),
      body: Column(
        children: [
          _buildCategorySelector(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredGifts.length,
              itemBuilder: (context, index) {
                return _buildGiftCard(filteredGifts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == _categories[index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_categoryLabels[index]),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = _categories[index]);
              },
              selectedColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
              ),
              backgroundColor: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Widget _buildGiftCard(Gift gift) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showGiftDetail(gift),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightPink,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    gift.imageUrl,
                    style: const TextStyle(fontSize: 60),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gift.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    gift.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '¥${gift.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '+${gift.affectionBonus}好感',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGiftDetail(Gift gift) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.lightPink,
              ),
              child: Center(
                child: Text(
                  gift.imageUrl,
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gift.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    gift.description,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '¥${gift.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '好感度 +${gift.affectionBonus}',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _sendGift(gift),
                      child: const Text('赠送礼物'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendGift(Gift gift) async {
    Navigator.pop(context);
    
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final result = await walletProvider.sendGift(
      giftId: gift.id,
      giftPrice: gift.price,
      affectionBonus: gift.affectionBonus,
    );
    
    if (mounted) {
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['rewardTriggered'] == true
                ? '礼物已送出！EVE也为你准备了一份心意'
                : '礼物已送出'),
          ),
        );
      }
    }
  }
}
