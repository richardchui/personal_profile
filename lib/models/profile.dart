class Profile {
  final String id;
  final String password;
  final Map<String, dynamic> sections;

  const Profile({
    required this.id,
    required this.password,
    required this.sections,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      password: json['password'] as String,
      sections: Map<String, dynamic>.from(json['data'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'data': sections,
    };
  }

  Profile copyWith({
    String? id,
    String? password,
    Map<String, dynamic>? sections,
  }) {
    return Profile(
      id: id ?? this.id,
      password: password ?? this.password,
      sections: sections ?? this.sections,
    );
  }
}
