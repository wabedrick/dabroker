import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/core/utils/image_helper.dart';
import 'package:broker_app/core/widgets/skeleton_box.dart';
import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/features/properties/providers/property_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:broker_app/features/auth/providers/auth_provider.dart';
import 'package:broker_app/features/properties/screens/add_property_screen.dart';

class PropertyDetailScreen extends ConsumerStatefulWidget {
  const PropertyDetailScreen({
    super.key,
    required this.propertyId,
    this.initialProperty,
  });

  final String propertyId;
  final Property? initialProperty;

  @override
  ConsumerState<PropertyDetailScreen> createState() =>
      _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends ConsumerState<PropertyDetailScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  Property? _property;
  bool _isLoading = true;
  String? _error;
  bool _isFavoriteUpdating = false;
  bool _isContacting = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_handlePageChanged);
    _property = widget.initialProperty;
    _isLoading = _property == null;
    _fetchProperty();
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_handlePageChanged)
      ..dispose();
    super.dispose();
  }

  void _handlePageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() => _currentPage = page);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_property == null && _isLoading) {
      return const Scaffold(body: PropertyDetailSkeleton());
    }

    final property = _property;
    if (property == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.error,
                ),
                const SizedBox(height: 12),
                Text(
                  _error ?? 'Unable to load property details',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchProperty,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final location = _formatLocation(property.city, property.state);
    final price = _formatPrice(property.price, property.currency);
    final user = ref.watch(authStateProvider).user;
    final isOwner = user != null && property.owner?.id == user.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(property.title),
        actions: [
          if (isOwner) ...[
            Switch(
              value: property.isAvailable ?? true,
              onChanged: _toggleAvailability,
              activeTrackColor: Colors.green,
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPropertyScreen(property: property),
                  ),
                );
                _fetchProperty();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context, property.id),
            ),
          ],
          IconButton(
            icon: _isFavoriteUpdating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    property.isFavorited == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
            onPressed: _isFavoriteUpdating ? null : _handleToggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.ios_share),
            onPressed: () {
              // TODO: Implement share sheet.
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GallerySection(
                  controller: _pageController,
                  currentIndex: _currentPage,
                  media: property.gallery,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (location != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          if (property.type != null)
                            _InfoChip(label: 'Type', value: property.type!),
                          if (property.category != null)
                            _InfoChip(
                              label: 'Listing Type',
                              value: property.category == 'rent'
                                  ? 'For Rent'
                                  : 'For Sale',
                            ),
                          if (property.size != null &&
                              property.sizeUnit != null)
                            _InfoChip(
                              label: 'Size',
                              value:
                                  '${property.size?.toStringAsFixed(0)} ${property.sizeUnit}',
                            ),
                          if (property.houseAge != null)
                            _InfoChip(
                              label: 'Built',
                              value: '${property.houseAge} yrs',
                            ),
                          if (property.status != null)
                            _InfoChip(label: 'Status', value: property.status!),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (property.owner != null)
                        _OwnerCard(owner: property.owner!),
                      if (property.description?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 32),
                        Text(
                          'Overview',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          property.description!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(height: 1.5),
                        ),
                      ],
                      if (property.amenities?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 32),
                        Text(
                          'Amenities',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: property.amenities!
                              .map((amenity) => Chip(label: Text(amenity)))
                              .toList(),
                        ),
                      ],
                      if (property.metadata?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 32),
                        Text(
                          'Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        ...property.metadata!.entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    entry.key,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    '${entry.value}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha((0.05 * 255).round()),
                child: const PropertyDetailSkeleton(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ElevatedButton(
          onPressed: _isContacting ? null : _handleContactOwner,
          child: _isContacting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Contact Owner'),
        ),
      ),
    );
  }

  Future<void> _fetchProperty() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final repository = ref.read(propertyRepositoryProvider);
      final property = await repository.fetchPropertyDetail(widget.propertyId);
      if (!mounted) return;
      setState(() {
        _property = property;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleToggleFavorite() async {
    final property = _property;
    if (property == null) return;
    final target = !(property.isFavorited ?? false);
    setState(() {
      _isFavoriteUpdating = true;
    });
    try {
      final confirmed = await ref
          .read(propertyRepositoryProvider)
          .toggleFavorite(propertyId: property.id, favorite: target);
      if (!mounted) return;
      final updated = property.copyWith(isFavorited: confirmed);
      setState(() {
        _property = updated;
      });
      ref
          .read(propertyListProvider.notifier)
          .updateFavoriteStatus(property.id, confirmed);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            confirmed ? 'Added to favorites' : 'Removed from favorites',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isFavoriteUpdating = false;
        });
      }
    }
  }

  Future<void> _handleContactOwner() async {
    final property = _property;
    if (property == null) return;

    final message = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ContactOwnerSheet(propertyTitle: property.title),
    );

    if (message == null || message.trim().isEmpty) return;

    setState(() {
      _isContacting = true;
    });

    try {
      await ref
          .read(propertyRepositoryProvider)
          .contactOwner(propertyId: property.id, message: message.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Inquiry sent to owner')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isContacting = false;
        });
      }
    }
  }

  Future<void> _toggleAvailability(bool value) async {
    if (_property == null) return;

    try {
      final updatedProperty = await ref
          .read(propertyRepositoryProvider)
          .updateProperty(_property!.id, {'is_available': value});

      setState(() {
        _property = updatedProperty;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              value
                  ? 'Property is now available'
                  : 'Property is now unavailable',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update availability: $e')),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, String propertyId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Property'),
        content: const Text(
          'Are you sure you want to delete this property? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Capture navigator & messenger before the async gap to avoid using
      // the passed BuildContext after awaiting.
      // ignore: use_build_context_synchronously
      final navigator = Navigator.of(context);
      // ignore: use_build_context_synchronously
      final messenger = ScaffoldMessenger.of(context);

      try {
        await ref
            .read(propertyListProvider.notifier)
            .deleteProperty(propertyId);
        if (!mounted) return;
        navigator.pop(); // Return to list
        messenger.showSnackBar(
          const SnackBar(content: Text('Property deleted successfully')),
        );
      } catch (e) {
        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to delete property: $e')),
        );
      }
    }
  }

  String? _formatLocation(String? city, String? state) {
    if ((city?.isEmpty ?? true) && (state?.isEmpty ?? true)) return null;
    if (city != null && state != null) return '$city, $state';
    return city ?? state;
  }

  String _formatPrice(double? price, String? currency) {
    if (price == null) return 'Contact for price';
    final symbol = (currency ?? 'USD').toUpperCase();
    return '$symbol ${price.toStringAsFixed(0)}';
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({
    required this.controller,
    required this.currentIndex,
    required this.media,
  });

  final PageController controller;
  final int currentIndex;
  final List<PropertyMedia>? media;

  @override
  Widget build(BuildContext context) {
    final images = media ?? const [];

    if (images.isEmpty) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: AppColors.primaryBlue.withAlpha((0.08 * 255).round()),
          child: const Center(child: Icon(Icons.home_outlined, size: 64)),
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PageView.builder(
            controller: controller,
            itemCount: images.length,
            itemBuilder: (_, index) {
              final item = images[index];
              final url = ImageHelper.fixUrl(item.previewUrl ?? item.url);
              return Image.network(
                url,
                fit: BoxFit.cover,
                cacheWidth: 1080, // Optimize memory usage for detail view
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.primaryBlue.withAlpha((0.08 * 255).round()),
                  child: const Center(
                    child: Icon(Icons.broken_image_outlined, size: 48),
                  ),
                ),
              );
            },
          ),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 12,
            child: Row(
              children: List.generate(
                images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? AppColors.primaryBlue
                        : AppColors.white.withAlpha((0.7 * 255).round()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class PropertyDetailSkeleton extends StatelessWidget {
  const PropertyDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: const [
          SkeletonBox(width: double.infinity, height: 220, borderRadius: 0),
          SizedBox(height: 24),
          SkeletonBox(width: 180, height: 24),
          SizedBox(height: 12),
          SkeletonBox(width: 140, height: 16),
          SizedBox(height: 24),
          SkeletonBox(width: double.infinity, height: 100),
          SizedBox(height: 24),
          SkeletonBox(width: double.infinity, height: 160),
        ],
      ),
    );
  }
}

class _ContactOwnerSheet extends StatefulWidget {
  const _ContactOwnerSheet({required this.propertyTitle});

  final String propertyTitle;

  @override
  State<_ContactOwnerSheet> createState() => _ContactOwnerSheetState();
}

class _ContactOwnerSheetState extends State<_ContactOwnerSheet> {
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Owner',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Send a quick note about "${widget.propertyTitle}"',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Tell the owner what interests you... ',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a message';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  Navigator.of(context).pop(_messageController.text.trim());
                },
                child: const Text('Send'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _OwnerCard extends StatelessWidget {
  const _OwnerCard({required this.owner});

  final PropertyUserSummary owner;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.backgroundGray),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primaryBlue.withAlpha(
              (0.1 * 255).round(),
            ),
            child: Text(
              owner.name.isNotEmpty ? owner.name[0].toUpperCase() : '?',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.primaryBlue),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  owner.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (owner.preferredRole != null)
                  Text(
                    owner.preferredRole!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Navigate to owner profile once available.
            },
            icon: const Icon(Icons.chat_bubble_outline),
          ),
        ],
      ),
    );
  }
}
