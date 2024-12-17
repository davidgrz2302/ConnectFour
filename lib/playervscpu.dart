import 'package:flutter/material.dart';
import 'dart:math'; 


class Connect4GameScreen extends StatefulWidget {
  @override
  _Connect4GameScreenState createState() => _Connect4GameScreenState();
}

class _Connect4GameScreenState extends State<Connect4GameScreen> {
  static const int rows = 6; // Number of rows in the grid
  static const int cols = 7; // Number of columns in the grid

  // 0 = empty, 1 = Player 1, 2 = Player 2 (CPU)
  List<List<int>> grid = List.generate(rows, (_) => List.generate(cols, (_) => 0));

  // Boolean to track if it's Player 1's turn
  bool isPlayerTurn = true;

  String statusMessage = "PLAYER 1'S TURN";

  // Trackers for player wins
  int player1Wins = 0; 
  int player2Wins = 0; 

  @override
  Widget build(BuildContext context) {
    double circleSize = 50; // Diameter of each grid cell 

    return Scaffold(
      backgroundColor: Color(0xFF2D3B4A), 
      appBar: AppBar(
        title: Text('PLAYER VS CPU', style: TextStyle(fontFamily: 'BalooThambi')), // App title
        backgroundColor: Color(0xFFF39C12), 
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.pop(context); // Navigate back to the main menu
          },
        ),
      ),
      body: Column(
        children: [
          // Status message above grid
          Padding(
            padding: const EdgeInsets.only(top: 70.0, bottom: 10.0), 
            child: Text(
              statusMessage.toUpperCase(), // Display the status message in uppercase
              style: TextStyle(
                fontSize: 50, 
                fontWeight: FontWeight.bold,
                color: Colors.white, 
                fontFamily: 'BalooThambi', // Custom font
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Main game area (grid and player information)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center-align the grid and player info
              children: [
                // Player 1's information 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _playerInfo("PLAYER 1", player1Wins), // Widget showing Player 1's name and win count
                  ],
                ),
                SizedBox(width: 20), 

                // The Connect 4 game grid
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF39C12), // Background color for the grid container
                    borderRadius: BorderRadius.circular(16), 
                  ),
                  padding: EdgeInsets.all(8), // Padding around the grid
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Make the grid fit its content
                    children: List.generate(rows, (row) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(cols, (col) {
                          return GestureDetector(
                            onTap: () => _makeMove(col), // Handle taps on the grid to make a move
                            child: Container(
                              width: circleSize, 
                              height: circleSize, 
                              margin: EdgeInsets.all(6), 
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, // Circular grid cells
                                border: Border.all(color: Colors.black, width: 2), 
                                color: _getCellColor(grid[row][col]), // Determine the cell's color based on its state
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ),

                SizedBox(width: 20), 

                // Player 2's (CPU) information 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _playerInfo("PLAYER 2", player2Wins), // Widget showing Player 2's name and win count
                  ],
                ),
              ],
            ),
          ),

          // Game Over section 
          if (_isGameOver()) // Check if the game is over
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 50.0), 
              child: Column(
                children: [
                  // Display "Game Over" message
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

                  // Buttons to replay or return to the main menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // "Play Again" button to reset the game
                      ElevatedButton(
                        onPressed: _playAgain, 
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

                      // Main Menu button 
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Navigate to the main menu
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

  // Display a player's name and win count
  Widget _playerInfo(String playerName, int wins) {
    return Container(
      padding: EdgeInsets.all(10), 
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12), 
      ),
      child: Column(
        children: [
          // Display the player's name
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

          // Display the player's win count
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

  // Determine the color of a grid cell
  Color _getCellColor(int value) {
    if (value == 1) {
      return Colors.red; 
    }
    if (value == 2) {
      return Colors.yellow; 
    }
    return Colors.transparent; 
  }

  // Function to handle Player 1's move
  void _makeMove(int col) {
    if (!isPlayerTurn || _isGameOver()) {
      return; 
    }

    for (int row = rows - 1; row >= 0; row--) {
      if (grid[row][col] == 0) { // Find lowest empty cell in the column
        setState(() {
          grid[row][col] = 1; // Place Player 1's piece
          isPlayerTurn = false; // Switchto Player 2 (CPU)

          if (_checkWin(1)) {
            player1Wins++; // Increment Player 1's win count
            statusMessage = "PLAYER 1 WINS!"; // Win
          } 
          else if (_checkDraw()) {
            statusMessage = "IT'S A DRAW!"; // Draw
          } 
          else {
            statusMessage = "PLAYER 2'S TURN"; // Update status for Player 2's turn
            _aiMove(); // Call the AI move function
          }
        });
        return; 
      }
    }
  }

  // handle the AI's move
  void _aiMove() async {
    await Future.delayed(Duration(milliseconds: 500)); // delay

    int winningCol = _findWinningMove(2); // Can AI win?
    int blockingCol = _findWinningMove(1); // Does AI need to block a move?
    int chosenCol;

    if (winningCol != -1) {
      chosenCol = winningCol; // If AI can win make the move
    } 
    else if (blockingCol != -1) {
      chosenCol = blockingCol; // If Player 1 can win block their move
    } 
    else {
      chosenCol = _findRandomMove(); // Choose a random valid column
    }

    for (int row = rows - 1; row >= 0; row--) {
      if (grid[row][chosenCol] == 0) { // Find lowest empty row in the chosen column
        setState(() {
          grid[row][chosenCol] = 2; // PlaceAI's piece in the grid
          isPlayerTurn = true; // Switch back to Player 1

          if (_checkWin(2)) {
            player2Wins++; // Increment Player 2's win count
            statusMessage = "PLAYER 2 WINS!"; // Win
          } else if (_checkDraw()) {
            statusMessage = "IT'S A DRAW!"; // Draw
          } else {
            statusMessage = "PLAYER 1'S TURN"; // Update the status message for Player 1's turn
          }
        });
        return; 
      }
    }
  }

  // find a winning move for the given player
  int _findWinningMove(int player) {
    for (int col = 0; col < cols; col++) {
      for (int row = rows - 1; row >= 0; row--) {
        if (grid[row][col] == 0) { // Check empty cells
          grid[row][col] = player; // make the move
          bool wouldWin = _checkWin(player); // Check if this move results in a win
          grid[row][col] = 0; // Undo the move

          if (wouldWin) return col; // Return the column if it results in a win
          break; // Exit inner loop after finding a valid row
        }
      }
    }
    return -1; // Return -1 if no winning move is found
  }

  // Random move for AI
  int _findRandomMove() {
    List<int> validCols = []; // List of columns that are not full
    for (int col = 0; col < cols; col++) {
      if (grid[0][col] == 0) {
        validCols.add(col);
      } // Add column if it's not full
    }
    return validCols[Random().nextInt(validCols.length)]; // Choose a random column from valid options
  }

  // Check if the game is over
  bool _isGameOver() {
    return _checkWin(1) || _checkWin(2) || _checkDraw(); 
  }

  // Reset the game state for a new round
  void _playAgain() {
    setState(() {
      grid = List.generate(rows, (_) => List.generate(cols, (_) => 0)); // Reset the grid to empty
      statusMessage = "PLAYER 1'S TURN"; 
      isPlayerTurn = true; 
    });
  }

  // Check if the given player has won
  bool _checkWin(int player) {
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        // Check horizontal, vertical, and both diagonal directions
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

  // Check if there are 4 consecutive pieces in a given direction
  bool _checkDirection(int row, int col, int dRow, int dCol, int player) {
    for (int i = 0; i < 4; i++) { 
      int r = row + i * dRow; 
      int c = col + i * dCol; 
      if (r < 0 || r >= rows || c < 0 || c >= cols || grid[r][c] != player) {
        return false; 
      }
    }
    return true; 
  }

  // Function to check if the game is a draw
  bool _checkDraw() {
    for (int col = 0; col < cols; col++) {
      if (grid[0][col] == 0) return false; 
    }
    return true; 
  }
}














