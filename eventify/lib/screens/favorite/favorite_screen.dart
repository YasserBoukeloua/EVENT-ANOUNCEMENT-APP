import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/constants/app_colors.dart';
import 'package:eventify/localization/app_language.dart';
import 'package:eventify/screens/post_details/post_details_screen.dart';
import 'package:eventify/components/top_picks.dart';
import 'package:eventify/cubits/favorites/favorites_cubit.dart';
import 'package:eventify/cubits/favorites/favorites_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          SafeArea(
            bottom: false,
            child: Container(
              color: AppColors.primaryDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text(
                          AppLanguage.t('favorites_title'),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'JosefinSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Event count from Cubit
                  BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      int count = 0;
                      if (state is FavoritesLoaded) {
                        count = state.favorites.length;
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 20.0),
                        child: Text(
                          '$count ${count != 1 ? AppLanguage.t('favorites_events') : AppLanguage.t('favorites_event')}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'JosefinSans',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Events List from Cubit
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFD1D1D6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryDark,
                      ),
                    );
                  }

                  if (state is FavoritesError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 60, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading favorites',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                              fontFamily: 'JosefinSans',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is FavoritesLoaded) {
                    final List<TopPicks> favorites = state.favorites;

                    if (favorites.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No favorites yet',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                                fontFamily: 'JosefinSans',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start adding events to your favorites',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontFamily: 'JosefinSans',
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final TopPicks favorite = favorites[index];
                        return EventCard(
                          event: favorite,
                          onRemove: () {
                            context.read<FavoritesCubit>().removeFavorite(favorite.id);
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final TopPicks event;
  final VoidCallback onRemove;

  const EventCard({
    Key? key,
    required this.event,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetails(
                  event: event,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Event Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _buildEventImage(),
                ),

                const SizedBox(width: 16),

                // Event Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.nameOfevent ?? 'Event',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                          fontFamily: 'JosefinSans',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.accentAlt,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              event.location ?? 'Location not specified',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                fontFamily: 'JosefinSans',
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppColors.accentAlt,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(event.date),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              fontFamily: 'JosefinSans',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: event.isFree 
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              event.isFree ? 'FREE' : 'PAID',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: event.isFree ? Colors.green : Colors.orange,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              event.category,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Favorite Button
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: onRemove,
                  tooltip: 'Remove from favorites',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventImage() {
    // Check if pathToImg is available and valid
    if (event.pathToImg != null && event.pathToImg!.isNotEmpty) {
      if (event.pathToImg!.startsWith('http') || 
          event.pathToImg!.startsWith('https') ||
          event.pathToImg!.startsWith('lib/')) {
        return Image.asset(
          event.pathToImg!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        );
      } else if (event.pathToImg!.startsWith('assets/')) {
        return Image.asset(
          event.pathToImg!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        );
      }
    }
    return _buildPlaceholder();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Date not specified';
    
    // Format: DD/MM/YYYY
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.accentAlt.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.event,
        color: AppColors.accentAlt,
        size: 32,
      ),
    );
  }
}