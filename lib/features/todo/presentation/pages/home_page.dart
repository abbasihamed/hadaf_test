import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadaf_test/core/di/dependency_injection.dart';
import 'package:hadaf_test/features/todo/domain/repositories/task_repository.dart';
import 'package:hadaf_test/features/todo/presentation/controllers/task_controller.dart';
import 'package:hadaf_test/features/todo/presentation/widgets/error_message.dart';
import 'package:hadaf_test/features/todo/presentation/widgets/task_form.dart';
import 'package:hadaf_test/features/todo/presentation/widgets/task_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller =
        Get.put(TaskController(getIt<TaskRepository>()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management App'),
        actions: [
          PopupMenuButton<String>(
            onSelected: controller.setFilter,
            itemBuilder: (BuildContext context) {
              return ['All', 'Completed', 'Incomplete'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            if (controller.error.value != null)
              ErrorMessage(message: controller.error.value!),
            if (controller.isLoading.value)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              const Expanded(
                child: Column(
                  children: [
                    TaskForm(),
                    Expanded(child: TaskList()),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
