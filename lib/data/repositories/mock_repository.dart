import '../models/ranking_item.dart';
import 'ranking_repository.dart';

class MockRepository implements RankingRepository {
  @override
  Future<List<RankingItem>> getRanking(String query) async {
    // Simulamos un retraso de red de 1.5 segundos para probar el spinner de carga
    await Future.delayed(const Duration(milliseconds: 1500));

    return [
      RankingItem(
        position: 1,
        title: "The Lean Startup",
        description:
            "Eric Ries explica cómo las empresas modernas utilizan la validación continua...",
        rating: 4.9,
        imageUrl:
            "https://images-na.ssl-images-amazon.com/images/I/81-QB7nDh4L.jpg",
        location: "Silicon Valley, USA",
      ),
      RankingItem(
        position: 2,
        title: "Zero to One",
        description:
            "Peter Thiel detalla cómo construir empresas que creen cosas totalmente nuevas...",
        rating: 4.7,
        imageUrl:
            "https://images-na.ssl-images-amazon.com/images/I/71mKvD897vL.jpg",
        location: "Stanford, USA",
      ),
    ];
  }
}
