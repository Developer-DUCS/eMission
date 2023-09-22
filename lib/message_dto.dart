// isn't working...

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meesage_dto.freezed.dart';
part 'message_dto.g.dart';

@freezed
abstract class MessageDTO with _$MessageDTO {
  const factory MessageDTO({
    required String message,
  }) = _MessageDTO;

  factory MessageDTO.fromJson(Map<String, dynamic>json)=>
  _$MessageDTOFromJson(json):
}
