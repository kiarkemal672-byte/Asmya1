import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/asmya_app_bar.dart';
import '../../data/providers/plan_provider.dart';
import '../../data/providers/language_provider.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});
  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(() {
      if (_tab.indexIsChanging) return;
      if (_tab.index == 1) context.read<PlanProvider>().loadReports();
      if (_tab.index == 2) context.read<PlanProvider>().loadPlans();
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlanProvider>().loadPlans();
    });
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  Color _statusColor(String status) {
    switch (status) {
      case 'PENDING': return AppColors.yellow;
      case 'IN_PROGRESS': return AppColors.blue;
      case 'COMPLETED': return AppColors.green;
      case 'CANCELLED': return AppColors.red;
      default: return AppColors.gold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<PlanProvider>();
    final lang = context.watch<LanguageProvider>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AsmyaAppBar(title: lang.t('plans')),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: dark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: dark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: TabBar(
              controller: _tab,
              indicator: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              tabs: [
                Tab(text: lang.t('plans')),
                Tab(text: lang.t('reports')),
                Tab(text: lang.t('cashbook')),
              ],
            ),
          ),
          Expanded(child: _buildBody(prov, dark)),
        ],
      ),
    );
  }

  Widget _buildBody(PlanProvider prov, bool dark) {
    switch (_tab.index) {
      case 0: return _plansTab(prov, dark);
      case 1: return _reportsTab(prov, dark);
      case 2: return _cashbookTab(dark);
      default: return const SizedBox();
    }
  }

  Widget _plansTab(PlanProvider prov, bool dark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _showPlanDialog(context),
              icon: const Icon(Icons.add, size: 18),
              label: Text(context.read<LanguageProvider>().t('new_plan')),
            ),
          ),
        ),
        Expanded(
          child: prov.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
              : prov.plans.isEmpty
                  ? const Center(child: Text('No plans yet'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: prov.plans.length,
                      itemBuilder: (context, i) {
                        final p = prov.plans[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                            title: Text(p.title,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            subtitle: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _statusColor(p.status).withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(p.status,
                                      style: TextStyle(
                                          color: _statusColor(p.status),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 10)),
                                ),
                                const SizedBox(width: 8),
                                if (p.dueDate != null)
                                  Text(DateFormat('MMM d').format(p.dueDate!),
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (p.description != null) ...[
                                      Text(p.description!,
                                          style: TextStyle(fontSize: 13)),
                                      const SizedBox(height: 8),
                                    ],
                                    Wrap(
                                      spacing: 6,
                                      children: p.assigneeTags
                                          .map((t) => Chip(
                                                label: Text(t, style: const TextStyle(fontSize: 11)),
                                                backgroundColor: AppColors.gold.withOpacity(0.15),
                                                labelStyle: const TextStyle(color: AppColors.gold),
                                              ))
                                          .toList(),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.report_gmailerrorred,
                                            color: AppColors.gold, size: 16),
                                        const SizedBox(width: 4),
                                        Text('${p.reportCount} reports'),
                                        const Spacer(),
                                        ElevatedButton(
                                          onPressed: () => prov.updateStatus(p.id, 'IN_PROGRESS'),
                                          child: const Text('Start', style: TextStyle(fontSize: 12)),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: AppColors.red, size: 20),
                                          onPressed: () => prov.deletePlan(p.id),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _reportsTab(PlanProvider prov, bool dark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _showReportDialog(context),
              icon: const Icon(Icons.add, size: 18),
              label: Text(context.read<LanguageProvider>().t('new_report')),
            ),
          ),
        ),
        Expanded(
          child: prov.reports.isEmpty
              ? const Center(child: Text('No reports yet'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: prov.reports.length,
                  itemBuilder: (context, i) {
                    final r = prov.reports[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.gold.withOpacity(0.15),
                          child: Text(r.authorInitials,
                              style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800)),
                        ),
                        title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text('${r.authorName} • ${DateFormat('MMM d').format(r.createdAt)}',
                            style: const TextStyle(fontSize: 12)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.red, size: 20),
                          onPressed: () => prov.deleteReport(r.id),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _cashbookTab(bool dark) {
    return Consumer<_CashbookProxy>(builder: (context, proxy, _) {
      // Placeholder until cashbook provider is wired; use direct consumer below.
      return const SizedBox();
    });
  }

  void _showPlanDialog(BuildContext context) {
    final title = TextEditingController();
    final desc = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: const Text('New Plan', style: TextStyle(color: AppColors.gold)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: title, decoration: const InputDecoration(hintText: 'Plan title')),
          const SizedBox(height: 12),
          TextField(
              controller: desc,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Description')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (title.text.isEmpty) return;
              await context.read<PlanProvider>().createPlan({
                'title': title.text,
                'description': desc.text,
                'assignee_tags': ['UJ Ustaz Jihad', 'IM Imran Mohammed'],
              });
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    final title = TextEditingController();
    final content = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: const Text('New Report', style: TextStyle(color: AppColors.gold)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: title, decoration: const InputDecoration(hintText: 'Title')),
          const SizedBox(height: 12),
          TextField(
              controller: content,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Content')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (title.text.isEmpty || content.text.isEmpty) return;
              await context.read<PlanProvider>().createReport({
                'title': title.text,
                'content': content.text,
              });
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _CashbookProxy extends ChangeNotifier {}
