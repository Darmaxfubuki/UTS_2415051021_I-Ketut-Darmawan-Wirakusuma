import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/mountain_model.dart';
import '../../providers/plan_provider.dart';

class CreatePlanScreen extends StatefulWidget {
  final MountainModel mountain;

  const CreatePlanScreen({super.key, required this.mountain});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _teamSizeController = TextEditingController(text: '1');
  bool _isSubmitting = false;

  @override
  void dispose() {
    _notesController.dispose();
    _teamSizeController.dispose();
    super.dispose();
  }

  Future<void> _submitPlan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final fullNotes =
        'Anggota: ${_teamSizeController.text.trim()} orang. Catatan: ${_notesController.text.trim()}';

    final success = await context.read<PlanProvider>().addPlan(
          mountainId: widget.mountain.id,
          mountainName: widget.mountain.name,
          targetDate: _selectedDate,
          notes: fullNotes,
        );

    setState(() => _isSubmitting = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rencana pendakian berhasil dibuat!'),
            backgroundColor: Colors.teal,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan rencana ke database.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Rencana: ${widget.mountain.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 0,
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.mountain.imageUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.terrain, size: 50, color: Colors.teal),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.mountain.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.mountain.location} • ${widget.mountain.elevation} mdpl',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              'Tingkat: ${widget.mountain.difficulty}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tanggal Target Pendakian *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_month, color: Colors.teal),
                label: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Jumlah Anggota Rombongan *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _teamSizeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Contoh: 4',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.groups),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Jumlah anggota wajib diisi';
                  }
                  final n = int.tryParse(val);
                  if (n == null || n <= 0) {
                    return 'Masukkan jumlah anggota yang valid (minimal 1)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Catatan Tambahan & Perlengkapan *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Bawa tenda dome 4P, gas portable, nesting, dan P3K',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Catatan atau rencana logistik wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _submitPlan,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _isSubmitting ? 'Menyimpan...' : 'Simpan Rencana Pendakian',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}