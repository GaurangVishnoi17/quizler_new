class User {
  final int id;
  final String firstname;
  final String lastname;
  final String email;

  User(this.id, this.firstname, this.lastname, this.email);
  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['id'], json['firstname'], json['lastname'], json['email']);
  }
}
