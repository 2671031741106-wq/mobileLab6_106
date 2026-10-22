import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workshop6_106/screen/formscreen.dart';
import 'package:workshop6_106/screen/display.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workshop 6',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'แบบฟอร์มบันทึกคะแนนสอบ'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: const TabBarView(
          children: [
            FormScreen(),
            DisplayScreen(),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 49, 224, 157),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(text: "บันทึกคะแนน"),
            Tab(text: "รายชื่อนักเรียน"),
          ],
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          labelColor: Color.fromARGB(255, 255, 255, 255),
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
      ),
    );
  }
}