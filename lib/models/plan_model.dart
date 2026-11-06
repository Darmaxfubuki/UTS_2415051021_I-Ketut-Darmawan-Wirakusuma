class PlanModel {
  final String id;
  final String mountainId;
  final String mountainName;
  final DateTime targetDate;
  final String? notes;
  final String status;

  PlanModel({
    required this.id,
    required this.mountainId,
    required this.mountainName,
    required this.targetDate,
    this.notes,
    this.status = 'Rencana',
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as String,
      mountainId: json['mountain_id'] as String,
      mountainName: json['mountain_name'] as String,
      targetDate: DateTime.parse(json['target_date'] as String),
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? 'Rencana',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mountain_id': mountainId,
      'mountain_name': mountainName,
      'target_date': targetDate.toIso8601String().split('T')[0],
      'notes': notes,
      'status': status,
    };
  }
}