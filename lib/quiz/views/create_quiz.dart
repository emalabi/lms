import 'package:flutter/material.dart';
import 'package:lms/quiz/services/database.dart';
import 'package:lms/widget/widget.dart';
import 'package:random_string/random_string.dart';
import 'package:lms/models/create_quiz.dart';

import 'add_question.dart';

class CreateQuizz extends StatefulWidget {
  @override
  _CreateQuizzState createState() => _CreateQuizzState();
}

class _CreateQuizzState extends State<CreateQuizz> {
  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();

  String title, status, dueDate, openDate;
  // CreateQuiz quiz;

  bool isLoading = false;
  String quizId;

  createQuiz() {
    quizId = randomAlphaNumeric(16);
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> quizData = {
        "title": title,
        "status": status,
        "dueDate": dueDate,
        "openDate": openDate,
        //"quizId": quizId,
      };

      databaseService.addQuizData(quizData, quizId).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AddQuestion(quizId)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black54,
        ),
        title: AppLogo(),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter Quiz Title" : null,
                decoration: InputDecoration(hintText: "Quiz Title"),
                onChanged: (val) {
                  title = val;
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter Quiz Image Url" : null,
                decoration: InputDecoration(hintText: "Quiz Status"),
                onChanged: (val) {
                  status = val;
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter Quiz open date" : null,
                decoration: InputDecoration(hintText: "Quiz open date"),
                onChanged: (val) {
                  openDate = val;
                },
              ),
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter Quiz due date" : null,
                decoration: InputDecoration(hintText: "Quiz due date"),
                onChanged: (val) {
                  dueDate = val;
                },
              ),
              SizedBox(
                height: 5,
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  createQuiz();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Create Quiz",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
