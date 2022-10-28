import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/models/favorite.dart';

import '../models/event_detail.dart';

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static void addFavorite(EventDetail detail, String uid) {
    Favorite fav = Favorite(null, detail.id!, uid);
    db
        .collection("favorites")
        .add(fav.toMap())
        .then((value) => print(value))
        .catchError((err) => print(err));
  }

  static void deleteFavorite(String favId) {
    db.collection("favorites").doc(favId).delete();
  }

  static Future<List<Favorite>> getUserFavorite(String uid) async {
    var data = (await db
            .collection('favorites')
            .where('user_id', isEqualTo: uid)
            .get())
        .docs;
    var favorites = data.map((e) => Favorite.fromMap(e.data())).toList();
    for (int i = 0; i < favorites.length; i++) {
      favorites[i].id = data[i].id;
    }
    return favorites;
  }
}
