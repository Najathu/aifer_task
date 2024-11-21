import 'package:flutter/material.dart';
import '../models/photo.dart';
import '../services/api_services.dart';

class PhotoViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Photo> photos = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;
  final int perPage = 10;

  Future<void> fetchPhotos() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final response =
          await _apiService.fetchPhotos(page: currentPage, perPage: perPage);
      photos.addAll(response['photos'] as Iterable<Photo>);
      currentPage++;
      hasMore = photos.length < response['total'];
    } catch (e) {
      debugPrint('Error fetching photos: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> downloadPhoto(String photoId) async {
    try {
      await _apiService.downloadPhoto(photoId);
      debugPrint('Photo downloaded successfully');
    } catch (e) {
      debugPrint('Error downloading photo: $e');
    }
  }
}
