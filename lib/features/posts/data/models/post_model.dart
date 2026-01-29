import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/post_entity.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final int id;
  @JsonKey(name: 'userId')
  final int userId;
  final String title;
  final String body;

  const PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}

extension PostModelMapper on PostModel {
  PostEntity toEntity({bool isLiked = false}) => PostEntity(
    id: id,
    userId: userId,
    title: title,
    body: body,
    isLiked: isLiked,
  );
}
