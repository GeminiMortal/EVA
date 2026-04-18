import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../theme/app_theme.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('心意钱包'),
      ),
      body: RefreshIndicator(
        onRefresh: () => walletProvider.loadWalletInfo(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildBalanceCard(walletProvider),
            const SizedBox(height: 20),
            _buildActionsRow(),
            const SizedBox(height: 24),
            if (walletProvider.pendingReward > 0)
              _buildRewardCard(walletProvider.pendingReward),
            const SizedBox(height: 24),
            _buildTransactionSection(walletProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(WalletProvider walletProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.darkPink],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '心意余额',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '¥${walletProvider.balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('总存入', walletProvider.totalDeposited),
              _buildStatItem('已送礼', walletProvider.totalGifted),
              _buildStatItem('已兑付', walletProvider.totalRedeemed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, double value) {
    return Column(
      children: [
        Text(
          '¥${value.toStringAsFixed(0)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.savings,
            label: '存入心意',
            onTap: () => _showDepositDialog(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.redeem,
            label: '兑付心意',
            onTap: () => _showRedeemDialog(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightPink,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardCard(double amount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.card_giftcard,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎁 EVE的心意回馈',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '¥$amount 待兑付',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showRedeemDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('去兑付'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionSection(WalletProvider walletProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '最近动态',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (walletProvider.transactions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                '还没有交易记录',
                style: TextStyle(
                  color: AppTheme.textLight,
                ),
              ),
            ),
          )
        else
          ...walletProvider.transactions.map((transaction) {
            return _buildTransactionItem(transaction);
          }).toList(),
      ],
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isPositive = !['gift', 'redeem_cash', 'redeem_goods'].contains(transaction.type);
    
    IconData icon;
    String label;
    switch (transaction.type) {
      case 'deposit':
        icon = Icons.savings;
        label = '心意存入';
        break;
      case 'gift':
        icon = Icons.card_giftcard;
        label = '赠送礼物';
        break;
      case 'reward':
        icon = Icons.card_giftcard;
        label = '心意回馈';
        break;
      case 'redeem_cash':
        icon = Icons.money;
        label = '现金兑付';
        break;
      case 'redeem_goods':
        icon = Icons.local_shipping;
        label = '实物兑付';
        break;
      default:
        icon = Icons.swap_horiz;
        label = '其他';
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isPositive
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : AppTheme.lightPink,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isPositive ? AppTheme.primaryColor : AppTheme.secondaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : '-'}¥${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isPositive ? Colors.green : AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${transaction.timestamp.month}/${transaction.timestamp.day}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDepositDialog() {
    showDialog(
      context: context,
      builder: (context) => _DepositDialog(),
    );
  }

  void _showRedeemDialog() {
    showDialog(
      context: context,
      builder: (context) => _RedeemDialog(),
    );
  }
}

class _DepositDialog extends StatefulWidget {
  @override
  __DepositDialogState createState() => __DepositDialogState();
}

class __DepositDialogState extends State<_DepositDialog> {
  final TextEditingController _amountController = TextEditingController();
  final List<double> _presetAmounts = [50, 100, 200, 500];
  int _selectedPreset = -1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('存入心意'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: '存入金额',
              prefixText: '¥',
            ),
            onChanged: (_) => setState(() => _selectedPreset = -1),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: List.generate(_presetAmounts.length, (index) {
              return ChoiceChip(
                label: Text('¥${_presetAmounts[index]}'),
                selected: _selectedPreset == index,
                onSelected: (selected) {
                  setState(() {
                    _selectedPreset = selected ? index : -1;
                    if (selected) {
                      _amountController.text = _presetAmounts[index].toString();
                    }
                  });
                },
              );
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('确认存入'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;
    
    setState(() => _isLoading = true);
    
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final result = await walletProvider.deposit(amount);
    
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
      
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('订单已创建')),
        );
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}

class _RedeemDialog extends StatefulWidget {
  @override
  __RedeemDialogState createState() => __RedeemDialogState();
}

class __RedeemDialogState extends State<_RedeemDialog> {
  String _selectedType = 'cash';
  
  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    
    return AlertDialog(
      title: const Text('兑付心意'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('可兑付金额: ¥${walletProvider.pendingReward.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          const Text('选择兑付方式:'),
          const SizedBox(height: 8),
          RadioListTile(
            title: const Text('现金兑付'),
            subtitle: const Text('原路退回支付账户'),
            value: 'cash',
            groupValue: _selectedType,
            onChanged: (value) => setState(() => _selectedType = value!),
          ),
          RadioListTile(
            title: const Text('实物兑付'),
            subtitle: const Text('兑换暖心文创周边'),
            value: 'goods',
            groupValue: _selectedType,
            onChanged: (value) => setState(() => _selectedType = value!),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('确认兑付'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final result = await walletProvider.redeemReward(_selectedType);
    
    if (mounted) {
      Navigator.pop(context);
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('兑付申请已提交')),
        );
      }
    }
  }
}
