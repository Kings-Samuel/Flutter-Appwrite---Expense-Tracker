class User {
  String? id;
  String? name;
  String? email;
  int? registration;
  // List<String>? roles;

  User({
    this.id,
    this.name,
    this.email,
    this.registration,
    // this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["\$id"],
        name: json["name"],
        email: json["email"],
        registration: json["registration"],
        // roles: json["roles"].cast<String>(),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['\$id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['registration'] = registration;
    // data['roles'] = roles;

    return data;
  }
}
