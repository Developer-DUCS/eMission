class User {
  //generated ID
  int? userID;
  String email;
  String password;
  String? profilePicture;
  String levelStatus;
  String firstName;
  String lastName;

  User({
    this.userID,
    required this.email,
    required this.password,
    this.profilePicture,
    required this.levelStatus,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userID: json['userID'],
        email: json['email'],
        password: json['password'],
        profilePicture: json['profilePicture'],
        levelStatus: json['levelStatus'],
        firstName: json['firstName'],
        lastName: json['lastName'],
      );

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'email': email,
        'password': password,
        'profilePicture': profilePicture,
        'levelStatus': levelStatus,
        'firstName': firstName,
        'lastName': lastName,
      };
}
