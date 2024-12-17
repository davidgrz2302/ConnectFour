import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D3B4A),
      appBar: AppBar(
        title: Text('GAME RULES', style: TextStyle(fontFamily: 'BalooThambi')),
        backgroundColor: Color(0xFF8E44AD),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the main menu
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              "HOW TO PLAY CONNECT 4",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'BalooThambi',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Cool Divider
            Divider(
              color: Colors.yellow,
              thickness: 2,
            ),
            SizedBox(height: 20),

            // Rules List
            Expanded(
              child: ListView(
                children: [
                  _buildRuleItem(
                    icon: Icons.circle_outlined,
                    text: "The game is played on a 6x7 grid.",
                  ),
                  _buildRuleItem(
                    icon: Icons.person,
                    text:
                        "Players take turns dropping their colored discs into the columns of the grid.",
                  ),
                  _buildRuleItem(
                    icon: Icons.format_line_spacing,
                    text:
                        "The goal is to form a line of four discs horizontally, vertically, or diagonally.",
                  ),
                  _buildRuleItem(
                    icon: Icons.block,
                    text:
                        "Players can block their opponent’s moves by placing a disc strategically.",
                  ),
                  _buildRuleItem(
                    icon: Icons.lightbulb_outline,
                    text:
                        "The game ends when a player wins or the grid is completely filled (resulting in a draw).",
                  ),
                ],
              ),
            ),

            // Cool Footer Section
            Text(
              "Have Fun!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
                fontFamily: 'BalooThambi',
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper Method to Build Each Rule Item
  Widget _buildRuleItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.yellow, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'BalooThambi',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
