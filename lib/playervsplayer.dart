import 'package:flutter/material.dart';

class Connect4PvPGameScreen extends StatefulWidget {
  @override
  _Connect4PvPGameScreenState createState() => _Connect4PvPGameScreenState();
}

class _Connect4PvPGameScreenState extends State<Connect4PvPGameScreen> {
  static const int rows = 6; 
  static const int cols = 7;

  // 0 = empty, 1 = Player 1, 2 = Player 2.
  List<List<int>> grid = List.generate(rows, (_) => List.generate(cols, (_) => 0));

  // Boolean to track if it's Player 1's turn.
  bool isPlayer1Turn = true;

  String statusMessage = "PLAYER 1'S TURN";

  // Trackers for player wins.
  int player1Wins = 0; 
  int player2Wins = 0; 

  @override
  Widget build(BuildContext context) {
    double circleSize = 50; // Diameter of each grid cell 

    return Scaffold(
      backgroundColor: Color(0xFF2D3B4A), 
      appBar: AppBar(
        title: Text(
          'PLAYER VS PLAYER',
          style: TextStyle(fontFamily: 'BalooThambi'), // App bar title.
        ),
        backgroundColor: Color(0xFF1ABC9C), 
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.pop(context); // Go back to the main menu.
          },
        ),
      ),
      body: Column(
        children: [
          // Status message displayed above the grid.
          Padding(
            padding: const EdgeInsets.only(top: 70.0, bottom: 10.0),
            child: Text(
              statusMessage.toUpperCase(), // Convert the status message to uppercase.
              style: TextStyle(
                fontSize: 50, 
                fontWeight: FontWeight.bold,
                color: Colors.white, 
                fontFamily: 'BalooThambi', 
              ),
              textAlign: TextAlign.center, 
            ),
          ),

          // Main game area 
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                // Player 1's information on the left.
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _playerInfo("PLAYER 1", player1Wins), // Player 1's info.
                  ],
                ),
                SizedBox(width: 20), 

                // The Connect 4 grid 
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1ABC9C), 
                    borderRadius: BorderRadius.circular(16), 
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, 
                    children: List.generate(rows, (row) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(cols, (col) {
                          return GestureDetector(
                            onTap: () => _makeMove(col), // Handle taps on the grid.
                            child: Container(
                              width: circleSize,
                              height: circleSize, 
                              margin: EdgeInsets.all(6), 
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, 
                                border: Border.all(color: Colors.black, width: 2), 
                                color: _getCellColor(grid[row][col]), // Determines the cell's color.
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ),

                SizedBox(width: 20), 

                // Player 2's information on the right.
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _playerInfo("PLAYER 2", player2Wins), // Player 2's info.
                  ],
                ),
              ],
            ),
          ),

          // Game Over section 
          if (_isGameOver()) // Check if the game is over.
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 50.0),
              child: Column(
                children: [
                  // Game Over message.
                  Text(
                    "GAME OVER",
                    style: TextStyle(
                      fontSize: 40, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                      fontFamily: 'BalooThambi',
                    ),
                  ),
                  SizedBox(height: 10), 

                  // Buttons to play again or go to the main menu.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Button to reset the game state.
                      ElevatedButton(
                        onPressed: _playAgain, // Reset the game.
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          backgroundColor: Colors.green, 
                          foregroundColor: Colors.black, 
                        ),
                        child: Text(
                          "Play Again",
                          style: TextStyle(fontSize: 18, fontFamily: 'BalooThambi'),
                        ),
                      ),
                      SizedBox(width: 20), 

                      // Button to go back to the main menu.
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Navigate back to the main menu.
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          backgroundColor: Colors.red, 
                          foregroundColor: Colors.black, 
                        ),
                        child: Text(
                          "Main Menu",
                          style: TextStyle(fontSize: 18, fontFamily: 'BalooThambi'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Display a player's information 
  Widget _playerInfo(String playerName, int wins) {
    return Container(
      padding: EdgeInsets.all(10), 
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12), 
      ),
      child: Column(
        children: [
          // Display the player's name.
          Text(
            playerName,
            style: TextStyle(
              color: Colors.black, 
              fontSize: 16, 
              fontWeight: FontWeight.bold,
              fontFamily: 'BalooThambi',
            ),
          ),
          SizedBox(height: 10), 

          // Display the player's win count.
          Text(
            '$wins',
            style: TextStyle(
              color: Colors.black, 
              fontSize: 24, 
              fontWeight: FontWeight.bold,
              fontFamily: 'BalooThambi',
            ),
          ),
        ],
      ),
    );
  }

  // Determine the color of a grid cell based on its value.
  Color _getCellColor(int value) {
    if (value == 1) {
      return Colors.red; 
    }
    if (value == 2) {
      return Colors.yellow; 
    }
    return Colors.transparent; // Empty cells are transparent.
  }

  // Handle a player's move when a column is tapped.
  void _makeMove(int col) {
    if (_isGameOver()) {
      return; 
    }

    for (int row = rows - 1; row >= 0; row--) {
      if (grid[row][col] == 0) { // Find the lowest empty row in the column.
        setState(() {
          grid[row][col] = isPlayer1Turn ? 1 : 2; // Place piece for the current player.

          // Check if the current player has won.
          if (_checkWin(isPlayer1Turn ? 1 : 2)) {
            if (isPlayer1Turn) {
              player1Wins++; // Add to win total (player 1)
              statusMessage = "PLAYER 1 WINS!";
            } else {
              player2Wins++; // Add to win total (player 2)
              statusMessage = "PLAYER 2 WINS!";
            }
          } else if (_checkDraw()) {
            statusMessage = "IT'S A DRAW!"; // Draw
          } else {
            isPlayer1Turn = !isPlayer1Turn; // Switch turns between players.
            statusMessage = isPlayer1Turn ? "PLAYER 1'S TURN" : "PLAYER 2'S TURN";
          }
        });
        return;
      }
    }
  }

  // Function to check if the game is over.
  bool _isGameOver() {
    return _checkWin(1) || _checkWin(2) || _checkDraw(); 
  }

  // Reset the game for a new round.
  void _playAgain() {
    setState(() {
      grid = List.generate(rows, (_) => List.generate(cols, (_) => 0)); // Reset the grid.
      statusMessage = "PLAYER 1'S TURN";
      isPlayer1Turn = true; // Reset to Player 1's turn.
    });
  }

  // Check if a given player has won.
  bool _checkWin(int player) {
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        // Check horizontal, vertical, and diagonal directions.
        if (_checkDirection(row, col, 1, 0, player) || 
            _checkDirection(row, col, 0, 1, player) || 
            _checkDirection(row, col, 1, 1, player) || 
            _checkDirection(row, col, 1, -1, player)) { 
          return true; 
        }
      }
    }
    return false; 
  }

  // Check for 4 consecutive pieces in a given direction.
  bool _checkDirection(int row, int col, int dRow, int dCol, int player) {
    for (int i = 0; i < 4; i++) { 
      int r = row + i * dRow; // Row in the current direction.
      int c = col + i * dCol; // Column in the current direction.
      if (r < 0 || r >= rows || c < 0 || c >= cols || grid[r][c] != player) {
        return false; 
      }
    }
    return true; 
  }

  // Check if the game is a draw.
  bool _checkDraw() {
    for (int col = 0; col < cols; col++) {
      if (grid[0][col] == 0) return false; 
    }
    return true; // Return true if all columns are full.
  }
}

