import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ideally/models/idea.dart';
import 'package:ideally/pages/home_page_bloc.dart';
import 'package:provider/provider.dart';

class IdeaDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Idea>(
      builder: (context, idea, _) => Scaffold(
        appBar: AppBar(
          title: Text(idea.title),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(idea.subtitle, style: Theme.of(context).textTheme.subtitle),
              ),
              Expanded(
                child: ListView(
                  children: idea.comments?.map((c)  => _buildCommentWidget(c, context))?.toList() ??
                      [Center(child: Text('No comments :('))],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommentAdder(idea),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentWidget(String comment, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(comment, style: Theme.of(context).textTheme.body2),
    );
  }
}

class CommentAdder extends StatefulWidget {
  final Idea idea;

  const CommentAdder(this.idea);

  @override
  _CommentAdderState createState() => _CommentAdderState();
}

class _CommentAdderState extends State<CommentAdder> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Add Comment',
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            if (_controller.text.isEmpty) return;

            BlocProvider.of<IdeaListBloc>(context).dispatch(Comment(widget.idea, _controller.text));
            _controller.clear();
          },
          icon: Icon(Icons.insert_comment),
        )
      ],
    );
  }
}
