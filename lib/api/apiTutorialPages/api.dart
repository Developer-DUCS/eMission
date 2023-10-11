import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'message_dto.dart';
part 'api.g.dart';

@RestApi()
abstract class Api {
  factory Api(Dio dio) = _Api;

  @GET('message')
  Future<MessageDTO> retrieveMessage();
}
