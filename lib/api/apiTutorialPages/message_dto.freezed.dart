// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MessageDTO _$MessageDTOFromJson(Map<String, dynamic> json) {
  return _MessageDTO.fromJson(json);
}

/// @nodoc
mixin _$MessageDTO {
  String get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageDTOCopyWith<MessageDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageDTOCopyWith<$Res> {
  factory $MessageDTOCopyWith(
          MessageDTO value, $Res Function(MessageDTO) then) =
      _$MessageDTOCopyWithImpl<$Res, MessageDTO>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$MessageDTOCopyWithImpl<$Res, $Val extends MessageDTO>
    implements $MessageDTOCopyWith<$Res> {
  _$MessageDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MessageDTOCopyWith<$Res>
    implements $MessageDTOCopyWith<$Res> {
  factory _$$_MessageDTOCopyWith(
          _$_MessageDTO value, $Res Function(_$_MessageDTO) then) =
      __$$_MessageDTOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$_MessageDTOCopyWithImpl<$Res>
    extends _$MessageDTOCopyWithImpl<$Res, _$_MessageDTO>
    implements _$$_MessageDTOCopyWith<$Res> {
  __$$_MessageDTOCopyWithImpl(
      _$_MessageDTO _value, $Res Function(_$_MessageDTO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$_MessageDTO(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MessageDTO implements _MessageDTO {
  const _$_MessageDTO({required this.message});

  factory _$_MessageDTO.fromJson(Map<String, dynamic> json) =>
      _$$_MessageDTOFromJson(json);

  @override
  final String message;

  @override
  String toString() {
    return 'MessageDTO(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MessageDTO &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MessageDTOCopyWith<_$_MessageDTO> get copyWith =>
      __$$_MessageDTOCopyWithImpl<_$_MessageDTO>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MessageDTOToJson(
      this,
    );
  }
}

abstract class _MessageDTO implements MessageDTO {
  const factory _MessageDTO({required final String message}) = _$_MessageDTO;

  factory _MessageDTO.fromJson(Map<String, dynamic> json) =
      _$_MessageDTO.fromJson;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$_MessageDTOCopyWith<_$_MessageDTO> get copyWith =>
      throw _privateConstructorUsedError;
}
