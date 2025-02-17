import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  final String id;
  final Map<String, String> sections;

  Profile({
    required this.id,
    required this.sections,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
