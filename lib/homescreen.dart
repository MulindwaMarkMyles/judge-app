import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the chart package
import 'package:judge_app_2/students.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
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
                    "Hi, Name",
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
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(16.0),
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
                      buildCardWithIcon(context, 'Total Category', Icons.group, Colors.amber[300]),
                      buildCardWithIcon(context, 'Mini Category', Icons.child_care, Colors.amber[400]),
                      buildCardWithIcon(context, 'Little Category', Icons.school, Colors.amber[600]),
                      buildCardWithIcon(context, 'Teen Category', Icons.emoji_people, Colors.amber[800]),
                    ],
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
                            // tooltipBgColor: Colors.amberAccent.withOpacity(0.8),
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
                                    return const Text("Total", style: TextStyle(color: Colors.black));
                                  case 2:
                                    return const Text("Mini", style: TextStyle(color: Colors.black));
                                  case 3:
                                    return const Text("Little", style: TextStyle(color: Colors.black));
                                  case 4:
                                    return const Text("Teen", style: TextStyle(color: Colors.black));
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
                                return Text('${value.toInt()}', style: const TextStyle(color: Colors.black54));
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
  Widget buildCardWithIcon(BuildContext context, String title, IconData icon, Color? color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Students()),
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
              title,
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
