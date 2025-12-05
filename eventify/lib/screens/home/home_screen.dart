import 'package:eventify/components/top_picks.dart';
import 'package:eventify/localization/app_language.dart';
import 'package:eventify/screens/post_details/post_details_screen.dart';
import 'package:eventify/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username = 'Mustapha';
  String _selectedFilter = 'All'; // 'All', 'Recent', 'Closest'
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  final String _userCity = 'Algiers';

  List<TopPicks> get _filteredEvents {
    List<TopPicks> filtered = List<TopPicks>.from(topPicks);

    int _distanceScore(TopPicks event) {
      final loc = (event.location ?? '').toLowerCase();
      final city = _userCity.toLowerCase();
      return loc.contains(city) ? 0 : 1;
    }

    double _preferenceScore(TopPicks event) {
      // Simple preference: technology/education a bit higher
      final cat = event.category.toLowerCase();
      if (cat.contains('technology') || cat.contains('education')) return 1.0;
      if (cat.contains('business')) return 0.7;
      return 0.4;
    }

    switch (_selectedFilter) {
      case 'Recent':
        filtered.sort((a, b) => (b.date ?? DateTime.now())
            .compareTo(a.date ?? DateTime.now()));
        break;
      case 'Closest':
        filtered.sort((a, b) => _distanceScore(a).compareTo(_distanceScore(b)));
        break;
      case 'All':
      default:
        filtered.sort((a, b) {
          final now = DateTime.now();
          final aDays =
              a.date != null ? a.date!.difference(now).inDays.abs() : 365;
          final bDays =
              b.date != null ? b.date!.difference(now).inDays.abs() : 365;
          final aScore =
              (365 - aDays) * 0.4 + (1 - _distanceScore(a)) * 0.3 + _preferenceScore(a) * 0.3;
          final bScore =
              (365 - bDays) * 0.4 + (1 - _distanceScore(b)) * 0.3 + _preferenceScore(b) * 0.3;
          return bScore.compareTo(aScore);
        });
        break;
    }

    // Then apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((event) {
        final name = (event.nameOfevent ?? '').toLowerCase();
        final location = (event.location ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || location.contains(query);
      }).toList();
    }
    
    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToEventDetails(BuildContext context, TopPicks event) {
    final index = topPicks.indexOf(event);
    if (index != -1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostDetails(event: topPicks[index]),
        ),
      );
    }
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _onViewAllPressed() {
    setState(() {
      _selectedFilter = 'All';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        260,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 172, 173, 188),
      extendBody: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              height: 207,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 35, 12, 51),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLanguage.t('home_hello_prefix')} $username",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    fontFamily: 'JosefinSans',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLanguage.t('home_events_this_week'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    fontFamily: 'JosefinSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfilePage(),
                                ),
                              );
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border:
                                    Border.all(width: 3, color: Colors.white),
                              ),
                              child: const Icon(
                                Icons.person_outline_outlined,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 155, 158, 206),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: AppLanguage.t('home_search_hint'),
                                  hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'JosefinSans'),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: const TextStyle(color: Colors.white, fontFamily: 'JosefinSans'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.search, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Upcoming Events Section
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15),
              child: Text(
                AppLanguage.t('home_upcoming'),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  fontFamily: 'JosefinSans',
                ),
              ),
            ),

            // Horizontal Scrolling Events
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                itemCount: topPicks.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () => _navigateToEventDetails(context, topPicks[i]),
                    child: Container(
                      margin: EdgeInsets.only(right: i == topPicks.length - 1 ? 0 : 15),
                      padding: const EdgeInsets.all(10),
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
                              topPicks[i].pathToImg!,
                              height: 90,
                              width: 67,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy').format(topPicks[i].date!),
                                  style: const TextStyle(
                                    color: Color.fromRGBO(103, 101, 221, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  topPicks[i].nameOfevent!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: Color.fromRGBO(103, 101, 221, 1),
                                    ),
                                    const SizedBox(width: 2),
                                    Expanded(
                                      child: Text(
                                        topPicks[i].location!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color.fromRGBO(103, 101, 221, 1),
                                        ),
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
                  );
                },
              ),
            ),

            // Top Picks Header
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLanguage.t('home_top_picks'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      fontFamily: 'JosefinSans',
                    ),
                  ),
                  TextButton(
                    onPressed: _onViewAllPressed,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      AppLanguage.t('home_view_all'),
                      style: const TextStyle(
                        color: Color.fromRGBO(103, 101, 221, 1),
                        decoration: TextDecoration.underline,
                        decorationColor: Color.fromRGBO(103, 101, 221, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Buttons
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  _buildFilterButton(
                    icon: Icons.grid_view,
                    label: AppLanguage.t('home_filter_all'),
                    filter: "All",
                  ),
                  const SizedBox(width: 10),
                  _buildFilterButton(
                    icon: Icons.access_time,
                    label: AppLanguage.t('home_filter_recent'),
                    filter: "Recent",
                  ),
                  const SizedBox(width: 10),
                  _buildFilterButton(
                    icon: Icons.location_on,
                    label: AppLanguage.t('home_filter_closest'),
                    filter: "Closest",
                  ),
                ],
              ),
            ),

            // Event Cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 100),
              itemCount: _filteredEvents.length,
              itemBuilder: (context, i) {
                final event = _filteredEvents[i];
                return GestureDetector(
                  onTap: () => _navigateToEventDetails(context, event),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            event.pathToImg!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.nameOfevent!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'JosefinSans',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('dd MMM. yyyy').format(event.date!),
                                      style: const TextStyle(
                                        color: Color.fromRGBO(103, 101, 221, 1),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'JosefinSans',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Color.fromRGBO(103, 101, 221, 1),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    event.location!,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(103, 101, 221, 1),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'JosefinSans',
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required IconData icon,
    required String label,
    required String filter,
  }) {
    final isActive = _selectedFilter == filter;
    return ElevatedButton(
      onPressed: () => _onFilterChanged(filter),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: isActive
            ? const Color.fromRGBO(103, 101, 221, 1)
            : Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontFamily: 'JosefinSans'),
          ),
        ],
      ),
    );
  }
}