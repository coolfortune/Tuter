class Student {

  String firstName;
  String lastName;
  String email;
  String major;
  List<String> schedule;
  int positiveRatings = 0;
  int totalRatings = 0;

  Student({ this.firstName, this.lastName, this.email, this.major, this.schedule});
  Student.fromProfile(String email, String firstName, String lastName, String major, int positiveRatings, int totalRatings)
  {
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.major = major;
    this.positiveRatings = positiveRatings;
    this.totalRatings = totalRatings;
  }

}