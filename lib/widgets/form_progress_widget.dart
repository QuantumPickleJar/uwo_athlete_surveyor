import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/widgets/questions/scrolling_question_list.dart';
import 'package:flutter/material.dart';

/// A stateful widget that represents the form progress widget.
/// It displays a list of questions and a progress indicator showing the completion percentage.
class FormProgressWidget extends StatefulWidget {
  final List<Question> questions;
  final Set<String> answeredQuestionIds;
  final int currentQuestionIndex;
  /// Reference to the [ChangeNotifier] that's called on response submission
  final ValueChanged<int> onQuestionSelected;

  const FormProgressWidget({
    Key? key,
    required this.questions,
    required this.answeredQuestionIds,
    required this.currentQuestionIndex,
    required this.onQuestionSelected,
  }) : super(key: key);

  @override
  _FormProgressWidgetState createState() => _FormProgressWidgetState();
}

class _FormProgressWidgetState extends State<FormProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // _buildQuestionList(),
                ScrollingQuestionList(
                  questions: widget.questions, 
                  answeredQuestionIds: widget.answeredQuestionIds,
                  currentIndex: widget.currentQuestionIndex, 
                  onQuestionSelected: widget.onQuestionSelected),
                SizedBox(width: 16.0),
                _buildProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // /// Builds the list of questions.
  // Widget _buildQuestionList() {
  //   return Expanded(
  //     flex: 2,
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(0.5),
  //             spreadRadius: 1,
  //             blurRadius: 2,
  //             offset: const Offset(2, 2), // changes position of shadow
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Padding(
  //             padding: EdgeInsets.all(8.0),
  //             child: Text(
  //               'Questions',
  //               style: TextStyle(
  //                 fontSize: 24,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.blue,
  //               ),
  //             ),
  //           ),
  //           const Divider(height: 1, thickness: 2),
  //           Expanded(
  //             child: ListView.builder(
  //               padding: const EdgeInsets.all(8.0),
  //               itemCount: widget.questions.length,
  //               itemBuilder: (context, index) {
  //                 return Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 4.0),
  //                   child: ListTile(
  //                     title: Text(widget.questions[index].header,
  //                       style: TextStyle(
  //                         fontSize: 18,
  //                         fontWeight: widget.currentQuestionIndex == index
  //                             ? FontWeight.bold
  //                             : FontWeight.normal,
  //                         color: widget.answeredQuestionIds.contains(index)
  //                             ? Colors.grey
  //                             : Colors.black,
  //                         decoration: widget.answeredQuestionIds.contains(index)
  //                             ? TextDecoration.lineThrough
  //                             : TextDecoration.none,
  //                       ),
  //                     ),
  //                     tileColor: widget.currentQuestionIndex == index
  //                         ? Colors.black12
  //                         : Colors.transparent,
  //                     onTap: () {
  //                       widget.onQuestionSelected(index);
  //                     },
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  /// Builds the progress indicator.
  Widget _buildProgressIndicator() {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: widget.answeredQuestionIds.length / widget.questions.length,
                  strokeWidth: 10,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${((widget.answeredQuestionIds.length / widget.questions.length) * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Progress',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
