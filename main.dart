import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

void main() {
  runApp(const QuizzicalApp());
}

class QuizzicalApp extends StatelessWidget {
  const QuizzicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizzical',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1ABC9C),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: const Color(0xFF2C3E50),
                displayColor: const Color(0xFF2C3E50),
              ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1ABC9C)),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}

// -------------------- SPLASH PAGE --------------------
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  final String splashUrl =
      "https://cdn-icons-png.flaticon.com/512/4519/4519678.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(splashUrl, height: 220, fit: BoxFit.contain),
                    const SizedBox(height: 24),
                    const Text(
                      'Quizzical',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('Sadia Amreen Lajj',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xff666262))),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1ABC9C),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const CategoryPage()),
                    );
                  },
                  child: const Text('GET STARTED',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- CATEGORY PAGE --------------------
class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List categories = [];
  bool loading = true;

  final Map<int, String> imageUrls = {
    9: "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
    17: "https://cdn-icons-png.flaticon.com/512/4151/4151022.png",
    23: "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
    18: "https://cdn-icons-png.flaticon.com/512/4333/4333609.png",
  };

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final res =
        await http.get(Uri.parse('https://opentdb.com/api_category.php'));
    if (res.statusCode == 200) {
      setState(() {
        categories = json.decode(res.body)['trivia_categories'];
        loading = false;
      });
    }
  }

  String getImageForCategory(int id) {
    return imageUrls[id] ??
        "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizzical', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1ABC9C), Color(0xFF16A085)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SplashPage()),
            );
          },
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Choose a category',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ConfigPage(
                                  categoryId: cat['id'],
                                  categoryName: cat['name'],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      getImageForCategory(cat['id']),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(cat['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  const Text('Tap to select',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// -------------------- CONFIG PAGE --------------------
class ConfigPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  const ConfigPage(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  int amount = 5;
  String difficulty = 'easy';
  String questionType = 'multiple';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Quiz', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1ABC9C), Color(0xFF16A085)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Text(widget.categoryName,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Text('Number of Questions')),
                        DropdownButton<int>(
                          value: amount,
                          items: [5, 10, 15, 20]
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e.toString())))
                              .toList(),
                          onChanged: (v) => setState(() => amount = v ?? 5),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Expanded(child: Text('Difficulty')),
                        DropdownButton<String>(
                          value: difficulty,
                          items: ['easy', 'medium', 'hard']
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => difficulty = v ?? 'easy'),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Expanded(child: Text('Question Type')),
                        DropdownButton<String>(
                          value: questionType,
                          items: const [
                            DropdownMenuItem(
                                value: 'multiple',
                                child: Text('Multiple Choice')),
                            DropdownMenuItem(
                                value: 'boolean', child: Text('True / False')),
                          ],
                          onChanged: (v) =>
                              setState(() => questionType = v ?? 'multiple'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1ABC9C),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizPage(
                                categoryId: widget.categoryId,
                                amount: amount,
                                difficulty: difficulty,
                                type: questionType,
                              ),
                            ),
                          );
                        },
                        child: const Text('START',
                            style: TextStyle(color: Colors.white)),
                      ),
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

// -------------------- QUIZ PAGE --------------------
class QuizPage extends StatefulWidget {
  final int categoryId;
  final int amount;
  final String difficulty;
  final String type;
  const QuizPage(
      {super.key,
      required this.categoryId,
      required this.amount,
      required this.difficulty,
      required this.type});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final HtmlUnescape unescape = HtmlUnescape();
  List questions = [];
  bool loading = true;
  int index = 0;
  int score = 0;
  String? selected;
  List<String> options = [];
  String? correctAnswer;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final url =
        'https://opentdb.com/api.php?amount=${widget.amount}&category=${widget.categoryId}&difficulty=${widget.difficulty}&type=${widget.type}';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      setState(() {
        questions = json.decode(res.body)['results'];
        loading = false;
      });
      prepareOptions();
    }
  }

  void prepareOptions() {
    if (questions.isEmpty) return;
    final q = questions[index];
    final wrong = List<String>.from(
        q['incorrect_answers'].map((a) => unescape.convert(a.toString())));
    final correct = unescape.convert(q['correct_answer'].toString());
    correctAnswer = correct;
    options = [...wrong, correct]..shuffle(Random());
  }

  void selectOption(String opt) {
    if (selected != null) return;
    setState(() => selected = opt);
    if (opt == correctAnswer) score++;
  }

  void goToNextQuestion() {
    if (index < questions.length - 1) {
      setState(() {
        index++;
        selected = null;
      });
      prepareOptions();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(score: score, total: questions.length),
        ),
      );
    }
  }

  Color getButtonColor(String opt) {
    if (selected == null) return Colors.white;
    if (opt == correctAnswer) return const Color(0xFF2ECC71);
    if (opt == selected) return const Color(0xFFE74C3C);
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1ABC9C), Color(0xFF16A085)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Question ${index + 1}/${questions.length}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unescape.convert(questions[index]['question'].toString()),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 18),
                  ...options.map((opt) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: getButtonColor(opt),
                          foregroundColor:
                              (selected != null && opt == correctAnswer)
                                  ? Colors.white
                                  : Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => selectOption(opt),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(opt,
                                style: const TextStyle(fontSize: 16))),
                      ),
                    );
                  }).toList(),
                  if (selected != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1ABC9C),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: goToNextQuestion,
                        child: const Text('NEXT',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

// -------------------- RESULT PAGE --------------------
class ResultPage extends StatelessWidget {
  final int score;
  final int total;
  const ResultPage({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    final percent = ((score / total) * 100).round();
    final passed = percent >= 60;
    final imageUrl = passed
        ? "https://cdn-icons-png.flaticon.com/512/616/616408.png"
        : "https://cdn-icons-png.flaticon.com/512/463/463612.png";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1ABC9C), Color(0xFF16A085)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CategoryPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.network(imageUrl, height: 180),
            const SizedBox(height: 20),
            Text(passed ? '🎉 Congratulations!' : '💪 Keep Trying!',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('$percent%',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: passed
                        ? const Color(0xFF2ECC71)
                        : const Color(0xFFE74C3C))),
            const SizedBox(height: 16),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1ABC9C),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoryPage()),
                    (route) => false,
                  );
                },
                child: const Text('PLAY AGAIN',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
