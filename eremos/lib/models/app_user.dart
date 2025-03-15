// User is going to be the base class which is extended for AppUser and CloudbaseUser
//

class User {
  User({required this.uid});
  final String uid;
}

class AppUser extends User {
  AppUser({required super.uid, required this.email});

  final String email;
}

class CloudbaseUser extends User {
  final String displayName;
  String? teamId;

  CloudbaseUser({required super.uid, required this.displayName, this.teamId});
}
