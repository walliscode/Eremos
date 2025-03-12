import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eremos/models/team.dart';
import 'package:flutter/material.dart';

class EditTeamMembers extends StatefulWidget {
  final Team team;
  const EditTeamMembers({required this.team});
  @override
  _EditTeamMembersState createState() => _EditTeamMembersState();
}

// This class is responsible for editing the members of a team
// It finds all users with no team associated with its ids
//
// this needs to consume the Stream to get the user uid. This then looks up the user in the users collection
// any users without a team id are presented as a list of users to add to the team

class _EditTeamMembersState extends State<EditTeamMembers> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final List<String> _members = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Team Members')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _addMember();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  _db
                      .collection('users')
                      .where('teamId', isNull: true)
                      .snapshots(),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No users found'));
                } else {
                  List<QueryDocumentSnapshot> users = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(users[index]['email']),
                        onTap: () {
                          _addMember(uid: users[index].id);
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.team.members.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(widget.team.members[index]),
                  onTap: () {
                    _removeMember(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addMember({String? uid}) {
    String email = _emailController.text;
    if (uid != null) {
      _members.add(uid);
    } else {
      _members.add(email);
    }
    setState(() {
      _emailController.clear();
    });
  }

  void _removeMember(int index) {
    setState(() {
      _members.removeAt(index);
    });
  }
}
