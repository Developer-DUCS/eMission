import 'package:first_flutter_app/message_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract class Api {
  factory Api(Dio dio) = _Api;

  @GET('message')
  Future<MessageDTO> retrieveMessage();
}
