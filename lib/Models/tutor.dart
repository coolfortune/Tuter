class Tutor {

  final String firstName;
  final String lastName;
  final String email;
  final String major;
  final List<String> schedule;
  bool verified = false;
  int positiveRatings = 0;
  int totalRatings = 0;

  Tutor({ this.firstName, this.lastName, this.email, this.major, this.schedule });

}