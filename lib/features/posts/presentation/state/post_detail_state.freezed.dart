// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PostDetailState()';
}


}

/// @nodoc
class $PostDetailStateCopyWith<$Res>  {
$PostDetailStateCopyWith(PostDetailState _, $Res Function(PostDetailState) __);
}


/// Adds pattern-matching-related methods to [PostDetailState].
extension PostDetailStatePatterns on PostDetailState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PostDetailInitial value)?  initial,TResult Function( PostDetailLoading value)?  loading,TResult Function( PostDetailSuccess value)?  success,TResult Function( PostDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PostDetailInitial() when initial != null:
return initial(_that);case PostDetailLoading() when loading != null:
return loading(_that);case PostDetailSuccess() when success != null:
return success(_that);case PostDetailError() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PostDetailInitial value)  initial,required TResult Function( PostDetailLoading value)  loading,required TResult Function( PostDetailSuccess value)  success,required TResult Function( PostDetailError value)  error,}){
final _that = this;
switch (_that) {
case PostDetailInitial():
return initial(_that);case PostDetailLoading():
return loading(_that);case PostDetailSuccess():
return success(_that);case PostDetailError():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PostDetailInitial value)?  initial,TResult? Function( PostDetailLoading value)?  loading,TResult? Function( PostDetailSuccess value)?  success,TResult? Function( PostDetailError value)?  error,}){
final _that = this;
switch (_that) {
case PostDetailInitial() when initial != null:
return initial(_that);case PostDetailLoading() when loading != null:
return loading(_that);case PostDetailSuccess() when success != null:
return success(_that);case PostDetailError() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( PostEntity post,  List<CommentEntity> comments,  bool isTogglingLike)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PostDetailInitial() when initial != null:
return initial();case PostDetailLoading() when loading != null:
return loading();case PostDetailSuccess() when success != null:
return success(_that.post,_that.comments,_that.isTogglingLike);case PostDetailError() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( PostEntity post,  List<CommentEntity> comments,  bool isTogglingLike)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case PostDetailInitial():
return initial();case PostDetailLoading():
return loading();case PostDetailSuccess():
return success(_that.post,_that.comments,_that.isTogglingLike);case PostDetailError():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( PostEntity post,  List<CommentEntity> comments,  bool isTogglingLike)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case PostDetailInitial() when initial != null:
return initial();case PostDetailLoading() when loading != null:
return loading();case PostDetailSuccess() when success != null:
return success(_that.post,_that.comments,_that.isTogglingLike);case PostDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class PostDetailInitial implements PostDetailState {
  const PostDetailInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PostDetailState.initial()';
}


}




/// @nodoc


class PostDetailLoading implements PostDetailState {
  const PostDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PostDetailState.loading()';
}


}




/// @nodoc


class PostDetailSuccess implements PostDetailState {
  const PostDetailSuccess({required this.post, required final  List<CommentEntity> comments, this.isTogglingLike = false}): _comments = comments;
  

 final  PostEntity post;
 final  List<CommentEntity> _comments;
 List<CommentEntity> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

@JsonKey() final  bool isTogglingLike;

/// Create a copy of PostDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostDetailSuccessCopyWith<PostDetailSuccess> get copyWith => _$PostDetailSuccessCopyWithImpl<PostDetailSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostDetailSuccess&&(identical(other.post, post) || other.post == post)&&const DeepCollectionEquality().equals(other._comments, _comments)&&(identical(other.isTogglingLike, isTogglingLike) || other.isTogglingLike == isTogglingLike));
}


@override
int get hashCode => Object.hash(runtimeType,post,const DeepCollectionEquality().hash(_comments),isTogglingLike);

@override
String toString() {
  return 'PostDetailState.success(post: $post, comments: $comments, isTogglingLike: $isTogglingLike)';
}


}

/// @nodoc
abstract mixin class $PostDetailSuccessCopyWith<$Res> implements $PostDetailStateCopyWith<$Res> {
  factory $PostDetailSuccessCopyWith(PostDetailSuccess value, $Res Function(PostDetailSuccess) _then) = _$PostDetailSuccessCopyWithImpl;
@useResult
$Res call({
 PostEntity post, List<CommentEntity> comments, bool isTogglingLike
});




}
/// @nodoc
class _$PostDetailSuccessCopyWithImpl<$Res>
    implements $PostDetailSuccessCopyWith<$Res> {
  _$PostDetailSuccessCopyWithImpl(this._self, this._then);

  final PostDetailSuccess _self;
  final $Res Function(PostDetailSuccess) _then;

/// Create a copy of PostDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? post = null,Object? comments = null,Object? isTogglingLike = null,}) {
  return _then(PostDetailSuccess(
post: null == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as PostEntity,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<CommentEntity>,isTogglingLike: null == isTogglingLike ? _self.isTogglingLike : isTogglingLike // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class PostDetailError implements PostDetailState {
  const PostDetailError(this.message);
  

 final  String message;

/// Create a copy of PostDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostDetailErrorCopyWith<PostDetailError> get copyWith => _$PostDetailErrorCopyWithImpl<PostDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'PostDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $PostDetailErrorCopyWith<$Res> implements $PostDetailStateCopyWith<$Res> {
  factory $PostDetailErrorCopyWith(PostDetailError value, $Res Function(PostDetailError) _then) = _$PostDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PostDetailErrorCopyWithImpl<$Res>
    implements $PostDetailErrorCopyWith<$Res> {
  _$PostDetailErrorCopyWithImpl(this._self, this._then);

  final PostDetailError _self;
  final $Res Function(PostDetailError) _then;

/// Create a copy of PostDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PostDetailError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
