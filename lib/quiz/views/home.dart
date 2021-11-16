import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms/models/create_quiz.dart';
import 'package:lms/quiz/services/database.dart';
import 'package:lms/quiz/views/create_quiz.dart';
import 'package:lms/quiz/views/quiz_play.dart';
import 'package:lms/widget/widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream quizStream;

  DatabaseService databaseService = DatabaseService();

  List<CreateQuiz> _items = [];

  final columns = [
    'TITLE',
    'STATUS',
    'OPEN DATE',
    'DUE DATE',
  ];

  Widget quizList() {
    return Container(
      child: Column(
        children: [
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Quiz').snapshots(),
              builder: (context, snapshot) {
                List<CreateQuiz> data = snapshot.data as List<CreateQuiz>;

                if (!snapshot.hasData) return Container();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      sortColumnIndex: 0,
                      dataRowHeight: 80,
                      dataTextStyle: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                      columns: getColumns(columns),
                      rows:
                          // data
                          //     .map(
                          //       (country) => DataRow(
                          //         cells: [
                          //           DataCell(
                          //             Container(
                          //               width: 100,
                          //               child: Text(
                          //                 country.title,
                          //                 softWrap: true,
                          //                 overflow: TextOverflow.ellipsis,
                          //                 style: TextStyle(
                          //                     fontWeight: FontWeight.w600),
                          //               ),
                          //             ),
                          //           ),
                          //           DataCell(
                          //             Container(
                          //               width: 60.0,
                          //               child: Center(
                          //                 child: Text(
                          //                   country.status.toString(),
                          //                   style: TextStyle(
                          //                       fontWeight: FontWeight.bold),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //           DataCell(
                          //             Center(
                          //               child: Text(
                          //                 country.openDate.toString(),
                          //                 style: TextStyle(
                          //                     fontWeight: FontWeight.bold),
                          //               ),
                          //             ),
                          //           ),
                          //           DataCell(
                          //             Center(
                          //               child: Text(
                          //                 country.dueDate.toString(),
                          //                 style: TextStyle(
                          //                     fontWeight: FontWeight.bold),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     )
                          //     .toList(),

                          getRows(context, snapshot.data.docs),

                      // _items
                      //     .map((item) => _createRow(item))
                      //     .toList(),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizData().then((value) {
      quizStream = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppLogo(),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Quiz").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            return _buildList(context, snapshot.data.docs);
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuizz()));
        },
      ),
    );
  }

  // DataRow _createRow(CreateQuiz item) {
  //   return DataRow(
  //     // index: item.id, // for DataRow.byIndex
  //     //key: ValueKey(item.id),
  //     // selected: item.isSelected,
  //     // onSelectChanged: (bool isSelected) {
  //     //   if (isSelected != null) {
  //     //     item.isSelected = isSelected;
  //     //     setState(() {});
  //     //   }
  //     // },
  //     // color: MaterialStateColor.resolveWith((Set<MaterialState> states) =>
  //     //     states.contains(MaterialState.selected)
  //     //         ? Colors.red
  //     //         : Color.fromARGB(100, 215, 217, 219)),
  //     cells: [
  //       DataCell(
  //         Text(item.title),
  //         placeholder: false,
  //         showEditIcon: true,
  //         // onTap: () {
  //         //   Navigator.push(
  //         //       context,
  //         //       MaterialPageRoute(
  //         //           builder: (context) => QuizPlay(quizId: item.id)));
  //         // },
  //       ),
  //       DataCell(Text(item.status)),
  //       DataCell(
  //         Text(item.openDate.toIso8601String()),
  //       ),
  //       DataCell(Text(item.dueDate.toIso8601String())),
  //     ],
  //   );
  // }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    final columns = [
      'TITLE',
      'STATUS',
      'OPEN DATE',
      'DUE DATE',
    ];
    return ListView(
      children: [
        DataTable(
          columns: getColumns(columns),
          rows:
              //getRows(context, snapshot),
              snapshot.map((data) => _buildListItem(context, data)).toList(),
        ),
      ],
    );
  }

  List<DataRow> getRows(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<DataRow> newList = snapshot.map((document) {
      final quiz = CreateQuiz.fromSnapshot(document);
      if (quiz == null) {
        return Container();
      }
      return DataRow(cells: [
        DataCell(Text(quiz.title == null ? "title" : quiz.title)),
        DataCell(Text(quiz.status == null ? "title" : quiz.status)),
        DataCell(Text(quiz.openDate == null ? "title" : quiz.openDate)),
        DataCell(Text(quiz.dueDate == null ? "title" : quiz.dueDate)),
      ]);
    }).toList();
    return newList;
  }
}

_buildListItem(BuildContext context, DocumentSnapshot snapshot) {
  final quiz = CreateQuiz.fromSnapshot(snapshot);
  if (quiz == null) {
    return Container();
  }

  return DataRow(cells: [
    DataCell(Text(quiz.title == null ? "title" : quiz.title)),
    DataCell(Text(quiz.status == null ? "title" : quiz.status)),
    DataCell(Text(quiz.openDate == null ? "title" : quiz.openDate)),
    DataCell(Text(quiz.dueDate == null ? "title" : quiz.dueDate)),
    // DataCell(Text(document['status'])),
    // DataCell(Text(document.get('dueDate'))),
  ]);
}

List<DataColumn> getColumns(List<String> columns) => columns
    .map((String column) => DataColumn(
          label: Text(column),
        ))
    .toList();

class QuizTile extends StatelessWidget {
  final String imageUrl, title, id, description;
  final int noOfQuestions;

  QuizTile(
      {@required this.title,
      @required this.imageUrl,
      @required this.description,
      @required this.id,
      @required this.noOfQuestions});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => QuizPlay(quizId: id)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                color: Colors.black26,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
