import 'dart:async';
import 'package:adv_basics/data/questions.dart';
import 'package:flutter/material.dart';
import 'package:adv_basics/answer_button.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key, required this.onSelectAnswer});

  final void Function(String answer) onSelectAnswer;

  @override
  State<QuestionsScreen> createState() {
    return _QuestionsScreenState();
  }
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  var currentQuestionIndex = 0;
  Timer? _timer;
  int _remainingTime = 30;
  late List<String> shuffledAnswers; 

  @override
  void initState() {
    super.initState();
    _loadQuestion(); 
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); 
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel(); 
    _remainingTime = 15; 

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--; 
        });
      } else {
        _moveToNextQuestion(); 
      }
    });
  }

  void _moveToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        _loadQuestion(); 
      });
      _startTimer(); 
    } else {
      _timer?.cancel(); 
    }
  }

  void _loadQuestion() {
    final currentQuestion = questions[currentQuestionIndex];
    shuffledAnswers = currentQuestion.getShuffleAnswers();
  }

  void answerQuestion(String selectedAnswer) {
    widget.onSelectAnswer(selectedAnswer);
    _moveToNextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

    final backgroundColor = Theme.of(context).colorScheme.onSurface;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return SizedBox(
      width: double.infinity,
      child: Container(
        color: backgroundColor,
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.text,
              style: GoogleFonts.lato(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Text(
              'Time remaining: $_remainingTime seconds',
              style: GoogleFonts.lato(
                fontSize: 20, 
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...shuffledAnswers.map((answer) {
              return AnswerButton(
                answerText: answer,
                onTap: () {
                  answerQuestion(answer);
                },
              );
            })
          ],
        ),
      ),
    );
  }
}
