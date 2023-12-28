// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ActionDocument _$ActionDocumentFromJson(Map<String, dynamic> json) {
  return _ActionDocument.fromJson(json);
}

/// @nodoc
mixin _$ActionDocument {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'action')
  String get action => throw _privateConstructorUsedError;
  @JsonKey(name: 'score')
  int? get score => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActionDocumentCopyWith<ActionDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionDocumentCopyWith<$Res> {
  factory $ActionDocumentCopyWith(
          ActionDocument value, $Res Function(ActionDocument) then) =
      _$ActionDocumentCopyWithImpl<$Res, ActionDocument>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'action') String action,
      @JsonKey(name: 'score') int? score});
}

/// @nodoc
class _$ActionDocumentCopyWithImpl<$Res, $Val extends ActionDocument>
    implements $ActionDocumentCopyWith<$Res> {
  _$ActionDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? action = null,
    Object? score = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ActionDocumentCopyWith<$Res>
    implements $ActionDocumentCopyWith<$Res> {
  factory _$$_ActionDocumentCopyWith(
          _$_ActionDocument value, $Res Function(_$_ActionDocument) then) =
      __$$_ActionDocumentCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'action') String action,
      @JsonKey(name: 'score') int? score});
}

/// @nodoc
class __$$_ActionDocumentCopyWithImpl<$Res>
    extends _$ActionDocumentCopyWithImpl<$Res, _$_ActionDocument>
    implements _$$_ActionDocumentCopyWith<$Res> {
  __$$_ActionDocumentCopyWithImpl(
      _$_ActionDocument _value, $Res Function(_$_ActionDocument) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? action = null,
    Object? score = freezed,
  }) {
    return _then(_$_ActionDocument(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ActionDocument extends _ActionDocument {
  const _$_ActionDocument(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'action') required this.action,
      @JsonKey(name: 'score') this.score})
      : super._();

  factory _$_ActionDocument.fromJson(Map<String, dynamic> json) =>
      _$$_ActionDocumentFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'action')
  final String action;
  @override
  @JsonKey(name: 'score')
  final int? score;

  @override
  String toString() {
    return 'ActionDocument(id: $id, action: $action, score: $score)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActionDocument &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, action, score);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ActionDocumentCopyWith<_$_ActionDocument> get copyWith =>
      __$$_ActionDocumentCopyWithImpl<_$_ActionDocument>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActionDocumentToJson(
      this,
    );
  }
}

abstract class _ActionDocument extends ActionDocument {
  const factory _ActionDocument(
      {@JsonKey(name: 'id') required final int id,
      @JsonKey(name: 'action') required final String action,
      @JsonKey(name: 'score') final int? score}) = _$_ActionDocument;
  const _ActionDocument._() : super._();

  factory _ActionDocument.fromJson(Map<String, dynamic> json) =
      _$_ActionDocument.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'action')
  String get action;
  @override
  @JsonKey(name: 'score')
  int? get score;
  @override
  @JsonKey(ignore: true)
  _$$_ActionDocumentCopyWith<_$_ActionDocument> get copyWith =>
      throw _privateConstructorUsedError;
}
