import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../data/providers/cashbook_provider.dart';
import '../../data/providers/language_provider.dart';

class CashbookTab extends StatefulWidget {
  const CashbookTab({super.key});
  @override
  State<CashbookTab> createState() => _CashbookTabState();
}

class _CashbookTabState extends State<CashbookTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CashbookProvider>().load();
    });
  }

  void _addDialog(BuildContext context) {
    final desc = TextEditingController();
    final amount = TextEditingController();
    String type = 'EXPENSE';
    String category = 'EVENT';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setS) {
        return AlertDialog(
          backgroundColor: Theme.of(ctx).cardTheme.color,
          title: const Text('New Transaction', style: TextStyle(color: AppColors.gold)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: desc,
                decoration: const InputDecoration(hintText: 'Description (e.g. Fikhulmuyaser 20x80)')),
            const SizedBox(height: 10),
            TextField(
                controller: amount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Amount')),
            const SizedBox(height: 10),
            Row(children: [
              ChoiceChip(label: const Text('Expense'), selected: type == 'EXPENSE',
                  onSelected: (_) => setS(() => type = 'EXPENSE')),
              const SizedBox(width: 8),
              ChoiceChip(label: const Text('Income'), selected: type == 'INCOME',
                  onSelected: (_) => setS(() => type = 'INCOME')),
            ]),
            const SizedBox(height: 8),
            Wrap(spacing: 6, children: ['EVENT', 'OTHER', 'EDUCATION', 'CHARITY', 'OPERATIONAL'].map((c) {
              return ChoiceChip(
                label: Text(c),
                selected: category == c,
                onSelected: (_) => setS(() => category = c),
              );
            }).toList()),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (desc.text.isEmpty || amount.text.isEmpty) return;
                await context.read<CashbookProvider>().create({
                  'type': type,
                  'category': category,
                  'amount': double.tryParse(amount.text) ?? 0,
                  'description': desc.text,
                });
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<CashbookProvider>();
    final lang = context.watch<LanguageProvider>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final s = prov.summary;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _addDialog(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('+ New'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              _summary(lang.t('total_in'), s?.totalIn ?? 0, AppColors.green, dark),
              const SizedBox(width: 8),
              _summary(lang.t('total_out'), s?.totalOut ?? 0, AppColors.red, dark),
              const SizedBox(width: 8),
              _summary(lang.t('balance'), s?.balance ?? 0, AppColors.gold, dark),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: prov.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
              : prov.transactions.isEmpty
                  ? const Center(child: Text('No transactions'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: prov.transactions.length,
                      itemBuilder: (context, i) {
                        final t = prov.transactions[i];
                        final isExpense = t.type == 'EXPENSE';
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: (isExpense ? AppColors.red : AppColors.green).withOpacity(0.18),
                              child: Icon(isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                                  color: isExpense ? AppColors.red : AppColors.green, size: 20),
                            ),
                            title: Text(t.description,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            subtitle: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.gold.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(t.category,
                                      style: const TextStyle(color: AppColors.gold, fontSize: 10)),
                                ),
                                const SizedBox(width: 8),
                                Text(DateFormat('MMM d').format(t.transactionDate),
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                                const SizedBox(width: 8),
                                Text(t.userInitials,
                                    style: const TextStyle(fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.w700)),
                              ],
                            ),
                            trailing: Text(
                              '${isExpense ? '-' : '+'}${NumberFormat('#,###').format(t.amount)}',
                              style: TextStyle(
                                  color: isExpense ? AppColors.red : AppColors.green,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _summary(String label, double value, Color color, bool dark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: dark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(
              NumberFormat('#,###').format(value),
              style: TextStyle(
                  color: color, fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
