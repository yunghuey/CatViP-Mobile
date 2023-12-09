class MentionedCat {

  MentionedCat({
    required this.catId,
    required this.catName,
  });

  int? catId;
  String? catName;

  factory MentionedCat.fromJson(Map<String, dynamic> json) {
    return MentionedCat(
      catId: json["catId"],
      catName: json["catName"],
    );
  }

}