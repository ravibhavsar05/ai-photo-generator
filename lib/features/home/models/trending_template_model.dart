class TrendingTemplateModel {
  final String id;
  final String template;
  final String prompt;
  final bool isprem;

  TrendingTemplateModel({
    required this.id,
    required this.template,
    required this.prompt,
    required this.isprem,
  });

  factory TrendingTemplateModel.fromFirestore(
      Map<String, dynamic> data, String id) {
    return TrendingTemplateModel(
      id: id,
      prompt: data['prompt'] ?? '',
      template: data['template'] ?? '',
      isprem: data['isprem'] ?? false,
    );
  }

  factory TrendingTemplateModel.fromJson(Map<String, dynamic> json) {
    return TrendingTemplateModel(
      id: json['id'] as String? ?? '',
      prompt: json['prompt'] as String? ?? '',
      template: json['template'] as String? ?? '',
      isprem: json['isprem'] as bool? ?? false,
    );
  }
}