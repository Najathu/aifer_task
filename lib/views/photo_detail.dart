import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/photo.dart';

class PhotoDetailView extends StatelessWidget {
  final Photo photo;

  const PhotoDetailView({Key? key, required this.photo}) : super(key: key);

  Future<void> downloadImage(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(photo.urls.full));

      // Use app-specific directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${photo.id}.jpg';

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Downloaded to $filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen image
          Positioned.fill(
            child: Image.network(
              photo.urls.full,
              fit: BoxFit.cover,
            ),
          ),
          // Download button at the bottom center
          Positioned(
            bottom: 20.0, // Distance from the bottom edge
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () => downloadImage(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.black.withOpacity(0.7), // Semi-transparent button
                  foregroundColor: Colors.white, // Text color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Download'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
