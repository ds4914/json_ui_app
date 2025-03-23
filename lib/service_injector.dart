import 'package:get_it/get_it.dart';
import 'package:jsonuiapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:jsonuiapp/services/ui_service.dart';
import 'package:jsonuiapp/blocs/ui_bloc/ui_bloc.dart';

final GetIt sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton<UIService>(() => UIServiceImpl());
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc());
  sl.registerFactory(() => UIBloc(sl<UIService>()));
}
