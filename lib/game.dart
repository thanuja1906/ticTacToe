import 'dart:async';
import 'package:flutter/material.dart';
import 'colors.dart';

class Game extends StatefulWidget {
  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  bool isX = true;
  List<String> displayXO = [" ", " ", " ", " ", " ", " ", " ", " ", " "];
  List<int> selectedIndex = [];
  int xCount = 0;
  int oCount = 0;
  int tieCount = 0;
  String resultDeclaration = "";

  bool isReset = false;

  static const int maxSeconds = 30;
  int seconds = maxSeconds;

  Timer? timer;

  void _onTap(int index) {
    final isRunning = timer != null && timer!.isActive;

    if (isRunning && displayXO[index] == " ") {
      setState(() {
        displayXO[index] = isX ? "X" : "O";
        tieCount++;
        isX = !isX;

        _checkWin();
      });
    }
  }

  void _checkWin() {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (displayXO[i] != " " &&
          displayXO[i] == displayXO[i + 1] &&
          displayXO[i] == displayXO[i + 2]) {
        _declareWinner(displayXO[i], [i, i + 1, i + 2]);
        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (displayXO[i] != " " &&
          displayXO[i] == displayXO[i + 3] &&
          displayXO[i] == displayXO[i + 6]) {
        _declareWinner(displayXO[i], [i, i + 3, i + 6]);
        return;
      }
    }

    // Check diagonals
    if (displayXO[0] != " " &&
        displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8]) {
      _declareWinner(displayXO[0], [0, 4, 8]);
      return;
    }
    if (displayXO[2] != " " &&
        displayXO[2] == displayXO[4] &&
        displayXO[2] == displayXO[6]) {
      _declareWinner(displayXO[2], [2, 4, 6]);
      return;
    }

    // Check for tie
    if (!isReset && tieCount == 9) {
      setState(() {
        resultDeclaration = "TIE!";
        _stopTimer();
      });
    }
  }

  void _declareWinner(String player, List<int> winningIndices) {
    setState(() {
      resultDeclaration = "Player $player Wins";
      selectedIndex.addAll(winningIndices);
      _stopTimer();
      _updateScore(player);
    });
  }

  void _updateScore(String player) {
    setState(() {
      if (player == "X") {
        xCount++;
      } else if (player == "O") {
        oCount++;
      }
      isReset = true;
    });
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayXO[i] = " ";
      }
      resultDeclaration = "";
      selectedIndex.clear();
      isReset = false;
      tieCount = 0; // Reset tie count
    });
    _resetTimer(); // Reset the timer
  }

  Widget _buildTimer() {
    final isRunning = timer != null && timer!.isActive;
    return isRunning
        ? SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxSeconds,
                  backgroundColor: AppColors.progressBackgroundColor,
                  strokeWidth: 8,
                  valueColor:
                      AlwaysStoppedAnimation(AppColors.progressValueColor),
                ),
                Center(
                  child: Text(
                    '$seconds',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.progressValueColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              foregroundColor: AppColors.buttonTextColor,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
            ),
            onPressed: () {
              _startTimer();
              _clearBoard();
            },
            child: Text(
              "Start",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonTextColor,
              ),
            ),
          );
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    timer?.cancel();
    _resetTimer();
  }

  void _resetTimer() {
    setState(() {
      seconds = maxSeconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          "Tic Tac Toe",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Pacifico",
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        leading: Icon(Icons.person),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "Score Board",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => _onTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 5,
                          color: AppColors.secondaryColor,
                        ),
                        color: selectedIndex.contains(index)
                            ? AppColors.tileColor
                            : AppColors.progressBackgroundColor,
                      ),
                      child: Center(
                        child: Text(
                          displayXO[index],
                          style: TextStyle(
                              fontSize: 50, color: AppColors.textColor),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      resultDeclaration,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    _buildTimer(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Player X",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          xCount.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Player O",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          oCount.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
