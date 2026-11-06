import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/plan_model.dart';

class PlanService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // READ: Ambil seluruh rencana pendakian
  Future<List<PlanModel>> fetchPlans() async {
    final response = await _supabase
        .from('user_plans')
        .select()
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((e) => PlanModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // CREATE: Tambah rencana baru
  Future<void> addPlan({
    required String mountainId,
    required String mountainName,
    required DateTime targetDate,
    String? notes,
  }) async {
    await _supabase.from('user_plans').insert({
      'mountain_id': mountainId,
      'mountain_name': mountainName,
      'target_date': targetDate.toIso8601String().split('T')[0],
      'notes': notes,
      'status': 'Rencana',
    });
  }

  // UPDATE: Ubah data rencana
  Future<void> updatePlan({
    required String id,
    required DateTime targetDate,
    required String status,
    String? notes,
  }) async {
    await _supabase.from('user_plans').update({
      'target_date': targetDate.toIso8601String().split('T')[0],
      'status': status,
      'notes': notes,
    }).eq('id', id);
  }

  // DELETE: Hapus rencana
  Future<void> deletePlan(String id) async {
    await _supabase.from('user_plans').delete().eq('id', id);
  }
}