class TopPicks {
  int id;
  DateTime? date;
  String? nameOfevent;
  String? location;
  String? pathToImg;
  String? publisher;
  bool isFree;
  String category;
  String? description;

  TopPicks(
    this.id,
    this.date,
    this.nameOfevent,
    this.pathToImg,
    this.location,
    this.publisher,
    this.isFree,
    this.category, {
    this.description,
  });
}

List<TopPicks> topPicks = [
  TopPicks(
    1,
    DateTime(2025, 1, 11),
    "Event 1",
    "lib/assets/event4.jpg",
    "ENSIA, Algiers",
    "Publisher",
    true,
    "Technology",
    description: "Join us for the Mobile Development Event! Discover the latest trends in app design and mobile AI integration.",
  ),
  TopPicks(
    2,
    DateTime(2025, 1, 11),
    "Event 2",
    "lib/assets/event2.webp",
    "ENSIA, Algiers",
    "Publisher",
    false,
    "Business",
    description: "A networking event for business professionals. Connect with industry leaders and explore new opportunities.",
  ),
  TopPicks(
    3,
    DateTime(2025, 1, 11),
    "Event 3",
    "lib/assets/event3.webp",
    "ENSIA, Algiers",
    "Publisher",
    true,
    "Education",
    description: "An educational workshop focused on the latest learning methodologies and educational technologies.",
  ),
  TopPicks(
    4,
    DateTime(2025, 1, 11),
    "Event 4",
    "lib/assets/event1.webp",
    "ENSIA, Algiers",
    "Publisher",
    false,
    "Music",
    description: "Experience an unforgettable night of live music performances featuring local and international artists.",
  ),
];

