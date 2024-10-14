import 'package:get/get.dart';
import 'package:hadaf_test/core/network_error/failures.dart';
import 'package:hadaf_test/features/todo/domain/entities/task.dart';
import 'package:hadaf_test/features/todo/domain/repositories/task_repository.dart';

class TaskController extends GetxController {
  final TaskRepository _repository;
  final RxList<TaskEntity> tasks = <TaskEntity>[].obs;
  final RxString filter = 'All'.obs;

  final RxBool isLoading = false.obs;
  final RxBool isAdding = false.obs;
  final RxMap<int, bool> updatingTasks = <int, bool>{}.obs;
  final RxMap<int, bool> deletingTasks = <int, bool>{}.obs;

  final Rx<String?> error = Rx<String?>(null);

  TaskController(this._repository);

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;
      error.value = null;
      final result = await _repository.getTasks();
      result.fold(
        (failure) => error.value = _mapFailureToMessage(failure),
        (fetchedTasks) => tasks.assignAll(fetchedTasks),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTask(String title, bool completed) async {
    try {
      isAdding.value = true;
      error.value = null;
      final result = await _repository.addTask(title, completed);
      result.fold(
        (failure) => error.value = _mapFailureToMessage(failure),
        (newTask) => tasks.add(newTask),
      );
    } finally {
      isAdding.value = false;
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    try {
      updatingTasks[task.id] = true;
      error.value = null;
      final result = await _repository.updateTask(task.id, !task.completed);
      result.fold(
        (failure) => error.value = _mapFailureToMessage(failure),
        (updatedTask) {
          final index = tasks.indexWhere((t) => t.id == task.id);
          if (index != -1) {
            tasks[index] = updatedTask;
          }
        },
      );
    } finally {
      updatingTasks.remove(task.id);
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      deletingTasks[id] = true;
      error.value = null;
      final result = await _repository.deleteTask(id);
      result.fold(
        (failure) => error.value = _mapFailureToMessage(failure),
        (_) => tasks.removeWhere((task) => task.id == id),
      );
    } finally {
      deletingTasks.remove(id);
    }
  }

  void setFilter(String newFilter) {
    filter.value = newFilter;
  }

  List<TaskEntity> get filteredTasks {
    switch (filter.value) {
      case 'Completed':
        return tasks.where((task) => task.completed).toList();
      case 'Incomplete':
        return tasks.where((task) => !task.completed).toList();
      default:
        return tasks;
    }
  }

  bool isUpdating(int id) => updatingTasks[id] ?? false;
  bool isDeleting(int id) => deletingTasks[id] ?? false;

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return 'Server error occurred. Please try again.';
      default:
        return 'Unexpected error occurred. Please try again.';
    }
  }
}
