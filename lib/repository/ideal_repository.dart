
import 'package:ideally/models/idea.dart';
import 'package:ideally/repository/shared_pref/ideal_sharedpref_repository.dart';

final idealRepository = IdealSharedPrefRepository();

abstract class IdealRepository {
  Future<void> createIdea(Idea idea);
  Future<List<Idea>> getIdeas();
  Future<void> upvoteIdea(Idea idea);
  Future<void> addCommentToIdea(Idea idea, String comment);
}