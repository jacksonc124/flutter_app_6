import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scavenger Hunt of PFT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
        fontFamily: 'BudNull',
      ),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late Stopwatch _stopwatch;
  bool _gameStarted = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  void _startGame() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        _gameStarted = true;
      });
      _stopwatch.start();
      // Navigate to the ISpyPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ISpyPage(
            index: 0,
            objectsFound: 0,
            stopwatch: _stopwatch,
            playerName: _nameController.text,
          ),
        ),
      );
    } else {
      _showErrorDialog();
    }
  }

  void _restartGame() {
    setState(() {
      _gameStarted = false;
      _stopwatch.reset();
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const StartPage(),
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: const Text("Please enter your name to start the game."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Back button functionality
          },
        ),
        automaticallyImplyLeading: false, // Removes the default back button
        toolbarHeight: 0, // Removes the top box (app bar height)
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.asset('images/cover.png'),
                ),
              ),
              Center(
                child: Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: "Enter Your Name",
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black45,
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _gameStarted ? null : _startGame,
                        child: const Text(
                          'Start',
                          style: TextStyle(
                            fontSize: 60,
                            color: Color.fromARGB(255, 86, 29, 124),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_gameStarted)
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: _restartGame,
                    child: const Text(
                      'Restart',
                      style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 86, 29, 124),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ISpyPage extends StatefulWidget {
  final int index;
  final int objectsFound;
  final Stopwatch stopwatch;
  final String playerName;

  static const List<String> images = [
    'images/iSpyPage1.jpg',
    'images/iSpyPage2.jpg',
    'images/iSpyPage3.jpg',
    'images/iSpyPage4.jpg',
    'images/iSpyPage5.jpg',
    'images/iSpyPage6.jpg',
    'images/iSpyPage7.jpg',
    'images/iSpyPage8.jpg',
    'images/iSpyPage9.jpg',
    'images/iSpyPage10.jpg',
  ];

  static const List<Offset> correctPositions = [
    Offset(370, 450),
    Offset(300, 450),
    Offset(370, 725),
    Offset(450, 350),
    Offset(215, 200),
    Offset(135, 220),
    Offset(130, 840),
    Offset(575, 150),
    Offset(200, 280),
    Offset(310, 575)
  ];

  static const List<String> objectNames = [
    'What could I use to enter the doors of Patrick F. Taylor Hall?',
    'What can I find on the second floor?',
    'What is the year the engineering honors society started?',
    'Where can I order food between classes?',
    'Where can I get my tiger card?',
    'What is on my class door?',
    'Where should the missing brick go?',
    'Where can I find a building camera?',
    'Where can I find a 3D printer?',
    'What Happened To The Ceiling Tile??',
  ];

  const ISpyPage({
    super.key,
    required this.index,
    required this.objectsFound,
    required this.stopwatch,
    required this.playerName,
  });

  @override
  _ISpyPageState createState() => _ISpyPageState();
}

class _ISpyPageState extends State<ISpyPage> {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(186, 86, 29, 124),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                Text(
                  ISpyPage.objectNames[widget.index],
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Items "Scavenged" -  ${widget.objectsFound}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double scaleX = constraints.maxWidth / 800;
                double scaleY = constraints.maxHeight / 920;
                double correctX =
                    ISpyPage.correctPositions[widget.index].dx * scaleX;
                double correctY =
                    ISpyPage.correctPositions[widget.index].dy * scaleY;

                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        ISpyPage.images[widget.index],
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Positioned(
                      left: correctX,
                      top: correctY,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isClicked = true;
                          });

                          Future.delayed(const Duration(seconds: 1), () {
                            if (widget.index < ISpyPage.images.length - 1) {
                              Navigator.push(
                                context,
                                _createPageFlipTransition(
                                  ISpyPage(
                                    index: widget.index + 1,
                                    objectsFound: widget.objectsFound + 1,
                                    stopwatch: widget.stopwatch,
                                    playerName: widget.playerName,
                                  ),
                                ),
                              );
                            } else {
                              _showFinalScore(context);
                            }
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: _isClicked
                                  ? Colors.red
                                  : const Color.fromARGB(24, 247, 0, 255),
                              width: _isClicked ? 6 : 3,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.index < ISpyPage.images.length - 1) {
                            Navigator.push(
                              context,
                              _createPageFlipTransition(
                                ISpyPage(
                                  index: widget.index + 1,
                                  objectsFound: widget.objectsFound,
                                  stopwatch: widget.stopwatch,
                                  playerName: widget.playerName,
                                ),
                              ),
                            );
                          } else {
                            _showFinalScore(context);
                          }
                        },
                        child: Text(
                          'Give Up',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 86, 29, 124),
                              fontSize: 35),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            _createPageFlipTransition(
                              const StartPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Restart',
                          style: TextStyle(
                            fontSize: 35,
                            color: Color.fromARGB(255, 86, 29, 124),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFinalScore(BuildContext context) {
    widget.stopwatch.stop(); // Stop the stopwatch when the game is over

    // Calculate score based on the number of objects found
    int score =
        widget.objectsFound; // Score is the number of objects found (out of 10)

    // For the rank, you might want to have a predefined list of scores or a leaderboard
    // For simplicity, I'm assuming a static leaderboard here.
    List<Map<String, dynamic>> leaderboard = [
      {'name': 'Player1', 'score': 10},
      {'name': 'Player2', 'score': 9},
      {'name': 'Player3', 'score': 8},
      {'name': 'Player4', 'score': 7},
      {'name': 'Player5', 'score': 6},
      {'name': 'Player6', 'score': 5},
      {'name': 'Player7', 'score': 4},
      {'name': 'Player8', 'score': 3},
      {'name': 'Player9', 'score': 2},
      {'name': 'Player10', 'score': 1},
    ]; // Example leaderboard data

    // Calculate player's rank
    int rank = leaderboard.indexWhere((player) => player['score'] <= score) + 1;

    // Show Game Over dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Game Over!',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Player: ${widget.playerName}', // Display player name
              style: const TextStyle(fontSize: 25),
            ),
            Text(
              'Total Time: ${widget.stopwatch.elapsed.inMinutes}:${widget.stopwatch.elapsed.inSeconds % 60}', // Display total time
              style: const TextStyle(fontSize: 25),
            ),
            Text(
              'Objects Found: ${widget.objectsFound}', // Display number of objects found
              style: const TextStyle(fontSize: 25),
            ),
            Text(
              'Score: $score/10', // Display score out of 10
              style: const TextStyle(fontSize: 25),
            ),
            Text(
              'Rank: #$rank', // Display rank based on leaderboard
              style: const TextStyle(fontSize: 25),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the game over dialog
              Navigator.pushReplacement(
                context,
                _createPageFlipTransition(
                  const StartPage(), // Navigate back to the start page
                ),
              );
            },
            child: const Text(
              'Restart', // Button to restart the game
              style: TextStyle(fontSize: 20),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the game over dialog
              _showLeaderboard(
                  context, leaderboard); // Show the leaderboard dialog
            },
            child: const Text(
              'Show Leaderboard', // Button to show the leaderboard
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _showLeaderboard(
      BuildContext context, List<Map<String, dynamic>> leaderboard) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: leaderboard.map((player) {
              return Text(
                '${player['name']} - ${player['score']} points', // Display each player's name and score
                style: const TextStyle(fontSize: 20),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the leaderboard dialog
            },
            child: const Text(
              'Close',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  PageRouteBuilder _createPageFlipTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
