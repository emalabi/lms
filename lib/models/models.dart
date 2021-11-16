import 'package:cloud_firestore/cloud_firestore.dart';

class Model {
  String id;
  String createdBy;
  String details;
  String title;
  String imageUrl;
  Timestamp createdAt;

  Model({
    this.id,
    this.imageUrl,
    this.createdBy,
    this.title,
    this.details,
    this.createdAt,
  });

  Model.fromDocumentSnapshot({DocumentSnapshot doc}) {
    id = doc.id;
    createdBy = doc.get("createdBy");
    details = doc.get('details');
    imageUrl = doc.get("imageUrl");
    title = doc.get("title");
    createdBy = doc.get('createdAt');
  }
  Model.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    createdBy = data['createdBy'];
    details = data['details'];
    title = data['title'];
    imageUrl = data['imageUrl'];
    createdAt = data['createdAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'details': details,
      'title': title,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }
}
