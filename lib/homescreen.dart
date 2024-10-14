import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the chart package
import 'package:judge_app_2/students.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:judge_app_2/database.dart'; // Import your FirestoreService

class Homescreen extends StatefulWidget {
  final String username;

  const Homescreen({required this.username});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final FirestoreService _fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body: Stack(
        children: [
          // Background Color (Solid color to keep it simple)
          Container(
            color: Colors.amber[50],
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Greeting Text
                Container(
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.only(right: 20.0, top: 20.0),
                  child: Text(
                    "Hi, ${widget.username}",
                    style: GoogleFonts.poppins(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),

                // Spacing
                const SizedBox(height: 30),

                // Instruction Text
                Text(
                  "Choose a category",
                  style: GoogleFonts.montserrat(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Category Cards with Icons
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: userId != null
                        ? _fs.getCategories_2(userId)
                        : Stream.value([]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final categories = snapshot.data ?? [];

                      if (categories.isEmpty) {
                        return Center(child: Text('No categories available.'));
                      }

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                        ),
                        padding: const EdgeInsets.all(16.0),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];

                          if (category['name'] == null) {
                            print(category);
                            return Center(
                                child: Text('Category data is incomplete.'));
                          }

                          return buildCardWithIcon(
                            context,
                            category['name'],
                            Icons.category,
                            Colors.amber[(index + 1) * 100],
                            userId!, // Ensure userId is not null before this point
                          );
                        },
                      );
                    },
                  ),
                ),

                // Add the Graph at the Bottom
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    height: 200, // Set the height of the chart
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 20, // Maximum Y value for the bars
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${rod.toY}',
                                GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                switch (value.toInt()) {
                                  case 1:
                                    return const Text("Total",
                                        style: TextStyle(color: Colors.black));
                                  case 2:
                                    return const Text("Mini",
                                        style: TextStyle(color: Colors.black));
                                  case 3:
                                    return const Text("Little",
                                        style: TextStyle(color: Colors.black));
                                  case 4:
                                    return const Text("Teen",
                                        style: TextStyle(color: Colors.black));
                                  default:
                                    return const Text("");
                                }
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                return Text('${value.toInt()}',
                                    style:
                                        const TextStyle(color: Colors.black54));
                              },
                              reservedSize: 30,
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) {
                            return const FlLine(
                              color: Colors.black12,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: [
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: 8,
                                color: Colors.amber[400],
                                width: 20,
                                borderRadius: BorderRadius.circular(10),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: 20,
                                  color: Colors.amber[100],
                                ),
                              )
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: 10,
                                color: Colors.amber[600],
                                width: 20,
                                borderRadius: BorderRadius.circular(10),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: 20,
                                  color: Colors.amber[100],
                                ),
                              )
                            ],
                          ),
                          BarChartGroupData(
                            x: 3,
                            barRods: [
                              BarChartRodData(
                                toY: 14,
                                color: Colors.amber[800],
                                width: 20,
                                borderRadius: BorderRadius.circular(10),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: 20,
                                  color: Colors.amber[100],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20), // Bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to build a card with an icon
  Widget buildCardWithIcon(
    BuildContext context,
    String name,
    IconData icon,
    Color? color,
    String userId, // Include userId here
  ) {
    return GestureDetector(
      onTap: () {
        // Pass the userId and categoryId to the Students page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Students(
                userId: userId,
                name: name), // Pass the correct values here
          ),
        );
      },
      child: Card(
        color: Colors.white, // White background for the cards
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3), // Softer shadow
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon at the top
            CircleAvatar(
              backgroundColor: color,
              radius: 30.0,
              child: Icon(
                icon,
                color: Colors.white,
                size: 30.0,
              ),
            ),
            const SizedBox(height: 10),
            // Text for the category
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
