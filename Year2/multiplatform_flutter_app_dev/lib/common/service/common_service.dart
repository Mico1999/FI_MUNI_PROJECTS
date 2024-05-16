import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_catalog/common/model/serializable.dart';
import 'package:movie_catalog/common/util/value_connectable_stream.dart';

class CommonService<T extends Serializable> {
  late CollectionReference<T> collection;
  late final all = collection
      .snapshots()
      .map((querySnapshot) =>
          querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList())
      .asValueConnectableStream();

  CommonService(String collectionPath) {
    collection =
        FirebaseFirestore.instance.collection(collectionPath).withConverter(
      fromFirestore: (snapshot, options) {
        final json = snapshot.data() ?? {};
        json['id'] = snapshot.id;
        return Serializable.fromJson(json) as T;
      },
      toFirestore: (T value, options) {
        final json = value.toJson();
        json.remove('id');
        return json;
      },
    );
  }

  Future<String> add(T t) async {
    var id = "";
    await collection.add(t).then((value) => id = value.id);
    await collection.doc(id).update({"id": id});
    return id;
  }

  Stream<T?> get(String id) =>
      collection.doc(id).snapshots().map((t) => t.data());

  // TODO: on delete cascade on movie/celebrity
  Future<void> delete(String id) {
    return collection.doc(id).delete();
  }
}
