import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestFirestore extends StatefulWidget {
  const TestFirestore({super.key});

  @override
  State<TestFirestore> createState() => _TestFirestoreState();
}

class _TestFirestoreState extends State<TestFirestore> {
  var db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: db.collection('users').snapshots(),
        builder: ((context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshots.hasError) {
            return const Center(
              child: Text('ERROR'),
            );
          }
          //OLAH DATA
          var _data = snapshots.data!.docs;

          return ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, index) {
              return ListTile(
                onLongPress: () {
                  //auto delete when long press
                  _data[index].reference.delete().then(
                        (value) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('ANJAY DI HAPUS'),
                          ),
                        ),
                      );

                  db.collection("cities").doc("DC").delete().then(
                        (doc) => print('Document Deleted!'),
                        onError: (e) => print('Error Updating document $e'),
                      );
                },
                subtitle: Text(_data[index].data()['born'].toString()),
                title: Text(_data[index].data()['first'] +
                    " " +
                    _data[index].data()['last']),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final user = <String, dynamic>{
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
          };

          db.collection("users").add(user).then((DocumentReference doc) =>
              print('DocumentSnapshot added with ID: ${doc.id}'));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
