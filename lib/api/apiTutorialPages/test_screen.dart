/* import 'viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late ViewModel _viewModel;

  @override
  void initState() {
    _viewModel = context.read(viewModelProvider.notifier);
    _viewModel.retrieveMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer(
        builder: (context, watch, child) {
          final viewModel = watch(viewModelProvider);

          return viewModel.when(
            data: (data) {
              return Center(
                child: Text(data.message),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => const Center(
              child: Text('ops'),
            ),
          );
        },
      ),
    );
  }
}
 */