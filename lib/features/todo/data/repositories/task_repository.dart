import 'package:dartz/dartz.dart';
import 'package:hadaf_test/core/network_error/failures.dart';
import 'package:hadaf_test/features/todo/data/datasourse/api_client.dart';
import 'package:hadaf_test/features/todo/data/models/task_model.dart';
import 'package:hadaf_test/features/todo/domain/entities/task.dart';
import 'package:hadaf_test/features/todo/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final ApiClient apiClient;

  TaskRepositoryImpl(this.apiClient);

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    try {
      final response = await apiClient.get('todos');
      final List<dynamic> todosJson = response['todos'];
      final tasks = todosJson.map((json) => TaskModel.fromJson(json)).toList();
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> addTask(
      String title, bool completed) async {
    try {
      final response = await apiClient.post('todos/add', {
        'todo': title,
        'completed': completed,
        'userId': 1, // Dummy user ID
      });
      return Right(TaskModel.fromJson(response));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(int id, bool completed) async {
    try {
      final response = await apiClient.put('todos/$id', {
        'completed': completed,
      });
      return Right(TaskModel.fromJson(response));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(int id) async {
    try {
      await apiClient.delete('todos/$id');
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
