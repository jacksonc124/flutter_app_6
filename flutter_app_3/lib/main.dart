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

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  void _startGame() {
    setState(() {
      _gameStarted = true;
    });
    _stopwatch.start();
    // Navigate to the ISpyPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ISpyPage(index: 0, objectsFound: 0, stopwatch: _stopwatch),
      ),
    );
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
        // Added scrollable view
        child: Center(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: FittedBox(
                  // Ensures image fits within screen bounds
                  fit: BoxFit.contain,
                  child:
                      Image.asset('images/cover.png'), // Your start image here
                ),
              ),
              Center(
                child: Positioned(
                  bottom: MediaQuery.of(context).size.height *
                      0.25, // 3/4 of the screen height from the top
                  child: ElevatedButton(
                    onPressed: _gameStarted
                        ? null
                        : _startGame, // Disable button if game has started
                    child: const Text(
                      'Start',
                      style: TextStyle(
                        fontSize: 60, // Larger font size
                        color: Color.fromARGB(
                            255, 86, 29, 124), // Red color for the text
                      ),
                    ),
                  ),
                ),
              ),
              // Display Restart button only if the game has started
              if (_gameStarted)
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: _restartGame, // Restart button
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

  const ISpyPage(
      {super.key,
      required this.index,
      required this.objectsFound,
      required this.stopwatch});

  @override
  _ISpyPageState createState() => _ISpyPageState();
}

class _ISpyPageState extends State<ISpyPage> {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow here as well
        toolbarHeight: 0, // Remove the top box (app bar height)
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
                            _isClicked = true; // Set clicked to true
                          });

                          // Delay for 1 second to show the circle
                          Future.delayed(const Duration(seconds: 1), () {
                            if (widget.index < ISpyPage.images.length - 1) {
                              Navigator.push(
                                context,
                                _createPageFlipTransition(
                                  ISpyPage(
                                    index: widget.index + 1,
                                    objectsFound: widget.objectsFound + 1,
                                    stopwatch: widget.stopwatch,
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
                                  : const Color.fromARGB(24, 247, 0,
                                      255), // Change to red when clicked
                              width: _isClicked
                                  ? 6
                                  : 3, // Thicker border when clicked
                            ),
                            shape: BoxShape.circle, // Make it circular
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
                              color: const Color.fromARGB(
                                  255, 86, 29, 124), // Change text color to red
                              fontSize: 35),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Go back to the previous page
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black, // Black icon color
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          // Restart game and go back to StartPage
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
    widget.stopwatch.stop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Game Over!',
          style: TextStyle(
            fontSize: 30, // Larger font size for "Game Over"
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Your final score: ${widget.objectsFound + 1}/${ISpyPage.images.length}\nTime: ${widget.stopwatch.elapsedMilliseconds / 1000} seconds',
          style: const TextStyle(
            fontSize: 22, // Larger font size for final score text
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                _createPageFlipTransition(
                  const StartPage(),
                ),
              );
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  // Custom page flip animation transition
  PageRouteBuilder _createPageFlipTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Start from the right
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
