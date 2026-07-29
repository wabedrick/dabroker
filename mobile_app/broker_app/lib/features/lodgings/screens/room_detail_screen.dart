import 'package:flutter/material.dart';
import 'package:broker_app/data/models/lodging_room.dart';
import 'package:broker_app/core/utils/image_helper.dart';
import 'package:broker_app/core/utils/money_format.dart';
import 'package:broker_app/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RoomDetailScreen extends ConsumerStatefulWidget {
  final LodgingRoom room;
  final VoidCallback? onBookPressed;

  const RoomDetailScreen({
    super.key,
    required this.room,
    this.onBookPressed,
  });

  @override
  ConsumerState<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends ConsumerState<RoomDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            if (widget.room.media != null && widget.room.media!.isNotEmpty) ...[
              Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 300,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: widget.room.media!.length > 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                    ),
                    items: widget.room.media!.map((media) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Image.network(
                            ImageHelper.fixUrl(media.url),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.image_not_supported,
                                  size: 50, color: Colors.grey),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  if (widget.room.media!.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.room.media!.asMap().entries.map((entry) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == entry.key
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ] else ...[
              Container(
                height: 250,
                color: colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: Icon(Icons.hotel, size: 64, color: Colors.grey),
                ),
              ),
            ],

            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.room.name,
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatMoney(widget.room.price, widget.room.currency),
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '/ night',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Key Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (widget.room.capacity != null)
                        _buildInfoItem(
                          context,
                          icon: Icons.person,
                          label: 'Sleeps ${widget.room.capacity}',
                        ),
                      if (widget.room.roomType != null)
                        _buildInfoItem(
                          context,
                          icon: Icons.meeting_room,
                          label: widget.room.roomType!,
                        ),
                      if (widget.room.bedType != null)
                        _buildInfoItem(
                          context,
                          icon: Icons.bed,
                          label: widget.room.bedType!,
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),

                  // Description
                  if (widget.room.description != null &&
                      widget.room.description!.isNotEmpty) ...[
                    Text(
                      'About this room',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.room.description!,
                      style: textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Features
                  if (widget.room.features != null &&
                      widget.room.features!.isNotEmpty) ...[
                    Text(
                      'Room Features',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      children: widget.room.features!.map((feature) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_outline,
                                  size: 20, color: colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                feature,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.onBookPressed != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: FilledButton(
                  onPressed: widget.onBookPressed,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Book this Room',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoItem(BuildContext context, {required IconData icon, required String label}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colorScheme.onPrimaryContainer),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
