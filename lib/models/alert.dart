import 'package:cloud_firestore/cloud_firestore.dart';

class Alert{
  String type;
  DateTime dateCreated;
  String userName;
  String userId;
  String alertId;

  Alert({
    required this.type,
    required this.dateCreated,
    required this.userName,
    required this.userId,
    required this.alertId
  });
}

alertDataToAlert(DocumentSnapshot<Map<String, dynamic>> doc){
  Map<String, dynamic> data = doc.data()!;
  return Alert(
    type: data['type'],
    alertId: doc.id,
    dateCreated: data['date_created'].toDate(),
    userName: data['user_name'],
    userId: data['user_id']
  );
}