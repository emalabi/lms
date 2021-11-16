import 'package:cloud_firestore/cloud_firestore.dart';

class CreateQuiz {
  String id;
  String dueDate;
  String status;
  String title;
  String openDate;
  DocumentReference reference;

  CreateQuiz({
    this.id,
    this.status,
    this.dueDate,
    this.title,
    this.openDate,
    this.reference,
  });

  factory CreateQuiz.fromSnapshot(DocumentSnapshot snapshot) {
    CreateQuiz newQuiz = CreateQuiz.fromJson(snapshot.data());
    newQuiz.reference = snapshot.reference;
    return newQuiz;
  }

  factory CreateQuiz.fromJson(Map<String, dynamic> json) =>
      _questionFromJson(json);

  Map<String, dynamic> toJson() => _questionToJson(this);

  @override
  String toString() => "CreateQuiz<$title>";
}

CreateQuiz _questionFromJson(Map<String, dynamic> json) {
  return CreateQuiz(
    id: json['id'] as String,
    title: json['title'] as String,
    status: json['status'] as String,
    openDate: json['openDate'] as String,
    dueDate: json['dueDate'] as String,
  );
}

Map<String, dynamic> _questionToJson(CreateQuiz instance) => <String, dynamic>{
      'id': instance.id,
      'openDate': instance.openDate,
      'title': instance.title,
      'status': instance.status,
      'dueDate': instance.dueDate,
    };
