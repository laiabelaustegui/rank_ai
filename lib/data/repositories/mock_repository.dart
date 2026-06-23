import '../models/ranking_item.dart';
import 'ranking_repository.dart';

class MockRepository implements RankingRepository {
  @override
  Future<List<RankingItem>> getRanking(String query) async {
    // Simulate a network delay of 1.5 seconds to test the loading spinner
    await Future.delayed(const Duration(milliseconds: 1500));

    return [
      RankingItem(
        position: 1,
        title: "The Lean Startup",
        subtitle: "Eric Ries",
        description:
            "Eric Ries explains how modern companies use continuous validation, scientific experimentation, and validated learning to shorten product development cycles and measure progress without vanity metrics.",
        rating: 4.9,
        imageUrl:
            "https://images-na.ssl-images-amazon.com/images/I/81-QB7nDh4L.jpg",
        location: "Silicon Valley, USA",
        tags: ["Bestseller", "Agile Methodology", "Business"],
        keyStats: {
          "Year": "2011",
          "Pages": "320",
          "Language": "English / Spanish",
        },
        rankingCriteria: [
          PositionCriterion(
            name: "Industry Impact",
            reason:
                "Completely reshaped how startups are created and managed on a global scale.",
          ),
          PositionCriterion(
            name: "Practical Applicability",
            reason:
                "The 'Build-Measure-Learn' framework is immediately actionable for any entrepreneur.",
          ),
        ],
      ),
      RankingItem(
        position: 2,
        title: "Zero to One",
        subtitle: "Peter Thiel",
        description:
            "Peter Thiel details how to build companies that create entirely new things. He offers an optimistic look at the future of progress and a new way of thinking about innovation: it starts by learning to ask the questions that lead you to find value in unexpected places.",
        rating: 4.7,
        imageUrl:
            "https://images-na.ssl-images-amazon.com/images/I/71mKvD897vL.jpg",
        location: "Stanford, USA",
        tags: ["Innovation", "Philosophy", "Monopolies"],
        keyStats: {"Year": "2014", "Pages": "224", "Language": "English"},
        rankingCriteria: [
          PositionCriterion(
            name: "Originality of Approach",
            reason:
                "Challenges conventional wisdom about competition and advocates for creating creative monopolies.",
          ),
          PositionCriterion(
            name: "Conceptual Clarity",
            reason:
                "Brief, concise, and straight to the point on how to go from 0 to 1 instead of copying from 1 to n.",
          ),
        ],
      ),
    ];
  }
}
