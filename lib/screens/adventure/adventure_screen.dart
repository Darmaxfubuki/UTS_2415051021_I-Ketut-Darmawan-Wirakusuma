import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/plan_model.dart';
import '../../providers/plan_provider.dart';

class AdventureScreen extends StatefulWidget {
  const AdventureScreen({super.key});

  @override
  State<AdventureScreen> createState() => _AdventureScreenState();
}

class _AdventureScreenState extends State<AdventureScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PlanProvider>().fetchPlans();
    });
  }

  void _showEditDialog(PlanModel plan) {
    DateTime updatedDate = plan.targetDate;
    String selectedStatus = plan.status;
    final notesCtrl = TextEditingController(text: plan.notes ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Edit Rencana ${plan.mountainName}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        '${updatedDate.day}/${updatedDate.month}/${updatedDate.year}',
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: updatedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            updatedDate = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      items: const [
                        DropdownMenuItem(value: 'Rencana', child: Text('Rencana')),
                        DropdownMenuItem(value: 'Berjalan', child: Text('Berjalan')),
                        DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedStatus = val;
                          });
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Status'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Catatan',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                  onPressed: () async {
                    await context.read<PlanProvider>().updatePlan(
                          id: plan.id,
                          targetDate: updatedDate,
                          status: selectedStatus,
                          notes: notesCtrl.text.trim(),
                        );
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Rencana'),
        content: const Text('Apakah Anda yakin ingin membatalkan rencana ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await context.read<PlanProvider>().deletePlan(id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rencana Pendakian'),
      ),
      body: RefreshIndicator(
        onRefresh: () => planProvider.fetchPlans(),
        child: planProvider.isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.teal))
            : planProvider.plans.isEmpty
                ? const Center(
                    child: Text('Belum ada rencana pendakian. Tambahkan dari katalog!'),
                  )
                : ListView.builder(
                    itemCount: planProvider.plans.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final item = planProvider.plans[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: Icon(Icons.terrain, color: Colors.white),
                          ),
                          title: Text(
                            item.mountainName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Tanggal: ${item.targetDate.day}/${item.targetDate.month}/${item.targetDate.year}\nCatatan: ${item.notes ?? "-"}\nStatus: ${item.status}',
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showEditDialog(item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDelete(item.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}