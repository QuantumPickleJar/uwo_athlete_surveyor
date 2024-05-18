import 'dart:js_interop';

import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/models/student_model.dart';
import 'package:athlete_surveyor/widgets/form_progress_widget.dart';
import 'package:flutter/material.dart';

/// Page for students to take the form and submit their responses.
class FormTakerPage extends StatefulWidget {
  final StudentModel studentModel;        /// holds the questions that the student will be responding to
  const FormTakerPage({Key? key, required this.studentModel}) : super(key: key);

  @override
  _FormTakerPageState createState() => _FormTakerPageState();
}

class _FormTakerPageState extends State<FormTakerPage> {
  int currentQuestionIndex = 0;

  /// Minifying method for accessing the current question's [questionId]
  String getCurrentQuestionId() { 
    return widget.studentModel.questions[currentQuestionIndex].questionId; 
  }

  /// Updates the answer for the current question in the [widget.studentModel.questions] list.
  /// After updating, triggers a state update to reflect the changes 
  void answerCurrentQuestion(dynamic answer) {
    setState(() {
      widget.studentModel.answerQuestion(getCurrentQuestionId(), answer);
    });
  }
  /// Go back a question (if we're not already at the first question)
  void previousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
      }
    });
  }

  /// Advance to the next question (if we're not already at the last question)
  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < widget.studentModel.questions.length - 1) {
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
              questions: widget.studentModel.questions,
              answeredQuestionIds: widget.studentModel.responses.keys.toSet(),
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
                  /// TODO: implement a `ResponseInputWidget` that handles UI + interaction of 
                  /// the question based on the [ResponseType]
                    onPressed: () { answerCurrentQuestion('TEST ANSWER'); },
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
