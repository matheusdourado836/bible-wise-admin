class Comentario {
  String? reportId;
  String? commentId;
  String? devocionalId;
  String? reportReason;
  String? comment;
  String? reportText;
  String? autor;
  String? createdAt;

  Comentario(
      { this.reportId,
        required this.devocionalId,
        required this.comment,
        required this.reportReason,
        required this.reportText,
        required this.autor,
        required this.commentId,
        required this.createdAt,
      });

  factory Comentario.fromJson(Map<String, dynamic> json) => Comentario(
    reportId: json["reportId"],
    commentId: json["commentId"],
    devocionalId: json["devocionalId"],
    reportReason: json["reportReason"],
    comment: json["comment"],
    autor: json["name"],
    reportText: json["text"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["reportId"] = reportId;
    data["commentId"] = commentId;
    data["devocionalId"] = devocionalId;
    data["reportReason"] = reportReason;
    data["comment"] = comment;
    data["autor"] = autor;
    data["text"] = reportText;
    data["createdAt"] = createdAt;

    return data;
  }
}