// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'posts_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PostsState()';
}


}

/// @nodoc
class $PostsStateCopyWith<$Res>  {
$PostsStateCopyWith(PostsState _, $Res Function(PostsState) __);
}


/// Adds pattern-matching-related methods to [PostsState].
extension PostsStatePatterns on PostsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PostsInitial value)?  initial,TResult Function( PostsLoading value)?  loading,TResult Function( PostsSuccess value)?  success,TResult Function( PostsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PostsInitial() when initial != null:
return initial(_that);case PostsLoading() when loading != null:
return loading(_that);case PostsSuccess() when success != null:
return success(_that);case PostsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PostsInitial value)  initial,required TResult Function( PostsLoading value)  loading,required TResult Function( PostsSuccess value)  success,required TResult Function( PostsError value)  error,}){
final _that = this;
switch (_that) {
case PostsInitial():
return initial(_that);case PostsLoading():
return loading(_that);case PostsSuccess():
return success(_that);case PostsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PostsInitial value)?  initial,TResult? Function( PostsLoading value)?  loading,TResult? Function( PostsSuccess value)?  success,TResult? Function( PostsError value)?  error,}){
final _that = this;
switch (_that) {
case PostsInitial() when initial != null:
return initial(_that);case PostsLoading() when loading != null:
return loading(_that);case PostsSuccess() when success != null:
return success(_that);case PostsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<PostEntity> posts,  List<PostEntity> filteredPosts,  String searchQuery)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PostsInitial() when initial != null:
return initial();case PostsLoading() when loading != null:
return loading();case PostsSuccess() when success != null:
return success(_that.posts,_that.filteredPosts,_that.searchQuery);case PostsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<PostEntity> posts,  List<PostEntity> filteredPosts,  String searchQuery)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case PostsInitial():
return initial();case PostsLoading():
return loading();case PostsSuccess():
return success(_that.posts,_that.filteredPosts,_that.searchQuery);case PostsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<PostEntity> posts,  List<PostEntity> filteredPosts,  String searchQuery)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case PostsInitial() when initial != null:
return initial();case PostsLoading() when loading != null:
return loading();case PostsSuccess() when success != null:
return success(_that.posts,_that.filteredPosts,_that.searchQuery);case PostsError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class PostsInitial implements PostsState {
  const PostsInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PostsState.initial()';
}


}




/// @nodoc


class PostsLoading implements PostsState {
  const PostsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PostsState.loading()';
}


}




/// @nodoc


class PostsSuccess implements PostsState {
  const PostsSuccess({required final  List<PostEntity> posts, final  List<PostEntity> filteredPosts = const <PostEntity>[], this.searchQuery = ''}): _posts = posts,_filteredPosts = filteredPosts;
  

 final  List<PostEntity> _posts;
 List<PostEntity> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

 final  List<PostEntity> _filteredPosts;
@JsonKey() List<PostEntity> get filteredPosts {
  if (_filteredPosts is EqualUnmodifiableListView) return _filteredPosts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredPosts);
}

@JsonKey() final  String searchQuery;

/// Create a copy of PostsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostsSuccessCopyWith<PostsSuccess> get copyWith => _$PostsSuccessCopyWithImpl<PostsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostsSuccess&&const DeepCollectionEquality().equals(other._posts, _posts)&&const DeepCollectionEquality().equals(other._filteredPosts, _filteredPosts)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),const DeepCollectionEquality().hash(_filteredPosts),searchQuery);

@override
String toString() {
  return 'PostsState.success(posts: $posts, filteredPosts: $filteredPosts, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class $PostsSuccessCopyWith<$Res> implements $PostsStateCopyWith<$Res> {
  factory $PostsSuccessCopyWith(PostsSuccess value, $Res Function(PostsSuccess) _then) = _$PostsSuccessCopyWithImpl;
@useResult
$Res call({
 List<PostEntity> posts, List<PostEntity> filteredPosts, String searchQuery
});




}
/// @nodoc
class _$PostsSuccessCopyWithImpl<$Res>
    implements $PostsSuccessCopyWith<$Res> {
  _$PostsSuccessCopyWithImpl(this._self, this._then);

  final PostsSuccess _self;
  final $Res Function(PostsSuccess) _then;

/// Create a copy of PostsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? filteredPosts = null,Object? searchQuery = null,}) {
  return _then(PostsSuccess(
posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<PostEntity>,filteredPosts: null == filteredPosts ? _self._filteredPosts : filteredPosts // ignore: cast_nullable_to_non_nullable
as List<PostEntity>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PostsError implements PostsState {
  const PostsError(this.message);
  

 final  String message;

/// Create a copy of PostsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostsErrorCopyWith<PostsError> get copyWith => _$PostsErrorCopyWithImpl<PostsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostsError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'PostsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $PostsErrorCopyWith<$Res> implements $PostsStateCopyWith<$Res> {
  factory $PostsErrorCopyWith(PostsError value, $Res Function(PostsError) _then) = _$PostsErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PostsErrorCopyWithImpl<$Res>
    implements $PostsErrorCopyWith<$Res> {
  _$PostsErrorCopyWithImpl(this._self, this._then);

  final PostsError _self;
  final $Res Function(PostsError) _then;

/// Create a copy of PostsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PostsError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
