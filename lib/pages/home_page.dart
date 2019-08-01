import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ideally/models/idea.dart';
import 'package:ideally/pages/home_page_bloc.dart';
import 'package:ideally/pages/idea_detail_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ideal.ly'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: IdeaList(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.yellowAccent,
        onPressed: () async {
          final name = await showDialog<String>(
            context: context,
            builder: (context) => PromptDialog('Idea Name'),
          );
          if (name == null || name.isEmpty) return;
          final subtitle = await showDialog<String>(
              context: context, builder: (context) => PromptDialog('Idea Tagline'));
          if (subtitle == null) return;
          BlocProvider.of<IdeaListBloc>(context).dispatch(AddIdea(name, subtitle));
        },
        label: Text('Add Idea', style: Theme.of(context).textTheme.button),
        icon: Icon(Icons.add),
      ),
    );
  }
}

class IdeaList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<IdeaListBloc>(context),
      builder: (context, IdeaListState state) {
        if (state is Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is Fetched) {
          if (state.ideas.isEmpty) {
            return Center(
              child: const Text('No ideas found :('),
            );
          }
          return ListView(
            children: (state.ideas..sort((first, second) => -first.votes.compareTo(second.votes)))
                .map((idea) => _buildIdeaListItem(idea, context))
                .toList(),
          );
        }

        return Container();
      },
    );
  }

  Widget _buildIdeaListItem(Idea idea, BuildContext context) {
    return ListTile(
      leading: InkWell(
        onTap: () {
          BlocProvider.of<IdeaListBloc>(context).dispatch(Upvote(idea));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(idea.votes.toString()),
        ),
      ),
      title: Text(idea.title, style: Theme.of(context).textTheme.subhead),
      subtitle: Text(idea.subtitle, style: Theme.of(context).textTheme.subtitle),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (ctx) => ChangeNotifierProvider.value(value: idea, child: IdeaDetailPage())),
        );
      },
    );
  }
}

class PromptDialog extends StatefulWidget {
  final String prompt;

  PromptDialog(this.prompt);

  @override
  _PromptDialogState createState() => _PromptDialogState();
}

class _PromptDialogState extends State<PromptDialog> {
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
    return AlertDialog(
      title: Text(widget.prompt),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text('Next'),
          onPressed: () {
            Navigator.of(context).pop(_controller.text);
          },
        )
      ],
    );
  }
}
