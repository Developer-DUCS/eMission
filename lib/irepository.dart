import 'package:first_flutter_app/message_dto.dart';

abstract class IRepository {
  Future<MessageDTO> retrieveMessage();
}
