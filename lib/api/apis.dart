import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs{
  // authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  // accessing cloud firesteore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
}