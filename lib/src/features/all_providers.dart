import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Services
import '../core/local/key_value_storage_service.dart';
import '../core/networking/firestore_service.dart';

final keyValueStorageServiceProvider = Provider<KeyValueStorageService>(
  (ref) => KeyValueStorageService(),
);

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firestoreDatabaseProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) {
    final firestoreDb = ref.watch(firestoreDatabaseProvider);
    return FirestoreService(firestoreDb);
  },
);
