// User is going to be the base class which is extended for AppUser and CloudbaseUser
//

class User {
  User({required this.uid});
  final String uid;
}

class AppUser extends User {
  final String email;
  // is Ben logged in will check the email of the user and if it is ben then it will return true
  final bool isBenLoggedIn;
  final bool isZacLoggedIn;
  AppUser({required super.uid, required this.email})
    : isBenLoggedIn = email == 'ben@test.com',
      isZacLoggedIn = email == 'zac@test.com';
}

class CloudbaseUser extends User {
  final String displayName;
  String? teamId;

  CloudbaseUser({required super.uid, required this.displayName, this.teamId});
}
