import 'package:flutter/material.dart';


import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import '../widgets/center_progress_indicator.dart';
import '../widgets/snack_bar_messege.dart';
import '../widgets/task_item.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  bool _getInProgressTasksInProgress = false;
  List<TaskModel> inProgressTasks= [];

  @override
  void initState() {
    super.initState();
    _getInProgressTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Visibility(
        visible: _getInProgressTasksInProgress == false,
        replacement: const CenterProgressIndicator(),
        child: ListView.builder(

            itemCount: inProgressTasks.length,
            itemBuilder: (context, index) {
              return TaskItem(
                taskModel: inProgressTasks[index],
                onUpdateTask: () {
                  _getInProgressTasks();
                },
              );
            }),
      ),
    );
  }

  Future<void> _getInProgressTasks() async {
    _getInProgressTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.inProgress);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      inProgressTasks = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMassege ?? 'Get In Progress Task failed! Try again');
      }
    }
    _getInProgressTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
