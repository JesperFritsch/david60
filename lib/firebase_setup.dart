import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';


// if you want to test the app as web on a different device than the one running the server, you need to
// replace 'localhost' with the IP address of the server
// if not testing on a different device, you can use 'localhost'

final localAddress = 'localhost';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    await FirebaseAuth.instance.useAuthEmulator(localAddress, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(localAddress, 8080);
    FirebaseStorage.instance.useStorageEmulator(localAddress, 9199);
  }
}