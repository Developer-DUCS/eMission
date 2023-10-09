import 'api.dart';
import 'dio_provider.dart';
import 'irepository.dart';
import 'message_dto.dart';
import 'repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'message_dto.dart';

final viewModelProvider =
    StateNotifierProvider<ViewModel, AsyncValue<MessageDTO>>(
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
