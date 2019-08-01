import 'package:bloc/bloc.dart';
import 'package:ideally/models/idea.dart';
import 'package:ideally/repository/ideal_repository.dart';

class IdeaListBloc extends Bloc<IdeaListEvent, IdeaListState> {
  List<Idea> _ideaList;

  @override
  get initialState => Loading();

  @override
  Stream<IdeaListState> mapEventToState(event) async* {
    if (event is Upvote) {
      await idealRepository.upvoteIdea(event.idea);
    }

    if (event is Comment) {
      await idealRepository.addCommentToIdea(event.idea, event.comment);
    }

    if (event is AddIdea) {
      await idealRepository.createIdea(Idea(
        title: event.title,
        subtitle: event.subtitle,
      ));
    }

    _ideaList = await idealRepository.getIdeas();

    yield Fetched(_ideaList);
  }
}

//Events
abstract class IdeaListEvent {}

class FetchIdeaList extends IdeaListEvent {}

class Upvote extends IdeaListEvent {
  final Idea idea;

  Upvote(this.idea);
}

class Comment extends IdeaListEvent {
  final Idea idea;
  final String comment;

  Comment(this.idea, this.comment);
}

class AddIdea extends IdeaListEvent {
  final String title;
  final String subtitle;

  AddIdea(this.title, this.subtitle);
}

//States
abstract class IdeaListState {}

class Loading extends IdeaListState {}

class Fetched extends IdeaListState {
  final List<Idea> ideas;

  Fetched(this.ideas);
}
