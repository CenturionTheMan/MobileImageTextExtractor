import 'package:flutter/material.dart';
import 'package:image_text_extractor/pages/camera_view_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Text Extractor'),
      ),
      body: createBody(),
      floatingActionButton: createFloatingActionButton(context),
    );
  }

  Center createBody() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'POMIDOR',
          ),
        ],
      ),
    );
  }
}

FloatingActionButton createFloatingActionButton(BuildContext context) {
  return FloatingActionButton(
    onPressed: () => {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CameraViewPage(),
        ),
      )
    },
    tooltip: 'Add new image',
    child: const Icon(Icons.add),
  );
}
