import 'package:flutter/material.dart';
import 'package:flutter_foodinsta_app/Screens/UserInfo.dart';
 // Import the new settings page

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Wrapping the upper section in a Container with circular borders at the bottom
            Container(
              decoration: BoxDecoration(
                color: Colors.green[50], // Light green background color
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50, bottom: 20),
                    child: Row(
                      children: [
                         CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.green[900],
                          backgroundImage: AssetImage('assets/dummy_profile.jpeg'),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gayatri Milind',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Live Love Food',
                              style: TextStyle(color: Colors.green[700]),
                            ),
                          ],
                        ),
                        Spacer(),
                        // Menu Icon with Navigation
                        IconButton(
                          icon: Icon(Icons.menu, size: 30),
                          onPressed: () {
                            // Navigate to Profile Settings Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileSettingsPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '3',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text('Posts'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '5,851',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text('Followers'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '3,935',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text('Following'),
                          ],
                        ),
                      ],
                    ),
                  ),
                                          SizedBox(height: 20,)
                ],
              ),
            ),

            // Posts section (GridView)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              itemCount: 6, // Sample post count
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.green[100],
                  child: Image.asset(
                    'assets/login.jpeg',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
