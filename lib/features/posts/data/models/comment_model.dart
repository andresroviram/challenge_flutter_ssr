import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/comment_entity.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final int id;
  @JsonKey(name: 'postId')
  final int postId;
  final String name;
  final String email;
  final String body;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  CommentEntity toEntity() => CommentEntity(
    id: id,
    postId: postId,
    name: name,
    email: email,
    body: body,
  );
}
