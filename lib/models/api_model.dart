class ApiModel {
  final String id;
  final String firstName;
  final String lastName;
  final List<String> childs;
  final String? email;
  final String? password;

  ApiModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.childs,
    this.email,
    this.password,
  });

  factory ApiModel.fromJson(Map<String, dynamic> json) {
    return ApiModel(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      childs: List<String>.from(json['childs'] ?? []),
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'childs': childs,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
    };
  }

  ApiModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    List<String>? childs,
    String? email,
    String? password,
  }) {
    return ApiModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      childs: childs ?? this.childs,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}