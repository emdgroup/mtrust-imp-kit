import 'package:example_advanced/advanced_workflow.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // NOTE: This example application should provide you with a very minimalistic way to handle the communication with a reader
  // and how you can utilize this to build your own custom workflows.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, //Disable debug banner (top right) in debug mode
      home: Scaffold(
        appBar: AppBar(
          title: const Text('IMP Advanced Example Application'),
        ),
        body: const AdvancedWorkflow(),
      ),
    );
  }
}
