import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadaf_test/features/todo/presentation/controllers/task_controller.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find<TaskController>();
    return Obx(
      () => ListView.builder(
        itemCount: controller.filteredTasks.length,
        itemBuilder: (context, index) {
          final task = controller.filteredTasks[index];
          print('title-${task.title} - c -${task.completed}');
          return Obx(
            () => ListTile(
              title: Text(task.title),
              leading: controller.isUpdating(task.id)
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Checkbox(
                      value: task.completed,
                      onChanged: (_) => controller.updateTask(task),
                    ),
              trailing: controller.isDeleting(task.id)
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => controller.deleteTask(task.id),
                    ),
            ),
          );
        },
      ),
    );
  }
}
