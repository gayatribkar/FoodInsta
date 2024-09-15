import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_foodinsta_app/Screens/AddItem.dart';
import 'package:flutter_foodinsta_app/Screens/History.dart';
import 'package:flutter_foodinsta_app/Screens/ProfilePage.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<Map<String, dynamic>> _posts = [
    {
      'username': 'user1',
      'image': 'assets/login.jpeg',
      'caption': 'Delicious Salad Bowl!',
      'likes': 120,
      'comments': 15,
      'progress': 45.0,
      'nutrition': {
        'Calories': '350 kcal',
        'Protein': '15g',
        'Fats': '10g',
        'Carbs': '45g',
      },
    },
    {
      'username': 'user2',
      'image': 'assets/login.jpeg',
      'caption': 'Healthy Breakfast Smoothie',
      'likes': 85,
      'comments': 8,
      'progress': 75.0,
      'nutrition': {
        'Calories': '250 kcal',
        'Protein': '5g',
        'Fats': '8g',
        'Carbs': '35g',
      },
    },
  ];

  int _currentIndex = 0;

  final iconList = <IconData>[
    Icons.home,
    Icons.add_box_rounded,
    Icons.history,
    Icons.person,
  ];

  void _onBottomNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  height: 45,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search users or posts...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[800]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            )
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              final post = _posts[index];
              final double progress = post['progress'];
              final Color progressColor =
                  progress < 50 ? Colors.red : Colors.green;
              final Map<String, String> nutrition = post['nutrition'];

              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/dummy_profile.jpeg'),
                        ),
                        title: Text(post['username']),
                        subtitle: const Text('Posted 2 hours ago'),
                        trailing: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Transform.rotate(
                                angle: -math.pi / 2, // Rotate by 90 degrees
                                child: CircularProgressIndicator(
                                  value: progress / 100,
                                  strokeWidth: 5,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      progressColor),
                                ),
                              ),
                            ),
                            Positioned(
                              child: Text(
                                '${progress.toInt()}%',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Nutrition Facts Button
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // Show Nutrition Facts
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) {
                                return Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Nutrition Facts',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Divider(),
                                      Text('Calories: ${nutrition['Calories']}'),
                                      Text('Protein: ${nutrition['Protein']}'),
                                      Text('Fats: ${nutrition['Fats']}'),
                                      Text('Carbs: ${nutrition['Carbs']}'),
                                      SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Text('Nutrition Facts'),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          post['image'],
                          fit: BoxFit.cover,
                          height: 180,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(post['caption']),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite_border),
                              onPressed: () {
                                // Handle like
                              },
                            ),
                            Text('${post['likes']} likes'),
                            IconButton(
                              icon: const Icon(Icons.comment),
                              onPressed: () {
                                // Handle comment
                              },
                            ),
                            Text('${post['comments']} comments'),
                            
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () {
                                // Handle share
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          AddPostPage(),
          HistoryPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 40,
        rightCornerRadius: 40,
        onTap: _onBottomNavBarTapped,
        activeColor: Colors.green,
        inactiveColor: Colors.grey,
        iconSize: 30,
      ),
    );
  }
}
