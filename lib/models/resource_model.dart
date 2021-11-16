import 'package:cloud_firestore/cloud_firestore.dart';

class ResourcesModel {
  String id;
  String filename;
  String url;
  String createdBy;
  Timestamp createdAt;

  ResourcesModel();

  ResourcesModel.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    filename = data['filename'];
    url = data['url'];
    createdBy = data['createdBy'];
    createdAt = data['createdAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filename': filename,
      'url': url,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }
}
