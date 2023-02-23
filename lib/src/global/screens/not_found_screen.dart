import 'package:flutter/material.dart';

import '../widgets/custom_text.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Found'),
      ),
      body: Center(
        child: CustomText.title('Unknown route'),
      ),
    );
  }
}
