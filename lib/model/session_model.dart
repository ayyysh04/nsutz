class Session {
  String? cookie;
  String? hrand;
  String? rollNo;
  String? password;
  String? registration;
  String? dashboard;
  String? activities;
  String? plumUrl;
  String? logout;

  Session(
      {this.cookie,
      this.registration,
      this.dashboard,
      this.activities,
      this.logout,
      this.hrand,
      this.plumUrl,
      this.password,
      this.rollNo});
}
