import 'package:flutter/material.dart';

class Idea with ChangeNotifier {
  String title;
  String subtitle;
  int votes;
  List<String> comments;

  Idea({
    this.title,
    this.subtitle,
    this.votes = 0,
    this.comments,
  });

  factory Idea.fromJson(Map<String, dynamic> json) {
    return Idea(
      title: json['title'],
      subtitle: json['subtitle'],
      votes: json['votes'] ?? 0,
      comments: json['comments'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title ?? '',
      'subtitle': subtitle ?? '',
      'votes': votes ?? 0,
      'comments': comments ?? <String>[],
    };
  }

  void addComment(String comment) {
    comments.add(comment);
    notifyListeners();
  }

  void upvote() {
    votes++;
    notifyListeners();
  }
}
