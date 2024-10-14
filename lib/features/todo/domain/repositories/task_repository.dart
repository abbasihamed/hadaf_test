import 'package:dartz/dartz.dart';
import 'package:hadaf_test/core/network_error/failures.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks();
  Future<Either<Failure, TaskEntity>> addTask(String title, bool completed);
  Future<Either<Failure, TaskEntity>> updateTask(int id, bool completed);
  Future<Either<Failure, Unit>> deleteTask(int id);
}
