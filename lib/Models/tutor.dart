class Tutor {
  String userID;
  final String firstName;
  final String lastName;
  final String email;
  final String major;
  final List<String> schedule;
  bool verified = false;
  int positiveRatings = 0;
  int totalRatings = 0;

  Tutor({ this.userID, this.firstName, this.lastName, this.email, this.major, this.schedule });

  factory Tutor.fromJson(Map<String, dynamic> item) {
    return Tutor(
      userID: item['userID'],
      firstName: item['firstName'],
      lastName: item['lastName'],
      email: item['email'],
      major: item['major'],
      schedule: item['schedule'],
    );
  }

}