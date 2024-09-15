import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedFilter = 'daily'; // Default filter

  // Sample foodLogs data
  final List<Map<String, dynamic>> foodLogs = [
    {
      'date': DateTime(2024, 9, 14, 12, 30),
      'foodName': 'Grilled Chicken Salad',
      'portionSize': '150g',
      'calories': 250,
      'protein': 25,
      'fats': 10,
      'sugar': 5,
      'micronutrients': {'Vitamin A': 10, 'Iron': 5},
      'healthScore': 85
    },
    {
      'date': DateTime(2024, 9, 14, 18, 30),
      'foodName': 'Steak with Veggies',
      'portionSize': '200g',
      'calories': 400,
      'protein': 40,
      'fats': 20,
      'sugar': 2,
      'micronutrients': {'Vitamin C': 8, 'Calcium': 6},
      'healthScore': 78
    },
    {
      'date': DateTime(2024, 9, 13, 8, 30),
      'foodName': 'Oatmeal with Berries',
      'portionSize': '100g',
      'calories': 150,
      'protein': 5,
      'fats': 2,
      'sugar': 12,
      'micronutrients': {'Fiber': 4, 'Iron': 2},
      'healthScore': 90
    },
    {
      'date': DateTime(2024, 9, 14, 20, 00),
      'foodName': 'Chocolate Cake',
      'portionSize': '150g',
      'calories': 500,
      'protein': 6,
      'fats': 30,
      'sugar': 40,
      'micronutrients': {'Calcium': 2},
      'healthScore': 35
    },
    {
      'date': DateTime(2024, 9, 14, 22, 00),
      'foodName': 'Fried Chicken Wings',
      'portionSize': '200g',
      'calories': 600,
      'protein': 20,
      'fats': 35,
      'sugar': 3,
      'micronutrients': {'Sodium': 500},
      'healthScore': 40
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredLogs = filterLogs(foodLogs, _selectedFilter);

    // Group meals by date
    Map<String, List<Map<String, dynamic>>> groupedMeals = {};
    for (var meal in filteredLogs) {
      String formattedDate = DateFormat('d MMMM y').format(meal['date']);
      if (!groupedMeals.containsKey(formattedDate)) {
        groupedMeals[formattedDate] = [];
      }
      groupedMeals[formattedDate]!.add(meal);
    }

    return Scaffold(
appBar: AppBar(
  title: Text('Food Log History', style: TextStyle(color: Colors.white)),
  backgroundColor: Colors.green,
  actions: [
    Container(
      padding: EdgeInsets.only(left:16,right:16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(10), 
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10), // Optional: Adjust spacing
      child: DropdownButton<String>(
        value: _selectedFilter,
        underline: SizedBox(),
        icon: const Icon(Icons.filter_list, color: Colors.green), // Optional: Customize icon color
        dropdownColor: Colors.white, // Background color of the dropdown menu
        items: const [
          DropdownMenuItem(
            child: Text('Daily', style: TextStyle(color: Colors.black)),
            value: 'daily',
          ),
          DropdownMenuItem(
            child: Text('Weekly', style: TextStyle(color: Colors.black)),
            value: 'weekly',
          ),
          DropdownMenuItem(
            child: Text('Monthly', style: TextStyle(color: Colors.black)),
            value: 'monthly',
          ),
          DropdownMenuItem(
            child: Text('Yearly', style: TextStyle(color: Colors.black)),
            value: 'yearly',
          ),
        ],
        onChanged: (value) {
          setState(() {
            _selectedFilter = value!;
          });
        },
      ),
    ),
  ],
),

      body: ListView(
        children: groupedMeals.entries.map((entry) {
          // Calculate daily totals
          int dailyCalories = entry.value.fold<int>(0, (sum, meal) => sum + meal['calories'] as int);
          int dailyProtein = entry.value.fold<int>(0, (sum, meal) => sum + meal['protein'] as int);
          int dailyFats = entry.value.fold<int>(0, (sum, meal) => sum + meal['fats'] as int);
          int dailySugar = entry.value.fold<int>(0, (sum, meal) => sum + meal['sugar'] as int);

      // Calculate total micronutrients
Map<String, int> totalMicronutrients = {};
for (var meal in entry.value) {
  meal['micronutrients'].forEach((key, value) {
    if (!totalMicronutrients.containsKey(key)) {
      totalMicronutrients[key] = 0;
    }
    totalMicronutrients[key] = totalMicronutrients[key]! + (value as int);
  });
}

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                SizedBox(height: 10),
                Column(
                  children: entry.value.map((meal) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealDetailPage(
                              date: entry.key,
                              meals: entry.value,
                              dailyCalories: dailyCalories,
                              dailyProtein: dailyProtein,
                              dailyFats: dailyFats,
                              dailySugar: dailySugar,
                              micronutrients: totalMicronutrients,
                            ),
                          ),
                        );
                      },
                      child: buildMealCard(meal),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Filter the logs based on the selected date filter
  List<Map<String, dynamic>> filterLogs(List<Map<String, dynamic>> logs, String filterType) {
    DateTime now = DateTime.now();

    switch (filterType) {
      case 'daily':
        return logs.where((meal) {
          return meal['date'].day == now.day &&
                 meal['date'].month == now.month &&
                 meal['date'].year == now.year;
        }).toList();
      case 'weekly':
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return logs.where((meal) {
          return meal['date'].isAfter(startOfWeek.subtract(Duration(days: 1))) &&
                 meal['date'].isBefore(now.add(Duration(days: 1)));
        }).toList();
      case 'monthly':
        return logs.where((meal) {
          return meal['date'].month == now.month && meal['date'].year == now.year;
        }).toList();
      case 'yearly':
        return logs.where((meal) {
          return meal['date'].year == now.year;
        }).toList();
      default:
        return logs; // No filter, return all logs
    }
  }

  // Build the daily totals section
  Widget buildDailyTotals({
    required int dailyCalories,
    required int dailyProtein,
    required int dailyFats,
    required int dailySugar,
    required Map<String, int> micronutrients,
  }) {
    return Container(
      width: 600,
      child: Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Totals',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 10),
            buildStatsIndicator('Calories', dailyCalories, 2500),
            buildStatsIndicator('Protein', dailyProtein, 150),
            buildStatsIndicator('Fats', dailyFats, 70),
            buildStatsIndicator('Sugar', dailySugar, 50),
            SizedBox(height: 20),
            Text(
              'Micronutrients',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 10),
            ...micronutrients.entries.map((entry) {
              return Text(
                '${entry.key}: ${entry.value} mg',
                style: TextStyle(fontSize: 16),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Build the stats indicator
  Widget buildStatsIndicator(String title, int value, int max) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$title: $value/$max',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            width: 150,
            height: 10,
            child: LinearProgressIndicator(
              value: value / max,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                value / max > 0.8 ? Colors.green : (value / max > 0.5 ? Colors.yellow : Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Build the meal card
Widget buildMealCard(Map<String, dynamic> meal) {
  return Card(
    elevation: 4,
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.fastfood, size: 50, color: Colors.teal),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['foodName'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: meal['healthScore'] / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    meal['healthScore'] > 75
                        ? Colors.green
                        : (meal['healthScore'] > 50 ? Colors.yellow : Colors.red),
                  ),
                ),
                Text(
                  '${meal['healthScore']}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}

class MealDetailPage extends StatelessWidget {
  final String date;
  final List<Map<String, dynamic>> meals;
  final int dailyCalories;
  final int dailyProtein;
  final int dailyFats;
  final int dailySugar;
  final Map<String, int> micronutrients;

  MealDetailPage({
    required this.date,
    required this.meals,
    required this.dailyCalories,
    required this.dailyProtein,
    required this.dailyFats,
    required this.dailySugar,
    required this.micronutrients,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Details for $date', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[700],
        iconTheme: IconThemeData(color: Colors.white), // Change back icon color to white
      ),
      
      body: ListView(
        children: [
          Container(
            color: Colors.teal[50],
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Totals',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                SizedBox(height: 10),
                buildStatsIndicator('Calories', dailyCalories, 2500),
                buildStatsIndicator('Protein', dailyProtein, 150),
                buildStatsIndicator('Fats', dailyFats, 70),
                buildStatsIndicator('Sugar', dailySugar, 50),
                SizedBox(height: 20),
                Text(
                  'Micronutrients',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                SizedBox(height: 10),
                ...micronutrients.entries.map((entry) {
                  return Text(
                    '${entry.key}: ${entry.value} mg',
                    style: TextStyle(fontSize: 16),
                  );
                }).toList(),
                SizedBox(height: 20),
                ...meals.map((meal) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal['foodName'],
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text('Portion Size: ${meal['portionSize']}'),
                          Text('Calories: ${meal['calories']} kcal'),
                          Text('Protein: ${meal['protein']} g'),
                          Text('Fats: ${meal['fats']} g'),
                          Text('Sugar: ${meal['sugar']} g'),
                          Text('Micronutrients: ${meal['micronutrients']}'),
                          SizedBox(height: 10),
                          Text(
                            'Health Score: ${meal['healthScore']}%',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatsIndicator(String title, int value, int max) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$title: $value/$max',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            width: 150,
            height: 10,
            child: LinearProgressIndicator(
              value: value / max,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                value / max > 0.8 ? Colors.green : (value / max > 0.5 ? Colors.orange : Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
