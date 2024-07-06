import 'package:flutter/material.dart';
import '../utilities/app_colors.dart';
import 'canceled_task_screen.dart';
import 'completed_task_screen.dart';
import 'in_progress_task_screen.dart';
import 'new_task_screen.dart';

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
    CanceledTaskScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_document), label: 'New Task'),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_document), label: 'Completed'),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_document), label: 'In Progress'),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_document), label: 'Canceled')
        ],
      ),
    );
  }
}
