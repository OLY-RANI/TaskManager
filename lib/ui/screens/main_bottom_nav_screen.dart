import 'package:flutter/material.dart';
import 'package:task_manager_oly/ui/screens/canceled_task_screen.dart';
import 'package:task_manager_oly/ui/screens/completed_task_screen.dart';
import 'package:task_manager_oly/ui/screens/in_progress_task_screen.dart';
import 'package:task_manager_oly/ui/screens/new_task_screen.dart';
import 'package:task_manager_oly/ui/utility/app_colors.dart';
import 'package:task_manager_oly/ui/widgets/profile_app_bar.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {

  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    InProgressTaskScreen(),
    CanceledTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index){
            _selectedIndex = index;
            if(mounted){
              setState(() {});
            }

          },
          selectedItemColor: AppColors.themeColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
        BottomNavigationBarItem(icon: Icon(Icons.task),label: 'New Task'),
        BottomNavigationBarItem(icon: Icon(Icons.done_all_outlined),label: 'Completed'),
        BottomNavigationBarItem(icon: Icon(Icons.ac_unit_rounded),label: 'In Progress'),
        BottomNavigationBarItem(icon: Icon(Icons.cancel_outlined),label: 'Canceled'),
      ]),
    );
  }
}
