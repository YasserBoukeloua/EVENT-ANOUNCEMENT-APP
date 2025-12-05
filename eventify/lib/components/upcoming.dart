class UpComing {
  DateTime? date;
  String? nameOfevent;
  String? location;
  String? pathToImg;

  UpComing(this.date, this.nameOfevent, this.pathToImg, this.location);
}

List<UpComing> upComing = [
  UpComing(
    DateTime(11, 01, 2025),
    "Event 1",
    "lib/assets/event4.jpg",
    "ensia, Algiers",
  ),

  UpComing(
    DateTime(11, 01, 2025),
    "Event 2",
    "lib/assets/event2.webp",
    "ensia, Algiers",
  ),

  UpComing(
    DateTime(11, 01, 2025),
    "Event 3",
    "lib/assets/event3.webp",
    "ensia, Algiers",
  ),

  UpComing(
    DateTime(11, 01, 2025),
    "Event 4",
    "lib/assets/event1.webp",
    "ensia, Algiers",
  ),
];
