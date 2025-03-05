class FormFieldDefinition {
  final String name;
  final String label;
  final String type;
  final String validation;

  FormFieldDefinition({
    required this.name,
    required this.label,
    required this.type,
    required this.validation,
  });

  // Pour sérialiser depuis JSON
  factory FormFieldDefinition.fromJson(Map<String, dynamic> json) {
    return FormFieldDefinition(
      name: json['name'],
      label: json['label'],
      type: json['type'],
      validation: json['validation'],
    );
  }
}
