import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ideally/pages/home_page.dart';
import 'package:ideally/pages/home_page_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<IdeaListBloc>(
      builder: (_) => IdeaListBloc()..dispatch(FetchIdeaList()),
      child: MaterialApp(
        title: 'Ideal.ly',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.deepPurple,
          accentColor: Colors.yellowAccent,
          primaryColorBrightness: Brightness.dark,
          accentColorBrightness: Brightness.light,
          appBarTheme: AppBarTheme(
            textTheme: TextTheme(title: TextStyle(fontFamily: 'Josefin', fontSize: 28))
          ),
          textTheme: TextTheme(
            title: TextStyle(
              fontFamily: 'Josefin',
              fontSize: 28,
            ),
            subhead: TextStyle(
              fontFamily: 'Josefin',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            subtitle: TextStyle(
              fontFamily: 'monospace',
            ),
            button: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Josefin',
            ),
            body2: TextStyle(
              fontFamily: 'serif',
            )
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}