class NoticeModel {
  String notice;
  String? url;
  String date;
  String publishedBy;
  NoticeModel({
    required this.notice,
    this.url,
    required this.date,
    required this.publishedBy,
  });
}
