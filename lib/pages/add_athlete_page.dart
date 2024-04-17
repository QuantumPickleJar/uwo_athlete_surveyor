import 'package:flutter/material.dart'; 

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _sportController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your App Title'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Athlete Information',
                style: TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 20), 
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://via.placeholder.com/150', 
                  width: 150,
                  height: 150,
                ),
                const SizedBox(width: 16.0), 
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Name: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), 
                      Row(
                        children: [
                          const Text(
                            'Grade: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _gradeController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), 
                      Row(
                        children: [
                          const Text(
                            'Sport: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _sportController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), 
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add functionality to handle adding student
                },
                child: const Text('Add Student'),
              ),
            ),
            const SizedBox(height: 5), 
            Column(
              children: [
                const Text("Analytics of 'Student's name'"),
                Image.network(
                  'https://via.placeholder.com/400', 
                  width: 390,
                  height: 390,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
