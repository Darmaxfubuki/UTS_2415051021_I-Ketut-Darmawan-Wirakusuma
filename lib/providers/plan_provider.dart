import 'package:flutter/material.dart';
import '../models/plan_model.dart';
import '../services/plan_service.dart';

class PlanProvider with ChangeNotifier {
  final PlanService _planService = PlanService();
  List<PlanModel> _plans = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PlanModel> get plans => _plans;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPlans() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _plans = await _planService.fetchPlans();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addPlan({
    required String mountainId,
    required String mountainName,
    required DateTime targetDate,
    String? notes,
  }) async {
    try {
      await _planService.addPlan(
        mountainId: mountainId,
        mountainName: mountainName,
        targetDate: targetDate,
        notes: notes,
      );
      await fetchPlans();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePlan({
    required String id,
    required DateTime targetDate,
    required String status,
    String? notes,
  }) async {
    try {
      await _planService.updatePlan(
        id: id,
        targetDate: targetDate,
        status: status,
        notes: notes,
      );
      await fetchPlans();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deletePlan(String id) async {
    try {
      await _planService.deletePlan(id);
      _plans.removeWhere((item) => item.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}