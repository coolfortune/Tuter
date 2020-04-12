class Student {
  String userID;
  final String firstName;
  final String lastName;
  final String email;
  final String major;
  final List<String> schedule;
  int positiveRatings = 0;
  int totalRatings = 0;

  Student({this.userID, this.firstName, this.lastName, this.email, this.major, this.schedule});


  factory Student.fromJson(Map<String, dynamic> item) {
    return Student(
      userID: item['userID'],
      firstName: item['firstName'],
      lastName: item['lastName'],
      email: item['email'],
      major: item['major'],
      schedule: item['schedule'],
    );
  }
}