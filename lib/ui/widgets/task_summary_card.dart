import 'package:flutter/material.dart';

class TaskSummaryCard extends StatelessWidget {

  final String title;
  final String count;
  const TaskSummaryCard({
    super.key,
    required this.title,
    required this.count
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                count,
                style: Theme.of(context).textTheme.titleLarge,),
            Text(title,style: Theme.of(context).textTheme.titleSmall)
          ],
        ),
      ),
    );
  }
}
