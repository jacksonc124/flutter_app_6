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
        builder: (context) => ISpyPage(index: 0, objectsFound: 0, stopwatch: _stopwatch),
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
      body: SingleChildScrollView( // Added scrollable view
        child: Center(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: FittedBox( // Ensures image fits within screen bounds
                  fit: BoxFit.contain,
                  child: Image.asset('images/cover.png'), // Your start image here
                ),
              ),
              Center(
                child: Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.25, // 3/4 of the screen height from the top
                  child: ElevatedButton(
                    onPressed: _gameStarted ? null : _startGame, // Disable button if game has started
                    child: const Text(
                      'Start',
                      style: TextStyle(
                        fontSize: 30, // Larger font size
                        color: Color.fromARGB(255, 86, 29, 124), // Red color for the text
                      ),
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
    Offset(192, 560),
    Offset(120, 400),
    Offset(75, 825),
    Offset(560, 600),
    Offset(620, 370),
    Offset(125, 220),
    Offset(510, 700),
    Offset(575, 150),
    Offset(123, 155),
    Offset(310, 575)
  ];

  static const List<String> objectNames = [
    'A Tiny Pink Shoe',
    'Fred\'s Feather', 
    'A Small Plastic Chicken', 
    'A Girl on a Swing', 
    'A Pair of Small Nail Clippers',
    'A Gold Star', 
    'A Button with a Square on It', 
    'A Small Turtle', 
    'A Pair of Miniature Sunglasses', 
    'A Shell from the Ocean'
  ];

  const ISpyPage({super.key, required this.index, required this.objectsFound, required this.stopwatch});

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
                  'I spy ${ISpyPage.objectNames[widget.index]}!',
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Objects Found: ${widget.objectsFound}',
                  style: const TextStyle(
                    fontSize: 19,
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
                double correctX = ISpyPage.correctPositions[widget.index].dx * scaleX;
                double correctY = ISpyPage.correctPositions[widget.index].dy * scaleY;

                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        ISpyPage.images[widget.index],
                        fit: BoxFit.fill,
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
                              color: _isClicked ? Colors.red : Colors.transparent, // Change to red when clicked
                              width: _isClicked ? 6 : 3, // Thicker border when clicked
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
                            color: const Color.fromARGB(255, 86, 29, 124), // Change text color to red
                            fontSize: 19
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Go back to the previous page
                        },

                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black, // Black icon color
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

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
