
/*Author - Joshua*/


import 'package:athlete_surveyor/styles/colors.dart';
import 'package:flutter/material.dart';

const Divider listviewDivider = Divider(
  thickness: 2.0,
  color: titanYellow);

class IndividualFormWidget extends StatefulWidget
{
  final String appBarTitle;
  final String sportName;
  const IndividualFormWidget(this.appBarTitle, this.sportName, {super.key});

  @override
  State<StatefulWidget> createState() => _IndividualFormWidgetState();
}

class _IndividualFormWidgetState extends State<IndividualFormWidget>
{
  List<String> questionList = [
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua?",
    "Phasellus egestas tellus rutrum tellus pellentesque eu tincidunt?",
    "Donec adipiscing tristique risus nec feugiat in fermentum posuere urna?",
    "Velit euismod in pellentesque massa placerat duis ultricies lacus?",
    "Pellentesque habitant morbi tristique senectus et netus et?",
    "Id venenatis a condimentum vitae sapien pellentesque habitant morbi tristique?",
    "Sit amet facilisis magna etiam tempor orci?",
    "Egestas tellus rutrum tellus pellentesque eu tincidunt tortor aliquam?",
    "Id semper risus in hendrerit gravida rutrum quisque non?",
    "Auctor augue mauris augue neque gravida in fermentum?"
  ];
  List<String> answerList = [
    "Facilisi etiam dignissim diam quis enim lobortis scelerisque.",
    "Tortor posuere ac ut consequat semper viverra nam libero justo.",
    "Sit amet tellus cras adipiscing enim eu turpis.",
    "Ut eu sem integer vitae justo eget magna.",
    "Neque egestas congue quisque egestas diam in arcu cursus.",
    "Nisl vel pretium lectus quam id.",
    "Volutpat commodo sed egestas egestas fringilla phasellus faucibus scelerisque.",
    "Donec ac odio tempor orci dapibus.",
    "Diam phasellus vestibulum lorem sed risus.",
    "Viverra aliquet eget sit amet tellus cras adipiscing."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        centerTitle: true,
        backgroundColor: titanYellow,
        leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(icon: const Icon(Icons.arrow_back_outlined, color: Colors.black), onPressed:(){ Navigator.pop(context); }),
          ),),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("~ ${widget.sportName} ~", style: const TextStyle(fontSize: 20.0),),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: questionList.length,
                separatorBuilder: (BuildContext context, int index) => listviewDivider,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Text("${index+1}."),
                    title: Text("Q: ${questionList[index]}"),
                    subtitle: Text("A: ${answerList[index]}")
                  );
                },
              ))
          ],
        ),
    );
  }
}