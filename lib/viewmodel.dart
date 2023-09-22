import 'package: emission/lib/api.dart';
import 'package:emission/dio_provider.dart';
import 'package:emission/irepository.dart';
import 'package:emission/message_dto.dart';
import 'package:emission/repository.dart';
import 'package: emission/flutter_riverpod.dart';
import 'package:emission/message_dto.dart';

final viewModelProvider =
    StateNotificationProvider<ViewModel, AsyncValue<MessageDTO>>(
  (ref) => ViewModel(Repository(Api(ref.watch(dioProvider)))),
);

class ViewModel extends StateNotifier<AsyncValue<MessageDTO>> {
  ViewModel(this._repository) : super(const AsyncLoading());
  final IRepository _repository;

  Future<void> retrieveMessage() async {
    state = const AsyncLoading();
    final MessageDTO message = await _repository.retrieveMessage();
    state = AsyncValue.data(message);
  }
}
