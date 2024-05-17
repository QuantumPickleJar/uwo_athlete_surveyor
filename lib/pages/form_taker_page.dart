import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/widgets/form_progress_widget.dart';
import 'package:flutter/material.dart';

/// Page for students to take the form and submit their responses.
class FormTakerPage extends StatefulWidget {
  // should this be a StudentForm, or a reference to something like that?
  final List<Question> questions;

  const FormTakerPage({Key? key, required this.questions}) : super(key: key);

  @override
  _FormTakerPageState createState() => _FormTakerPageState();
}

class _FormTakerPageState extends State<FormTakerPage> {
  int currentQuestionIndex = 0;
  Set<int> answeredQuestions = {};

  void answerCurrentQuestion() {
    setState(() {
      answeredQuestions.add(currentQuestionIndex);
    });
  }

  void previousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < widget.questions.length - 1) {
        currentQuestionIndex++;
      }
    });
  }

  void onQuestionSelected(int index) {
    setState(() {
      currentQuestionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FormProgressWidget(
              questions: widget.questions,
              answeredQuestions: answeredQuestions,
              currentQuestionIndex: currentQuestionIndex,
              onQuestionSelected: onQuestionSelected,
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.extended(
                  onPressed: previousQuestion,
                  label: const Text('<< Prev'),
                ),
                ElevatedButton(
                  onPressed: answerCurrentQuestion,
                  child: const Text('Answer Current Question'),
                ),
                FloatingActionButton.extended(
                  onPressed: nextQuestion,
                  label: const Text('Next >>'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
