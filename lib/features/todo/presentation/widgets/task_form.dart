import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadaf_test/features/todo/presentation/controllers/task_controller.dart';

class TaskForm extends StatelessWidget {
  const TaskForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find<TaskController>();
    final TextEditingController titleController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Enter task title',
              ),
            ),
          ),
          Obx(
            () => controller.isAdding.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isNotEmpty) {
                        controller.addTask(titleController.text, false);
                        titleController.clear();
                      }
                    },
                    child: const Text('Add Task'),
                  ),
          ),
        ],
      ),
    );
  }
}
