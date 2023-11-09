import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(TicTacToeApp());

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late List<List<String>> _gameBoard;
  late String _currentPlayer;
  late bool _gameOver;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

void _initializeGame() {
  _gameBoard = List.generate(3, (_) => List.generate(3, (_) => ''));
  _currentPlayer = 'X';
  _gameOver = false;
}


  void _onTileTap(int row, int col) {
    if (!_gameOver && _gameBoard[row][col] == '') {
      setState(() {
        _gameBoard[row][col] = _currentPlayer;
        if (_checkForWin(row, col)) {
          _gameOver = true;
          _showGameOverDialog('Player $_currentPlayer wins!');
        } else if (_gameBoard.every((row) => row.every((cell) => cell != ''))) {
          _gameOver = true;
          _showGameOverDialog('It\'s a draw!');
        } else {
          _currentPlayer = (_currentPlayer == 'X') ? 'O' : 'X';
        }
      });
    }
  }

  bool _checkForWin(int row, int col) {
    final List<List<List<int>>> winningConditions = [
      // Rows
      [[0, 0], [0, 1], [0, 2]],
      [[1, 0], [1, 1], [1, 2]],
      [[2, 0], [2, 1], [2, 2]],
      // Columns
      [[0, 0], [1, 0], [2, 0]],
      [[0, 1], [1, 1], [2, 1]],
      [[0, 2], [1, 2], [2, 2]],
      // Diagonals
      [[0, 0], [1, 1], [2, 2]],
      [[0, 2], [1, 1], [2, 0]],
    ];

    for (final condition in winningConditions) {
      if (condition.every((pos) => _gameBoard[pos[0]][pos[1]] == _currentPlayer)) {
        return true;
      }
    }

    return false;
  }

 void _showGameOverDialog(String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('END GAME'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Play Again'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _initializeGame(); 
              });
            },
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic-Tac-Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Player: $_currentPlayer'),
            Container(
              margin: EdgeInsets.all(20.0),
              child: Column(
                children: List.generate(3, (row) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (col) {
                      return GestureDetector(
                        onTap: () => _onTileTap(row, col),
                        child: Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _gameBoard[row][col],
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_currentPlayer', _currentPlayer));
  }
}
