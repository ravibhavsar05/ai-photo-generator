class GenerativeAiModel {
  final String? id;
  final String? prompt;
  final String? template;
  final String? name;
  final bool? isprem;

  GenerativeAiModel({this.id, this.prompt, this.template, this.name, this.isprem});

  factory GenerativeAiModel.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return GenerativeAiModel(
      id: id,
      prompt: data['prompt'] as String?,
      template: data['template'] as String?,
      name: data['name'] as String?,
      isprem: data['isprem'] as bool?,
    );
  }

  factory GenerativeAiModel.fromJson(Map<String, dynamic> json) {
    return GenerativeAiModel(
      id: json['id'] as String?,
      prompt: json['prompt'] as String?,
      template: json['template'] as String?,
      name: json['name'] as String?,
      isprem: json['isprem'] as bool?,
    );
  }
}
