import '../models/ranking_item.dart';

class MockRepository {
  // Simulated method to fetch mock ranking data
  static List<RankingItem> getMockRanking() {
    return [
      RankingItem(
        position: 1,
        title: "The Lean Startup",
        description:
            "Eric Ries explica cómo las empresas modernas utilizan la validación continua para crear productos exitosos en condiciones de extrema incertidumbre.",
        rating: 4.9,
        imageUrl:
            "https://images-na.ssl-images-amazon.com/images/I/81-QB7nDh4L.jpg",
        location: "Silicon Valley, USA",
      ),
      RankingItem(
        position: 2,
        title: "Zero to One",
        description:
            "Peter Thiel, cofundador de PayPal, detalla cómo construir empresas que creen cosas totalmente nuevas en lugar de copiar lo que ya existe.",
        rating: 4.7,
        imageUrl:
            "https://images-na.ssl-images-amazon.com/images/I/71mKvD897vL.jpg",
        location: "Stanford, USA",
      ),
      RankingItem(
        position: 3,
        title: "The E-Myth Revisited",
        description:
            "Michael E. Gerber desarma los mitos sobre la creación de un negocio y demuestra cómo los métodos sistemáticos pueden asegurar el éxito.",
        rating: 4.5,
        imageUrl:
            "https://images-na.ssl-images-amazon.com/images/I/71u9GvS-k6L.jpg",
        location: "Mega-bestseller Mundial",
      ),
    ];
  }
}
