// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

//Splash Screen that all users will start off on. Has a watermark, title text and a button which will navigate them to the UWO logon system.

import 'package:flutter/material.dart';

class ScreenOne extends StatelessWidget {
  const ScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //Centers the column
      body: Container(alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Container with UWO watermark
            Container(
              width: 275,
              height: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage('https://uwosh.edu/umc/wp-content/uploads/sites/18/2019/07/UWO_vertical_Oshkosh_4c.png'), fit: BoxFit.fill)
              ),
            ),
            //Splash Screen Title
            const Text('Be Better Initiative', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            // Log in button
            ElevatedButton(onPressed: null, 
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
              child: SizedBox(width: 200, height: 50, child: Center(child: Text('Log in using UWO ID', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))))
          ],
        ),
      ),
    );
  }
}