import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/local_data_source.dart';

final dohBypassProvider = StateNotifierProvider<DohBypassNotifier, bool>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);
  return DohBypassNotifier(localDataSource);
});

class DohBypassNotifier extends StateNotifier<bool> {
  final LocalDataSource localDataSource;

  DohBypassNotifier(this.localDataSource) : super(localDataSource.getDohBypass());

  Future<void> toggle(bool value) async {
    await localDataSource.setDohBypass(value);
    state = value;
  }
}
