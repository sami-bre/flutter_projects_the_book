import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/models/event_detail.dart';
import 'package:events/models/favorite.dart';
import 'package:events/screens/login_screen.dart';
import 'package:events/shared/authentition.dart';
import 'package:events/shared/firestore_helper.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  String uid;
  EventScreen(this.uid, {super.key});
  final Authentication auth = Authentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              });
            },
          )
        ],
      ),
      body: EventList(uid),
    );
  }
}

class EventList extends StatefulWidget {
  final String uid;
  const EventList(this.uid, {super.key});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<EventDetail> details = [];
  List<Favorite> favorites = [];

  Future<List<EventDetail>> getDetailList() async {
    var data = (await db.collection('event_details').get()).docs;
    var detailList = data.map((e) => EventDetail.fromMap(e.data())).toList();
    // let's assign the corresponing dociment ids onto the eventDetail ids
    for (int i = 0; i < data.length; i++) {
      detailList[i].id = data[i].id;
    }
    return detailList;
  }

  bool isUserFavorite(EventDetail eventDetail) {
    Favorite? favorite;
    try {
      favorite =
          favorites.firstWhere((element) => element.eventId == eventDetail.id);
    } on Exception catch (e) {
      favorite = null;
    } finally {
      if (favorite == null) {
        return false;
      } else {
        return true;
      }
    }
  }

  @override
  void initState() {
    if (mounted) {
      getDetailList().then((value) {
        setState(() {
          details = value;
        });
      });
    }
    FirestoreHelper.getUserFavorite(widget.uid).then((value) {
      setState(() {
        favorites = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: details.length,
      itemBuilder: (context, index) {
        Color starColor =
            isUserFavorite(details[index]) ? Colors.amber : Colors.grey;
        var sub = "Date: ${details[index].date} - "
            "Start: ${details[index].startTime} - "
            "End: ${details[index].endTime}";
        return ListTile(
          title: Text(details[index].description),
          subtitle: Text(sub),
          trailing: IconButton(
            icon: Icon(
              Icons.star,
              color: starColor,
            ),
            onPressed: () => toggleFavorite(details[index]),
          ),
        );
      },
    );
  }

  void toggleFavorite(EventDetail ed) async {
    if (isUserFavorite(ed)) {
      // this should not throw error because the ed is already a favorite.
      Favorite favorite =
          favorites.firstWhere((element) => (element.eventId == ed.id));
      FirestoreHelper.deleteFavorite(favorite.id!);
    } else {
      FirestoreHelper.addFavorite(ed, widget.uid);
    }
    var updatedFavorites = await FirestoreHelper.getUserFavorite(widget.uid);
    setState(() {
      favorites = updatedFavorites;
    });
  }
}
