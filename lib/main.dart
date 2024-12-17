import 'package:flutter/material.dart';
import 'playervscpu.dart'; 
import 'playervsplayer.dart'; 
import 'rules.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Connect4HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Connect4HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D3B4A), 
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          
            Padding(
              padding: EdgeInsets.only(top: 160), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'CONNECT 4',
                    style: TextStyle(
                      fontFamily: 'BalooThambi', // Custom font for the title
                      fontSize: 90, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10), // Spacing between title and buttons
                  CustomButton(
                    label: 'PLAY VS CPU',
                    backgroundColor: Color(0xFFF39C12), 
                    // Navigates to the Player vs CPU game screen
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Connect4GameScreen()), 
                      );
                    },
                  ),
                  SizedBox(height: 30), 
                  // Navigates to the player vs player screen
                  CustomButton(
                    label: 'PLAY VS PLAYER',
                    backgroundColor: Color(0xFF1ABC9C), 
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Connect4PvPGameScreen()), 
                      );
                    },
                  ),
                  SizedBox(height: 30), 
                  // Navigates to the rules screen
                  CustomButton(
                    label: 'GAME RULES',
                    backgroundColor: Color(0xFF8E44AD), 
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RulesScreen()), 
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 60), 
            Image.asset(
              'assets/board1.png', // Path to the board image
              height: 500, 
              fit: BoxFit.contain, // Ensures the image maintains its aspect ratio
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const CustomButton({
    required this.label, // Label text for the button
    required this.backgroundColor,// Background color of the button
    required this.onPressed, // Function to execute on button press
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Black shadow background for the button
        Positioned(
          top: -4,
          left: -4, 
          right: -4, 
          bottom: -12, 
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black, 
              borderRadius: BorderRadius.circular(22), // Rounded corners for the shadow
            ),
          ),
        ),
        // Main button design
        SizedBox(
          width: 350, // Button width
          child: ElevatedButton(
            onPressed: onPressed, // Button action
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor, // Button background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Rounded corners for the button
              ),
              padding: EdgeInsets.symmetric(vertical: 25), // Button padding
              elevation: 0, // No shadow
              alignment: Alignment.centerLeft, // Aligns text to the left
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 30), // Adds padding for left-aligned text
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'BalooThambi', // Custom font for buttons
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, 
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}