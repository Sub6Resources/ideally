import 'dart:convert';

import 'package:ideally/models/idea.dart';
import 'package:ideally/repository/ideal_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdealSharedPrefRepository implements IdealRepository {
  List<Idea> _ideas;

  @override
  Future<void> addCommentToIdea(Idea idea, String comment) async {
    if(idea.comments == null) {
      idea.comments = List<String>();
    }
    idea.addComment(comment);
    await _save();
  }

  @override
  Future<void> createIdea(Idea idea) async {
    if (_ideas == null) await _load();
    _ideas.add(idea);
    await _save();
  }

  @override
  Future<List<Idea>> getIdeas() async {
    if (_ideas == null) await _load();
    return _ideas;
  }

  @override
  Future<void> upvoteIdea(Idea idea) async {
    if (idea.votes == null) idea.votes = 0;
    idea.upvote();
    await _save();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _ideas = prefs.getStringList('ideas')?.map((idea) {
      return Idea.fromJson(json.decode(idea));
    })?.toList() ?? <Idea>[];
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('ideas', _ideas?.map((idea) => json.encode(idea.toJson()))?.toList());
  }

}