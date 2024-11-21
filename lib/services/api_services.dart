import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/photo.dart';

class ApiService {
  static const String apiKey = 'aGuHBGcRatMiNrj7tGjQ_0Y9oMwDab2IwIrPi0s9NZQ';
  static const String baseUrl = 'https://api.unsplash.com/';

  Future<Map<String, dynamic>> fetchPhotos(
      {required int page, int perPage = 10}) async {
    final response = await http.get(
      Uri.parse(
          '${baseUrl}photos?page=$page&per_page=$perPage&client_id=$apiKey'),
      headers: {'Authorization': 'Client-ID $apiKey'},
    );

    if (response.statusCode == 200) {
      print(response.body);
      print(response.headers);
      print(response.statusCode);
      // Parse photo data
      final List<dynamic> photosJson = json.decode(response.body);
      final List<Photo> photos =
          photosJson.map((json) => Photo.fromJson(json)).toList();

      // Handle pagination manually if required
      final int perPageCount =
          int.parse(response.headers['x-per-page'] ?? '10');
      final int totalItems = int.parse(response.headers['x-total'] ?? '0');
      final String? nextLink =
          _parseLinkHeader(response.headers['link'], 'next');

      return {
        'photos': photos,
        'perPage': perPageCount,
        'total': totalItems,
        'nextLink': nextLink,
      };
    } else {
      throw Exception('Failed to load photos: ${response.statusCode}');
    }
  }

  Future<void> downloadPhoto(String photoId) async {
    final response = await http.get(
      Uri.parse('${baseUrl}photos/$photoId/download'),
      headers: {'Authorization': 'Client-ID $apiKey'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to download photo: ${response.statusCode}');
    }

    // Handle the download URL if needed
    final downloadUrl = json.decode(response.body)['url'];
    print('Photo download URL: $downloadUrl');
  }

  // Helper function to parse Link header
  String? _parseLinkHeader(String? linkHeader, String rel) {
    if (linkHeader == null) return null;
    final links = linkHeader.split(',').map((link) => link.trim());
    for (var link in links) {
      final parts = link.split(';');
      if (parts.length == 2 && parts[1].contains('rel="$rel"')) {
        return parts[0].replaceAll('<', '').replaceAll('>', '');
      }
    }
    return null;
  }
}
