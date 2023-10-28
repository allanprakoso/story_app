import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String userId;
  final String name;
  final String token;

  User({required this.userId, required this.name, required this.token});

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'name': name,
        'token': token,
      };

  factory User.fromJson(json) => _$UserFromJson(json);
}
