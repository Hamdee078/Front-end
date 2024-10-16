class StudentModel {
  final String id;
  final String std_id;
  final String std_name;
  final String grammar;
  final String vocabulary;
  final String reading;
  final String listening;
  final String total;
  final String cefr;

  StudentModel({
    required this.id,
    required this.std_id,
    required this.std_name,
    required this.grammar,
    required this.vocabulary,
    required this.reading,
    required this.listening,
    required this.total,
    required this.cefr,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['_id'] ?? '',
      std_id: json['std_id'] ?? '',
      std_name: json['std_name'] ?? '',
      grammar: json['Grammar'] ?? '0',
      vocabulary: json['Vocabulary'] ?? '0',
      reading: json['Reading'] ?? '0',
      listening: json['Listening'] ?? '0',
      total: json['Total'] ?? '0',
      cefr: json['CEFR'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'std_id': std_id,
      'std_name': std_name,
      'Grammar': grammar,
      'Vocabulary': vocabulary,
      'Reading': reading,
      'Listening': listening,
      'Total': total,
      'CEFR': cefr,
    };
  }

  @override
  String toString() {
    return 'StudentModel{id: $id, std_id: $std_id, std_name: $std_name, grammar: $grammar, vocabulary: $vocabulary, reading: $reading, listening: $listening, total: $total, cefr: $cefr}';
  }
}
