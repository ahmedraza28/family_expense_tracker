import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../helpers/typedefs.dart';

part 'firestore_service.codegen.g.dart';

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) => FirebaseAuth.instance;

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
FirestoreService firestoreService(FirestoreServiceRef ref) {
  return const FirestoreService();
}

class FirestoreService {
  static final FirebaseFirestore _firestoreDb = FirebaseFirestore.instance;

  const FirestoreService();

  /// Sets the data for the document/collection existing
  /// at the provided path.
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = _firestoreDb.doc(path);
    debugPrint(path);
    await reference.set(data, SetOptions(merge: merge));
  }

  /// Checks if the document/collection exists
  /// at the provided path.
  Future<bool> checkDocument({required String path}) async {
    final reference = _firestoreDb.doc(path);
    final snapshot = await reference.get();
    debugPrint('$path exists: ${snapshot.exists}');
    return snapshot.exists;
  }

  /// Deletes the document/collection existing at the
  /// provided path.
  Future<void> deleteData({required String path}) async {
    final reference = _firestoreDb.doc(path);
    debugPrint('delete: $path');
    await reference.delete();
  }

  /// Updates data in a single document existing at the provided
  /// path by performing the changes according to the supplied
  /// changes map.
  Future<void> documentAction({
    required String path,
    required Map<String, dynamic> changes,
  }) async {
    debugPrint(path);

    final docRef = _firestoreDb.doc(path);

    await docRef.update(changes);
  }

  /// Updates data in a list of documents of a single collection
  /// existing at the provided path. The documents are filtered by
  /// the queryBuilder and updated by performing the changes according
  /// to the supplied changes map.
  Future<void> batchUpdate({
    required String path,
    required Map<String, dynamic> changes,
    QueryBuilder queryBuilder,
  }) async {
    final batchUpdate = _firestoreDb.batch();
    debugPrint(path);
    Query<JSON> query = _firestoreDb.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }

    final querySnapshot = await query.get();

    for (final DocumentSnapshot<JSON> ds in querySnapshot.docs) {
      batchUpdate.update(ds.reference, changes);
    }
    await batchUpdate.commit();
  }

  /// Bulk adds a list of documents to a single collection
  /// existing at the provided path. 
  Future<void> batchAdd({
    required String path,
    required List<JSON> data,
  }) async {
    final batchUpdate = _firestoreDb.batch();
    debugPrint(path);

    for (final doc in data) {
      final docRef = _firestoreDb.collection(path).doc();
      batchUpdate.update(docRef, doc);
    }
    await batchUpdate.commit();
  }

  /// Returns a stream of collection mapped to a list of type T,
  /// existing at the provided path and filtered using the queryBuilder.
  Stream<List<T>> collectionStream<T>({
    required String path,
    required SnapshotBuilder<T> builder,
    QueryBuilder queryBuilder,
    Sorter<T> sort,
  }) {
    Query<JSON> query = _firestoreDb.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  /// Returns a future of collection mapped to a list of type T,
  /// existing at the provided path and filtered using the queryBuilder.
  Future<List<T>> collectionFuture<T>({
    required String path,
    required SnapshotBuilder<T> builder,
    QueryBuilder queryBuilder,
    Sorter<T> sort,
  }) async {
    Query<JSON> query = _firestoreDb.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final snapshot = await query.get();
    final result = snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .where((value) => value != null)
        .toList();
    if (sort != null) {
      result.sort(sort);
    }
    return result;
  }

  /// Returns a stream of document mapped to a list of type T,
  /// existing at the provided path.
  Stream<T> documentStream<T>({
    required String path,
    required SnapshotBuilder<T> builder,
  }) {
    final reference = _firestoreDb.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }
}
