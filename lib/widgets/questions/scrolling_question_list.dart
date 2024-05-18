import 'package:athlete_surveyor/models/question.dart';
import 'package:flutter/material.dart';
    
class ScrollingQuestionList extends StatelessWidget {
  final List<Question> questions;
  final Set<String> answeredQuestionIds;
  final int currentIndex;
  final ValueChanged<int> onQuestionSelected;

  const ScrollingQuestionList({
    Key? key,
    required this.questions,
    required this.answeredQuestionIds,
    required this.currentIndex,
    required this.onQuestionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(2, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Questions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const Divider(height: 1, thickness: 2),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(questions[index].header,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: currentIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: answeredQuestionIds.contains(index)
                              ? Colors.grey
                              : Colors.black,
                          decoration: answeredQuestionIds.contains(index)
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      tileColor: currentIndex == index
                          ? Colors.black12
                          : Colors.transparent,
                      onTap: () {
                        onQuestionSelected(index);
                      },
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