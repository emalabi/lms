class Courses {
  final String name;

  Courses({
    this.name,
  });
}

List<Courses> courses = List.generate(
  course_code.length,
  (index) => Courses(
    name: course_code[index],
  ),
);

final List course_code = [
  "CSIT 402",
  "CSIT 410",
  "CSIT 418",
  "CSIT 406",
  "CSIT 407",
  "CSIT 404",
];
