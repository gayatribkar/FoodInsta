// import 'package:flutter/material.dart';
// import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// import 'package:flutter_foodinsta_app/Screens/AddItem.dart';
// import 'package:flutter_foodinsta_app/SignUp_Login/LoginPage.dart';

// class LandingPage extends StatefulWidget {
//   @override
//   _LandingPageState createState() => _LandingPageState();
// }

// class _LandingPageState extends State<LandingPage> {
//   final List<Map<String, dynamic>> _posts = [
//     {
//       'username': 'user1',
//       'image': 'assets/login.jpeg',
//       'caption': 'Delicious Salad Bowl!',
//       'likes': 120,
//       'comments': 15,
//     },
//     {
//       'username': 'user2',
//       'image': 'assets/login.jpeg',
//       'caption': 'Healthy Breakfast Smoothie',
//       'likes': 85,
//       'comments': 8,
//     },
//   ];

//   int _currentIndex = 0;

//   final iconList = <IconData>[
//     Icons.home,
//     Icons.add_box_rounded,
//     Icons.history,
//     Icons.person,
//   ];

//   TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   void _navigateTo(int index) {
//     switch (index) {
//       case 0:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => LoginPage()),
//         );
//         break;
//       case 1:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => AddPostPage()),
//         );
//         break;
//       case 2:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => LoginPage()),
//         );
//         break;
//       case 3:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => LoginPage()),
//         );
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//   appBar: AppBar(
//   title: Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Container(
//       height: 45, // Compact height
//       margin: EdgeInsets.symmetric(horizontal: 20),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: TextField(
//         controller: _searchController,
//         onChanged: (value) {
//           setState(() {
//             _searchQuery = value;
//           });
//         },
//         decoration: InputDecoration(
//           hintText: 'Search users or posts...',
//           hintStyle: TextStyle(color: Colors.grey),
//           prefixIcon: Icon(Icons.search, color: Colors.grey[800]),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(vertical: 8), // Reduced padding
//         ),
//       ),
//     ),
//   ),
//   backgroundColor: Colors.white,
//   elevation: 0,
//   centerTitle: true,
// )
// ,
//       body: ListView.builder(
//         itemCount: _posts.length,
//         itemBuilder: (context, index) {
//           final post = _posts[index];
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               elevation: 4,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: AssetImage('assets/dummy_profile.jpeg'),
//                     ),
//                     title: Text(post['username']),
//                     subtitle: Text('Posted 2 hours ago'),
//                   ),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10), // Rounded corners for the image
//                     child: Image.asset(
//                       post['image'],
//                       fit: BoxFit.cover,
//                       height: 180, // Reduced height of the image to maintain proportion
//                       width: double.infinity,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(post['caption']),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.favorite_border),
//                           onPressed: () {
//                             // Like button functionality
//                           },
//                         ),
//                         Text('${post['likes']} likes'),
//                         IconButton(
//                           icon: Icon(Icons.comment),
//                           onPressed: () {
//                             // Comment functionality
//                           },
//                         ),
//                         Text('${post['comments']} comments'),
//                         IconButton(
//                           icon: Icon(Icons.share),
//                           onPressed: () {
//                             // Share functionality
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: AnimatedBottomNavigationBar(
//         icons: iconList,
//         activeIndex: _currentIndex,
//         gapLocation: GapLocation.none,
//         notchSmoothness: NotchSmoothness.softEdge,
//         leftCornerRadius: 40,
//         rightCornerRadius: 40,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//             _navigateTo(index);
//           });
//         },
//         activeColor: Colors.green,
//         inactiveColor: Colors.grey,
//         iconSize: 30, // Adjusted icon size for bottom navigation bar
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// Import your separate page files here
import 'package:flutter_foodinsta_app/Screens/AddItem.dart';
import 'package:flutter_foodinsta_app/Screens/ProfilePage.dart';
import 'package:flutter_foodinsta_app/SignUp_Login/LoginPage.dart';

class LandingPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
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
    },
    {
      'username': 'user2',
      'image': 'assets/login.jpeg',
      'caption': 'Healthy Breakfast Smoothie',
      'likes': 85,
      'comments': 8,
    },
  ];

  int _currentIndex = 0;

  final iconList = <IconData>[
    Icons.home,
    Icons.add_box_rounded,
    Icons.history,
    Icons.person,
  ];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
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
          // Default Landing Page
          ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              final post = _posts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
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
                          backgroundImage: AssetImage('assets/dummy_profile.jpeg'),
                        ),
                        title: Text(post['username']),
                        subtitle: const Text('Posted 2 hours ago'),
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
                                // Like button functionality
                              },
                            ),
                            Text('${post['likes']} likes'),
                            IconButton(
                              icon: const Icon(Icons.comment),
                              onPressed: () {
                                // Comment functionality
                              },
                            ),
                            Text('${post['comments']} comments'),
                            IconButton(
                              // ignore: prefer_const_constructors
                              icon: Icon(Icons.share),
                              onPressed: () {
                                // Share functionality
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
          // Add Item Page
          AddPostPage(),
          LoginPage(),
          ProfilePage(), // Your Add Item Page Widget
          // History Page
          // HistoryPage(),
         
          // ProfilePage(), 
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
