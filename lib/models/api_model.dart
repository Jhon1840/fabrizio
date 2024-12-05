class ApiModel {
  final String id;
  final String firstName;
  final String lastName;
  final List<String> childs;
  final String? name;
  final String? edad;
  final String? deporte;
  final String? createdAt;

  ApiModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.childs,
    this.name,
    this.edad,
    this.deporte,
    this.createdAt,
  });

  factory ApiModel.fromJson(Map<String, dynamic> json) {
    return ApiModel(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      childs: List<String>.from(json['childs'] ?? []),
      name: json['name'],
      edad: json['edad'],
      deporte: json['deporte'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'childs': childs,
      'name': name,
      'edad': edad,
      'deporte': deporte,
      'createdAt': createdAt,
    };
  }
}