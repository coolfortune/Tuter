class Tutor {

  String firstName;
  String lastName;
  String email;
  String major;
  List<String> schedule;
  bool verified = false;
  int positiveRatings = 0;
  int totalRatings = 0;

  Tutor({ this.firstName, this.lastName, this.email, this.major, this.schedule });

  Tutor.fromProfile(String email, String firstName, String lastName, String major, int positiveRatings, int totalRatings, bool verified)
 {
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.major = major;
    this.positiveRatings = positiveRatings;
    this.totalRatings = totalRatings;
    this.verified = verified;
  }

}