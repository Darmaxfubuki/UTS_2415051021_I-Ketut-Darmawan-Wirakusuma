import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/mountain_model.dart';
import '../../providers/mountain_provider.dart';
import '../../providers/plan_provider.dart';

class MountainDetailScreen extends StatefulWidget {
  final MountainModel mountain;

  const MountainDetailScreen({super.key, required this.mountain});

  @override
  State<MountainDetailScreen> createState() => _MountainDetailScreenState();
}

class _MountainDetailScreenState extends State<MountainDetailScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _showAddPlanDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Rencana ke ${widget.mountain.name}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pilih Tanggal Pendakian:'),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Catatan / Perlengkapan',
                        hintText: 'Contoh: Bawa tenda 4P & logistik 3 hari',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final success = await context.read<PlanProvider>().addPlan(
                          mountainId: widget.mountain.id,
                          mountainName: widget.mountain.name,
                          targetDate: _selectedDate,
                          notes: _notesController.text.trim(),
                        );
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Rencana pendakian berhasil disimpan!'
                                : 'Gagal menyimpan rencana.',
                          ),
                          backgroundColor:
                              success ? Colors.teal : Colors.redAccent,
                        ),
                      );
                    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mountain.name),
        actions: [
          Consumer<MountainProvider>(
            builder: (context, provider, child) {
              final isFav = provider.isFavorite(widget.mountain.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () {
                  provider.toggleFavorite(widget.mountain.id);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.mountain.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 250,
                color: Colors.grey.shade300,
                child: const Icon(Icons.landscape, size: 60),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.mountain.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            widget.mountain.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${widget.mountain.location} • ${widget.mountain.elevation} mdpl',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                  const Divider(height: 32),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.mountain.description,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Chip(
                        avatar: const Icon(Icons.timer, size: 16),
                        label: Text(widget.mountain.estimatedTime),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        avatar: const Icon(Icons.terrain, size: 16),
                        label: Text(widget.mountain.difficulty),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _showAddPlanDialog,
          icon: const Icon(Icons.add_task),
          label: const Text(
            'Buat Rencana Pendakian',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}