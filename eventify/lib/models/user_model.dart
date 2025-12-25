class User {
  final int id;
  final String email;
  final String username;
  final String name;
  final String lastname;
  final String? dateOfBirth;
  final bool? isCertified;
  final String? photo;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    required this.lastname,
    this.dateOfBirth,
    this.isCertified,
    this.photo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      dateOfBirth: json['date_of_birth'],
      isCertified: json['is_certified'] is int 
          ? json['is_certified'] == 1 
          : json['is_certified'],
      photo: json['photo'],
    );
  }

  String get fullName {
    if (name.isEmpty && lastname.isEmpty) return username;
    return '$name $lastname'.trim();
  }
}