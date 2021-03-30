class UserDao {
  int id;
  String username;
  String email;
  String firstName;
  String secondName;
  String birthdate;
  String photoPath;
  String gender;
  bool active;

  UserDao({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.secondName,
    this.birthdate,
    this.photoPath,
    this.gender,
    this.active,
  });

  factory UserDao.fromJson(Map<String, dynamic> parsedJson) {
    return UserDao(
      id: parsedJson["id"],
      username: parsedJson["username"],
      email: parsedJson["email"],
      firstName: parsedJson["firstName"],
      secondName: parsedJson["secondName"],
      birthdate: parsedJson["birthdate"],
      photoPath: parsedJson["photoPath"],
      gender: parsedJson["gender"],
      active: parsedJson["active"],
    );
  }
}
