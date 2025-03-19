import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

// Global leaderboard storage
class LeaderboardData {
  static List<Map<String, dynamic>> scores = [];

  static void addScore(String name, int score) {
    scores.add({'name': name, 'score': score});
    scores.sort((a, b) => b['score'].compareTo(a['score']));
  }
}

// Global quiz leaderboard storage
class QuizLeaderboardData {
  static List<Map<String, dynamic>> quizScores = [];

  static void addScore(String name, int score) {
    quizScores.add({'name': name, 'score': score});
    quizScores.sort((a, b) => b['score'].compareTo(a['score']));
  }
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
        fontFamily: 'Proxima',
      ),
      home: const StartPage(),
    );
  }
}

class SurveyPage extends StatefulWidget {
  final String playerName;
  final bool hasPreviousAnswers;

  const SurveyPage({
    super.key,
    required this.playerName,
    this.hasPreviousAnswers = false,
  });

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  // List to hold the selected answers for each question
  List<int?> selectedAnswers = List.filled(10, null);

  // List of questions
  final List<String> questions = [
    'What program did Patrick F. Taylor develop?',
    'What year was Patrick F. Taylor Hall built?',
    'What is the name of the engineering honor society in PFT?',
    'What is the main color scheme of PFT?',
    'What is the name of the simulation lab in PFT?',
    'What is the name of the food establishment in PFT?',
    'What is the name of the card used to enter LSU campus spaces?',
    'What year was LSU\'s College of Engineering established?',
    'What is the name of the engineering program at LSU?',
    'What is the name of the student organization that provides free tutoring in PFT?',
  ];

  // List of options for each question
  final List<List<String>> options = [
    [
      'LSU Marching Band',
      'New Orleans Saints',
      'Taylor Opportunity Program for Students (TOPS)',
      'PFT Tour Guides'
    ],
    ['1990', '1995', '2000', '2005'],
    [
      'Tau Beta Pi',
      'Phi Beta Kappa',
      'Sigma Alpha Epsilon',
      'Delta Delta Delta'
    ],
    ['Purple and Gold', 'Red and Black', 'Blue and White', 'Green and Yellow'],
    [
      'Traffic Simulation Lab',
      'Car Room',
      'Transportation Lab',
      'Vehicle Testing Center'
    ],
    ['Panera Bread', 'Starbucks', 'Subway', 'Chick-fil-A'],
    ['Tiger Card', 'LSU Card', 'Student ID', 'Access Card'],
    ['1908', '1910', '1912', '1914'],
    [
      'College of Engineering',
      'School of Engineering',
      'Department of Engineering',
      'Engineering Institute'
    ],
    [
      'Engineering Student Tutors',
      'PFT Tutors',
      'Engineering Success Center',
      'Student Help Desk'
    ],
  ];

  // List of correct answers for each question (index of the correct answer in the options list)
  final List<int> correctAnswers = [
    2, // TOPS
    0, // 1990
    0, // Tau Beta Pi
    0, // Purple and Gold
    1, // Car Room
    0, // Panera Bread
    0, // Tiger Card
    0, // 1908
    0, // College of Engineering
    2, // Engineering Success Center
  ];

  int score = 0; // To keep track of the score

  // Function to calculate the score based on selected answers
  void calculateScore() {
    int tempScore = 0;
    for (int i = 0; i < selectedAnswers.length; i++) {
      if (selectedAnswers[i] == correctAnswers[i]) {
        tempScore++;
      }
    }
    setState(() {
      score = tempScore; // Update the score after the quiz
    });

    // Add score to quiz leaderboard
    QuizLeaderboardData.addScore(widget.playerName, tempScore);
  }

  // Function to show quiz leaderboard
  void _showQuizLeaderboard() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Quiz Leaderboard',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        content: QuizLeaderboardData.quizScores.isEmpty
            ? const Text("No quiz scores yet.", style: TextStyle(fontSize: 20))
            : SingleChildScrollView(
                child: Column(
                  children: QuizLeaderboardData.quizScores.map((player) {
                    return Text(
                      '${player['name']} - ${player['score']}/10',
                      style: const TextStyle(fontSize: 20),
                    );
                  }).toList(),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
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

  // Function to load saved answers
  Future<void> _loadSavedAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < selectedAnswers.length; i++) {
        selectedAnswers[i] = prefs.getInt('${widget.playerName}_answer_$i');
      }
    });
  }

  // Function to save answers
  Future<void> _saveAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < selectedAnswers.length; i++) {
      if (selectedAnswers[i] != null) {
        await prefs.setInt(
            '${widget.playerName}_answer_$i', selectedAnswers[i]!);
      }
    }
  }

  // Function to clear saved answers for a specific player
  Future<void> _clearSavedAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < selectedAnswers.length; i++) {
      await prefs.remove('${widget.playerName}_answer_$i');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.hasPreviousAnswers) {
      _loadSavedAnswers();
    }
  }

  @override
  void dispose() {
    // Only clear answers if the player is starting a new game
    if (!widget.hasPreviousAnswers) {
      _clearSavedAnswers();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.playerName}'s PFT Quiz"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 70, 29, 124),
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: const Color.fromARGB(255, 253, 208, 35),
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('iSpy'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ISpyPage(
                          index: 0,
                          objectsFound: 0,
                          playerName: '',
                          hasPreviousAnswers: widget.hasPreviousAnswers)),
                );
              },
            ),
            ListTile(
              title: Text('Interactive Quiz'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SurveyPage(
                            playerName: widget.playerName,
                            hasPreviousAnswers: widget.hasPreviousAnswers,
                          )),
                );
              },
            ),
            ListTile(
              title: Text('Map of PFT'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Quiz Leaderboard'),
              onTap: () {
                _showQuizLeaderboard();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // List of questions and options
            ...List.generate(10, (index) {
              return QuestionWidget(
                question: questions[index],
                options: options[index],
                selectedAnswer: selectedAnswers[index],
                onChanged: (value) {
                  setState(() {
                    selectedAnswers[index] = value;
                  });
                  _saveAnswers(); // Save answers whenever they change
                },
              );
            }),

            // Submit Button
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                calculateScore();
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Your Score'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'You got $score out of 10 correct!',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Quiz Leaderboard',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          QuizLeaderboardData.quizScores.isEmpty
                              ? Text("No quiz scores yet.",
                                  style: TextStyle(fontSize: 16))
                              : Column(
                                  children: QuizLeaderboardData.quizScores
                                      .map((player) {
                                    return Text(
                                      '${player['name']} - ${player['score']}/10',
                                      style: TextStyle(fontSize: 16),
                                    );
                                  }).toList(),
                                ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StartPage(),
                            ),
                          );
                        },
                        child: Text('Return Home'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final String question;
  final List<String> options;
  final int? selectedAnswer;
  final ValueChanged<int?> onChanged;

  QuestionWidget({
    required this.question,
    required this.options,
    required this.selectedAnswer,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...List.generate(options.length, (index) {
          return RadioListTile<int?>(
            title: Text(options[index]),
            value: index,
            groupValue: selectedAnswer,
            onChanged: onChanged,
          );
        }),
        Divider(),
      ],
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool _gameStarted = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _hasPreviousAnswers(String name) async {
    final prefs = await SharedPreferences.getInstance();
    // Check if any answers exist for this name
    return prefs.getInt('${name}_answer_0') != null;
  }

  void _startGame() async {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        _gameStarted = true;
      });

      // Check if this player has previous answers
      bool hasPreviousAnswers = await _hasPreviousAnswers(_nameController.text);

      // Navigate to the ISpyPage with the provided player name
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ISpyPage(
            index: 0,
            objectsFound: 0,
            playerName: _nameController.text,
            hasPreviousAnswers: hasPreviousAnswers,
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

  // Leaderboard dialog shown from StartPage
  void _showLeaderboard() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Leaderboard',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        content: LeaderboardData.scores.isEmpty
            ? const Text("No scores yet.", style: TextStyle(fontSize: 20))
            : SingleChildScrollView(
                child: Column(
                  children: LeaderboardData.scores.map((player) {
                    return Text(
                      '${player['name']} - ${player['score']} points',
                      style: const TextStyle(fontSize: 20),
                    );
                  }).toList(),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text(
              'Close',
              style: TextStyle(fontSize: 20),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog and restart game
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StartPage(),
                ),
              );
            },
            child: const Text(
              'Restart',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hide default app bar (toolbarHeight set to 0)
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
              // Background image
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Opacity(
                  opacity: 0.62, // Adjust the opacity value as needed
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image.asset('images/cover.png'),
                  ),
                ),
              ),
              //LSU logo
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Image.asset(
                  'images/lsu.png',
                  width: 40,
                  height: 40,
                ),
              ),
              // Instructional text beneath the LSU image
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 241, 238, 219),
                      border:
                          Border.all(color: Color.fromARGB(255, 86, 29, 124)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Welcome to the LSU: Patrick F. Taylor Hall Scavenger Hunt! \n In this app, you will navigate through a series of iSpy-themed questions, followed by more in-depth, specific questions that will require you to find the location within the iSpy game. \nGood luck and have fun! \n\nEnter your name and tap 'Start' to begin.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 86, 29, 124),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // Name entry, Start button, and View Leaderboard button positioned near the bottom
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.10,
                left: 0,
                right: 0,
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
                          fontSize: 30,
                          color: Color.fromARGB(255, 86, 29, 124),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _showLeaderboard,
                      child: const Text(
                        'View Leaderboard',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 86, 29, 124),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Restart button if game has started
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
  final String playerName;
  final bool hasPreviousAnswers;

  // List of background images for each scavenger hunt page
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
  ];

  // Correct positions for the tap targets
  static const List<Offset> correctPositions = [
    Offset(390, 480),
    Offset(415, 450),
    Offset(360, 790),
    Offset(500, 380),
    Offset(215, 220),
    Offset(175, 240),
    Offset(138, 860),
    Offset(605, 165),
    Offset(215, 315),
  ];

  // Object names/questions for each page
  static const List<String> objectNames = [
    'What could I use to enter the doors of Patrick F. Taylor Hall?',
    'Where is the branding on the car I can find on the second floor?',
    'What is the year the engineering honors society started?',
    'What can I order my food on between classes?',
    'Where can I get my tiger card?',
    'What is taped to my class door?',
    'Where should the missing brick go?',
    'Where can I find a building camera?',
    'Where can I find a bright neon Chevron logo?',
  ];

  static const List<String> objectDescriptions = [
    'You can enter the PFT using the main entrance!',
    'Also known as the car room, students use this simulation lab to study traffic, highway design, saftey, and more!',
    'The engineering honor society was established in 1936!',
    'You can order food using one of the Panera Bread kiosks!',
    'You can get your Tiger Card at the tiger card kiosk in zone 1300!',
    'Professors may sometimes tape class notices on the door, pay attention!',
    'The missing brick fits in the in the bottom left of the pavement!',
    'Security cameras monitor various parts of the building, ensuring your saftey!',
    'The Chevron Center is a resource for engineers interested in becoming a distinguished communicator!',
  ];

  const ISpyPage({
    super.key,
    required this.index,
    required this.objectsFound,
    required this.playerName,
    this.hasPreviousAnswers = false,
  });

  @override
  _ISpyPageState createState() => _ISpyPageState();
}

class _ISpyPageState extends State<ISpyPage> {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 70, 29, 124),
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: const Color.fromARGB(255, 253, 208, 35),
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('iSpy'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ISpyPage(
                            index: widget.index,
                            objectsFound: widget.objectsFound,
                            playerName: widget.playerName,
                            hasPreviousAnswers: widget.hasPreviousAnswers,
                          )),
                );
              },
            ),
            ListTile(
              title: Text('Interactive Quiz'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SurveyPage(
                            playerName: widget.playerName,
                            hasPreviousAnswers: widget.hasPreviousAnswers,
                          )),
                );
              },
            ),
            ListTile(
              title: Text('Map of PFT'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // Hide default app bar (toolbarHeight set to 0)
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          // Display the question and current objects found
          Container(
            color: const Color.fromARGB(255, 70, 29, 124),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center horizontally
              children: [
                Text(
                  ISpyPage.objectNames[widget.index],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 241, 238, 219),
                  ),
                  textAlign: TextAlign.center, // Center text within its box
                ),
                const SizedBox(height: 5),
                // Divider to indicate the page progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    ISpyPage.images.length,
                    (index) => Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index <= widget.index
                            ? Color.fromARGB(255, 253, 208, 35)
                            : Color.fromARGB(255, 208, 208, 208),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Game area with image and clickable target
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
                        fit: BoxFit.fill,
                      ),
                    ),
                    // Clickable target area
                    Positioned(
                      left: correctX,
                      top: correctY,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isClicked = true;
                          });
                          // Show a popup with the object's description
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                "Great Job!",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 86, 29, 124),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                ISpyPage.objectDescriptions[widget.index],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 86, 29, 124),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context); // Close the popup first
                                    setState(() {
                                      _isClicked = false;
                                    });
                                    int updatedObjectsFound =
                                        widget.objectsFound + 1;

                                    // If all objects are found, show final score
                                    if (updatedObjectsFound ==
                                        ISpyPage.images.length) {
                                      _showFinalScore(context);
                                    } else {
                                      // else, move to the next page
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ISpyPage(
                                            index: widget.index + 1,
                                            objectsFound: updatedObjectsFound,
                                            playerName: widget.playerName,
                                            hasPreviousAnswers:
                                                widget.hasPreviousAnswers,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    "Continue",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 86, 29, 124),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: _isClicked
                                  ? const Color.fromARGB(255, 253, 208, 35)
                                  : const Color.fromARGB(21, 88, 63, 88),
                              width: _isClicked ? 6 : 3,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),

                    // Restart button
                    Positioned(
                      top: 20,
                      right: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StartPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Restart',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 86, 29, 124),
                          ),
                        ),
                      ),
                    ),
                    if (widget.index > 0)
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: IconButton(
                          icon: Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // White background color inside the border
                              border: Border.all(
                                color: const Color.fromARGB(
                                    255, 253, 208, 35), // Yellow border color
                                width: 3, // Border width
                              ),
                              borderRadius: BorderRadius.circular(
                                  10), // Optional: rounded corners
                            ),
                            child: const Icon(Icons.arrow_back, size: 50),
                          ),
                          color: Color.fromARGB(255, 86, 29, 124),
                          onPressed: () {
                            if (widget.index > 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ISpyPage(
                                    index: widget.index - 1,
                                    objectsFound: widget.objectsFound,
                                    playerName: widget.playerName,
                                    hasPreviousAnswers:
                                        widget.hasPreviousAnswers,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    // Right arrow button
                    if (widget.index < ISpyPage.images.length - 1)
                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: IconButton(
                          icon: Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // White background color inside the border
                              border: Border.all(
                                color: const Color.fromARGB(
                                    255, 253, 208, 35), // Yellow border color
                                width: 3, // Border width
                              ),
                              borderRadius: BorderRadius.circular(
                                  10), // Optional: rounded corners
                            ),
                            child: const Icon(Icons.arrow_forward, size: 50),
                          ),
                          color: Color.fromARGB(255, 86, 29, 124),
                          onPressed: () {
                            if (widget.index < ISpyPage.images.length - 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ISpyPage(
                                    index: widget.index + 1,
                                    objectsFound: widget.objectsFound,
                                    playerName: widget.playerName,
                                    hasPreviousAnswers:
                                        widget.hasPreviousAnswers,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    Positioned(
                      left: 20,
                      top: 20,
                      child: IconButton(
                        icon: Container(
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // White background color inside the border
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 253, 208, 35), // Yellow border color
                              width: 3, // Border width
                            ),
                            borderRadius: BorderRadius.circular(
                                10), // Optional: rounded corners
                          ),
                          child: const Icon(Icons.menu, size: 50),
                        ),
                        color: Color.fromARGB(255, 86, 29, 124),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
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

  // Game Over dialog that updates the leaderboard with the current player's score
  void _showFinalScore(BuildContext context) {
    int score = widget.objectsFound;
    double percentage = (score / ISpyPage.images.length) * 100;
    int num = ISpyPage.images.length;

    LeaderboardData.addScore(widget.playerName, score);
    int rank = LeaderboardData.scores.indexWhere((player) =>
            player['name'] == widget.playerName && player['score'] == score) +
        1;

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
              'Player: ${widget.playerName}',
              style: const TextStyle(fontSize: 25),
            ),
            Text(
              'Objects Found: ${widget.objectsFound}',
              style: const TextStyle(fontSize: 25),
            ),
            Text(
              'Score: $score/$num',
              style: const TextStyle(fontSize: 25),
            ),
            Text(
              'Percentage: ${percentage.toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 25),
            ),
            Text(
              'Rank: #$rank',
              style: const TextStyle(fontSize: 25),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StartPage(),
                ),
              );
            },
            child: const Text(
              'Restart',
              style: TextStyle(fontSize: 20),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showLeaderboard(context);
            },
            child: const Text(
              'Show Leaderboard',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  // Leaderboard dialog shown from within the game (ISpyPage)
  void _showLeaderboard(BuildContext context) {
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
        content: LeaderboardData.scores.isEmpty
            ? const Text("No scores yet.", style: TextStyle(fontSize: 20))
            : SingleChildScrollView(
                child: Column(
                  children: LeaderboardData.scores.map((player) {
                    return Text(
                      '${player['name']} - ${player['score']} points',
                      style: const TextStyle(fontSize: 20),
                    );
                  }).toList(),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StartPage(),
                ),
              );
            },
            child: const Text(
              'Restart',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map of PFT'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'images/PFTMap.png',
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
