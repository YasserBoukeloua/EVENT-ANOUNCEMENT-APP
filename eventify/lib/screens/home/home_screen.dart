import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:project/components/top_picks.dart';
import 'package:project/components/upcoming.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username = 'Mustapha';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 172, 173, 188),
      extendBody: true,

      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Color.fromARGB(255, 172, 173, 188)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 35, 12, 51),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello $username",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                "You have 3 events this week",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(width: 3, color: Colors.white),
                            ),
                            child: Icon(
                              Icons.person_outline_outlined,
                              color: Colors.white,
                              size: 45,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 155, 158, 206),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Search...",
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ),
                            Icon(Icons.search, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20, left: 15),
                child: Text(
                  "Upcoming events",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        for (int i = 0; i < upComing.length; i++)
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                            ),
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 15,
                                top: 15,
                                right: (i == upComing.length - 1) ? 15 : 0,
                              ),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 250,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset(
                                      upComing[i].pathToImg!,
                                      height: 90,
                                      width: 67,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: SizedBox(
                                      height: 70,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DateFormat(
                                              'dd/MM/yyyy',
                                            ).format(upComing[i].date!),
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                103,
                                                101,
                                                221,
                                                1,
                                              ),
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            upComing[i].nameOfevent!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 14,
                                                color: Color.fromRGBO(
                                                  103,
                                                  101,
                                                  221,
                                                  1,
                                                ),
                                              ),
                                              SizedBox(width: 2),
                                              Expanded(
                                                child: Text(
                                                  upComing[i].location!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color.fromRGBO(
                                                      103,
                                                      101,
                                                      221,
                                                      1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Top Picks",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        overlayColor: Colors.transparent,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(103, 101, 221, 1),
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: const Text(
                          "View all",
                          style: TextStyle(
                            color: Color.fromRGBO(103, 101, 221, 1),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  width: 380,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          overlayColor: Colors.transparent,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: Icon(
                                  Icons.grid_view,
                                  color: Color.fromRGBO(103, 101, 221, 1),
                                ),
                              ),
                              Text(
                                "All",
                                style: TextStyle(
                                  color: Color.fromRGBO(103, 101, 221, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          overlayColor: Colors.transparent,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: SizedBox(
                          height: 40,
                          width: 70,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: Icon(
                                  Icons.access_time,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Recent",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          overlayColor: Colors.transparent,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: SizedBox(
                          height: 40,
                          width: 70,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Closest",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < topPicks.length; i++)
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          overlayColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 220,
                          margin: EdgeInsets.only(
                            top: 15,
                            left: 15,
                            right: 15,
                            bottom: (i == topPicks.length - 1) ? 70 : 0,
                          ),
                          padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  topPicks[i].pathToImg!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 5,
                                  right: 10,
                                  top: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          topPicks[i].nameOfevent!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          DateFormat(
                                            'dd MMM. yyyy',
                                          ).format(topPicks[i].date!),
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                              103,
                                              101,
                                              221,
                                              1,
                                            ),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: Color.fromRGBO(
                                            103,
                                            101,
                                            221,
                                            1,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          topPicks[i].location!,
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                              103,
                                              101,
                                              221,
                                              1,
                                            ),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 35, 12, 51),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.home_outlined, size: 30, color: Colors.white),
                    Icon(Icons.calendar_today, size: 25, color: Colors.white),
                    Icon(
                      Icons.star_border_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.person_outline_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
