import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/ranking_repository.dart';
import 'data/repositories/openai_repository.dart';
import 'data/repositories/mock_repository.dart';
import 'data/services/openai_service.dart';
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
      //create: (context) => OpenAIRepository(openAiService: OpenAIService()),
      child: BlocProvider(
        create: (context) => RankingBloc(
          rankingRepository: RepositoryProvider.of<RankingRepository>(context),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: SearchScreen(),
        ),
      ),
    );
  }
}
