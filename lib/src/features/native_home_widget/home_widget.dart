import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  static const platform = MethodChannel('com.example.mywidget/widget');

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'saveData':
        // Call your function to save the data in shared preferences
        final data = call.arguments as Map<String, dynamic>;
        debugPrint('Received data: $data');
      default:
        throw PlatformException(
          code: 'NotImplemented',
          message: 'Method ${call.method} not implemented',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Widget'),
      ),
      body: const Center(
        child: Text('Press the button to show the widget'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Show the native widget and wait for the result
            final result = await platform.invokeMethod('showWidget');

            debugPrint('Result: $result');
          } on PlatformException catch (e) {
            debugPrint('Error: ${e.message}');
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
