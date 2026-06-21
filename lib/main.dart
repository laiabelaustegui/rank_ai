import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/ranking_repository.dart';
import 'data/repositories/mock_repository.dart';
import 'ui/blocs/ranking/ranking_bloc.dart';
import 'ui/screens/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<RankingRepository>(
      create: (context) => MockRepository(),
      child: BlocProvider(
        create: (context) => RankingBloc(
          rankingRepository: RepositoryProvider.of<RankingRepository>(context),
        ),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SearchScreen(),
        ),
      ),
    );
  }
}
