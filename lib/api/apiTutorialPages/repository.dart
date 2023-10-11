import 'message_dto.dart';
import 'api.dart';
import 'irepository.dart';

class Repository implements IRepository {
  Repository(this._api);
  final Api _api;

  @override
  Future<MessageDTO> retrieveMessage() => _api.retrieveMessage();
}
