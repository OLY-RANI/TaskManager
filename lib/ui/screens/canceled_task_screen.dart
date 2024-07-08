import 'package:flutter/material.dart';


import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import '../widgets/center_progress_indicator.dart';
import '../widgets/snack_bar_messege.dart';
import '../widgets/task_item.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {
  bool _getCanceledTasksInProgress = false;
  List<TaskModel> canceledTasks= [];

  @override
  void initState() {
    super.initState();
    _getCanceledTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Visibility(
        visible: _getCanceledTasksInProgress == false,
        replacement: const CenterProgressIndicator(),
        child: ListView.builder(
            itemCount: canceledTasks.length,
            itemBuilder: (context, index) {
              return TaskItem(
                taskModel: canceledTasks[index],
                onUpdateTask: () {
                  _getCanceledTasks();
                },
              );
            }),
      ),
    );
  }



  Future<void> _getCanceledTasks() async {
    _getCanceledTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.canceled);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      canceledTasks = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMassege ?? 'Get Canceled Task failed! Try again');
      }
    }
    _getCanceledTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

}
