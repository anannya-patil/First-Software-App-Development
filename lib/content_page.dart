import 'package:flutter/material.dart';
import 'configurations.dart';
import 'attendance_model.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text("Content"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),

          itemCount: Configurations.attendance.length,

          itemBuilder: (context, index) {

            Attendance record = Configurations.attendance[index];

            bool isPresent = record.getStatus() == 1;

            return Container(
              margin: const EdgeInsets.all(10),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [

                  Text(
                    record.getDate(),
                    style: const TextStyle(fontSize: 20),
                  ),

                  CircleAvatar(
                    backgroundColor:
                        isPresent ? Colors.green : Colors.red,

                    child: Text(
                      isPresent ? "P" : "A",
                      style: isPresent
                          ? null
                          : const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}