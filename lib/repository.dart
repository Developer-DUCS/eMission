import 'package: app_test_http/message_dto.dart';
import 'package:first_flutter_app/irepository.dart';
import 'package:first_flutter_app/message_dto.dart';

class Repository implements IRepository{
  repository(this._api);
  final Api _api;

  @override
  Future<MessageDTO> retrieveMessage() => _api.retrieveMessage();
}