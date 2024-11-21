import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../contoller/photo_controller.dart';
import 'photo_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final photoViewModel = Provider.of<PhotoViewModel>(context, listen: false);
    photoViewModel.fetchPhotos();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        photoViewModel.fetchPhotos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black, // Set background color for the whole screen
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Row with icons at the top
          Container(
            padding: const EdgeInsets.only(
              top: 50.0, // Padding from top
              left: 30.0, // Padding from left
              right: 30.0, // Padding from right
              bottom: 30.0, // Padding from bottom
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white, // White icon color
                  size: 20.0, // Icon size
                ),
                const Spacer(),
                const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        "https://media.sproutsocial.com/uploads/2022/06/profile-picture.jpeg")),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  width: 60.0,
                  height: 45.0,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: const Center(
                    child: Text(
                      'Follow',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Top container with greeting message
          Container(
            padding: const EdgeInsets.only(
              top: 0.0, // Padding from top (adjusted to fit below the icons)
              left: 30.0, // Padding from left
              right: 30.0, // Padding from right
              bottom: 30.0, // Padding from bottom
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Activity', // Greeting text
                  style: TextStyle(
                    color: Colors.white, // White text color
                    fontSize: 18.0, // Large text size
                    fontWeight: FontWeight.w700, // Bold text
                  ),
                ),
                const Text(
                  'Community', // Greeting text
                  style: TextStyle(
                    color: Colors.white, // White text color
                    fontSize: 18.0, // Large text size
                    fontWeight: FontWeight.w700, // Bold text
                  ),
                ),
                Container(
                  width: 70.0, // Adjust width to fit the text
                  height: 45.0, // Fixed height
                  decoration: BoxDecoration(
                    color: Colors.white, // Red background color
                    borderRadius:
                        BorderRadius.circular(20.0), // Rounded corners
                  ),
                  child: const Center(
                    child: Text(
                      'Shop', // Greeting text
                      style: TextStyle(
                        color: Colors.black, // White text color
                        fontSize: 16.0, // Text size
                        fontWeight: FontWeight.w700, // Bold text
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom container to display images with MasonryGridView
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Colors.white, // White background for the grid container
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0), // Rounded top-left corner
                  topRight: Radius.circular(20.0), // Rounded top-right corner
                ),
              ),
              child: Consumer<PhotoViewModel>(
                builder: (context, photoViewModel, child) {
                  if (photoViewModel.photos.isEmpty &&
                      photoViewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MasonryGridView.builder(
                      controller: _scrollController,
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two columns
                      ),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      itemCount: photoViewModel.photos.length,
                      itemBuilder: (context, index) {
                        final photo = photoViewModel.photos[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PhotoDetailView(photo: photo),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              photo.urls.regular,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
