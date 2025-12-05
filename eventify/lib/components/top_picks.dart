class TopPicks {
  DateTime? date;
  String? nameOfevent;
  String? location;
  String? pathToImg;
  String? publisher;
  bool isFree;
  String category;

  TopPicks(
    this.date,
    this.nameOfevent,
    this.pathToImg,
    this.location,
    this.publisher,
    this.isFree,
    this.category,
  );
}

List<TopPicks> topPicks = [
  TopPicks(
    DateTime(2025, 1, 11),
    "Event 1",
    "lib/assets/event4.jpg",
    "ENSIA, Algiers",
    "Publisher",
    true,
    "Technology",
  ),
  TopPicks(
    DateTime(2025, 1, 11),
    "Event 2",
    "lib/assets/event2.webp",
    "ENSIA, Algiers",
    "Publisher",
    false,
    "Business",
  ),
  TopPicks(
    DateTime(2025, 1, 11),
    "Event 3",
    "lib/assets/event3.webp",
    "ENSIA, Algiers",
    "Publisher",
    true,
    "Education",
  ),
  TopPicks(
    DateTime(2025, 1, 11),
    "Event 4",
    "lib/assets/event1.webp",
    "ENSIA, Algiers",
    "Publisher",
    false,
    "Music",
  ),
];
