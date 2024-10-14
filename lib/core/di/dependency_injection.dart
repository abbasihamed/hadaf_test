import 'package:get_it/get_it.dart';
import 'package:hadaf_test/features/todo/data/datasourse/api_client.dart';
import 'package:hadaf_test/features/todo/data/repositories/task_repository.dart';
import 'package:hadaf_test/features/todo/domain/repositories/task_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Register API Client
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  getIt.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(getIt<ApiClient>()));
}
