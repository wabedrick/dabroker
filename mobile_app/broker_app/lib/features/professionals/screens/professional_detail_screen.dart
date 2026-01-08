import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/core/widgets/rating_dialog.dart';
import 'package:broker_app/data/models/pagination.dart';
import 'package:broker_app/data/models/user.dart';
import 'package:broker_app/features/inquiries/screens/chat_screen.dart';
import 'package:broker_app/features/professionals/repositories/professional_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:broker_app/features/consultations/screens/schedule_consultation_screen.dart';
import 'package:broker_app/features/professionals/widgets/contact_action_button.dart';

final professionalReviewsProvider =
    FutureProvider.family<Pagination<Map<String, dynamic>>, int>((
      ref,
      professionalId,
    ) {
      return ref
          .read(professionalRepositoryProvider)
          .getReviews(professionalId);
    });

class ProfessionalDetailScreen extends ConsumerWidget {
  final User professional;

  const ProfessionalDetailScreen({super.key, required this.professional});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = professional.professionalProfile;
    final theme = Theme.of(context);

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 360,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryBlue.withValues(alpha: 0.8),
                          AppColors.primaryBlue,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () {
                            if (professional.avatar != null &&
                                professional.avatar!.startsWith('http')) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => Scaffold(
                                    backgroundColor: Colors.black,
                                    appBar: AppBar(
                                      backgroundColor: Colors.black,
                                      iconTheme: const IconThemeData(
                                        color: Colors.white,
                                      ),
                                    ),
                                    body: Center(
                                      child: InteractiveViewer(
                                        minScale: 0.5,
                                        maxScale: 4.0,
                                        child: Image.network(
                                          professional.avatar!,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Hero(
                            tag: 'professional_avatar_${professional.id}',
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  professional.avatar != null &&
                                      professional.avatar!.startsWith('http')
                                  ? NetworkImage(professional.avatar!)
                                  : null,
                              child:
                                  professional.avatar == null ||
                                      !professional.avatar!.startsWith('http')
                                  ? Text(
                                      professional.name[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryBlue,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          professional.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            professional.preferredRole.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (profile != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${professional.averageRating.toStringAsFixed(1)} Rating',
                                style: const TextStyle(color: Colors.white),
                              ),
                              if (profile.experienceYears != null) ...[
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.work_history,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${profile.experienceYears} Yrs Exp',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ],
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (professional.phone != null)
                              ContactActionButton(
                                icon: Icons.phone,
                                label: 'Call',
                                onTap: () async {
                                  final uri = Uri.parse(
                                    'tel:${professional.phone}',
                                  );
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  }
                                },
                              ),
                            if (professional.phone != null)
                              const SizedBox(width: 16),
                            ContactActionButton(
                              icon: Icons.email,
                              label: 'Email',
                              onTap: () async {
                                final uri = Uri.parse(
                                  'mailto:${professional.email}',
                                );
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: AppColors.primaryBlue,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColors.primaryBlue,
                    tabs: const [
                      Tab(text: 'Profile'),
                      Tab(text: 'Portfolio'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              _ProfileTab(professional: professional),
              _PortfolioTab(professional: professional),
              _ReviewsTab(professional: professional),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final repository = ref.read(professionalRepositoryProvider);
                  try {
                    final response = await repository.contactProfessional(
                      professional.id.toString(),
                      'Hi, I would like to inquire about your services.',
                    );
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            inquiryId: response['public_id'].toString(),
                            title: professional.name,
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primaryBlue),
                ),
                child: const Text('Message'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScheduleConsultationScreen(
                        professionalId: professional.id,
                        professionalName: professional.name,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Book Consultation',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final User professional;

  const _ProfileTab({required this.professional});

  @override
  Widget build(BuildContext context) {
    final profile = professional.professionalProfile;
    if (profile == null) {
      return const Center(child: Text('No profile details available'));
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'About'),
          const SizedBox(height: 8),
          Text(
            profile.bio ?? 'No bio available.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          if (profile.specialties?.isNotEmpty == true) ...[
            _SectionHeader(title: 'Specialties'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.specialties!.map((specialty) {
                return Chip(
                  label: Text(specialty),
                  backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                  labelStyle: const TextStyle(color: AppColors.primaryBlue),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          if (profile.languages?.isNotEmpty == true) ...[
            _SectionHeader(title: 'Languages'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.languages!.map((lang) {
                return Chip(
                  avatar: const Icon(Icons.language, size: 16),
                  label: Text(lang),
                  backgroundColor: Colors.grey[100],
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          if (profile.education?.isNotEmpty == true) ...[
            _SectionHeader(title: 'Education'),
            const SizedBox(height: 8),
            ...profile.education!.map((edu) {
              final subtitle = [
                edu['institution'],
                edu['year'],
              ].where((e) => e != null && e.toString().isNotEmpty).join(' • ');
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.school, color: Colors.grey),
                title: Text(edu['degree'] ?? 'Degree'),
                subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
              );
            }),
            const SizedBox(height: 24),
          ],

          if (profile.certifications?.isNotEmpty == true) ...[
            _SectionHeader(title: 'Certifications'),
            const SizedBox(height: 8),
            ...profile.certifications!.map((cert) {
              final subtitle = [
                cert['issuer'],
                cert['year'],
              ].where((e) => e != null && e.toString().isNotEmpty).join(' • ');
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.workspace_premium,
                  color: Colors.amber,
                ),
                title: Text(cert['name'] ?? 'Certification'),
                subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
              );
            }),
            const SizedBox(height: 24),
          ],

          _SectionHeader(title: 'Details'),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.attach_money,
            label: 'Hourly Rate',
            value: '\$${profile.hourlyRate ?? 0}/hr',
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.verified_user,
            label: 'License Number',
            value: profile.licenseNumber ?? 'N/A',
          ),
        ],
      ),
    );
  }
}

class _PortfolioTab extends StatelessWidget {
  final User professional;

  const _PortfolioTab({required this.professional});

  @override
  Widget build(BuildContext context) {
    final portfolios = professional.professionalProfile?.portfolios;

    if (portfolios == null || portfolios.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No portfolio items yet',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: portfolios.length,
      itemBuilder: (context, index) {
        final item = portfolios[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.url != null) // Placeholder for image if we had one
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.image, size: 48, color: Colors.grey),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.projectDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Completed: ${item.projectDate!.toString().split(' ')[0]}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                    if (item.description != null) ...[
                      const SizedBox(height: 8),
                      Text(item.description!),
                    ],
                    if (item.url != null) ...[
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () => launchUrl(Uri.parse(item.url!)),
                        icon: const Icon(Icons.link),
                        label: const Text('View Project'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReviewsTab extends ConsumerWidget {
  final User professional;

  const _ReviewsTab({required this.professional});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(
      professionalReviewsProvider(professional.id),
    );

    return RefreshIndicator(
      onRefresh: () =>
          ref.refresh(professionalReviewsProvider(professional.id).future),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Summary Section
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professional.averageRating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < professional.averageRating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                  ),
                  Text(
                    '${professional.ratingsCount} reviews',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => RatingDialog(
                      onSubmit: (rating, review) async {
                        try {
                          await ref
                              .read(professionalRepositoryProvider)
                              .rateProfessional(
                                professional.id,
                                rating.toInt(),
                                review,
                              );
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Rating submitted!'),
                              ),
                            );
                            ref.invalidate(
                              professionalReviewsProvider(professional.id),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Write a Review'),
              ),
            ],
          ),
          const Divider(height: 32),

          // Reviews List
          reviewsAsync.when(
            data: (pagination) {
              final reviews = pagination.data;
              if (reviews.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('No reviews yet. Be the first to review!'),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  final user = review['user'];
                  final rating = (review['rating'] as num?)?.toInt() ?? 0;
                  final comment = review['review'] as String?;
                  final dateStr = review['created_at'] as String?;
                  final date = dateStr != null
                      ? DateTime.tryParse(dateStr) ?? DateTime.now()
                      : DateTime.now();

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundImage: user != null && user['avatar'] != null
                          ? NetworkImage(user['avatar'])
                          : null,
                      child: user == null || user['avatar'] == null
                          ? Text(
                              ((user?['name'] as String?) ?? 'A')[0]
                                  .toUpperCase(),
                            )
                          : null,
                    ),
                    title: Row(
                      children: [
                        Text(
                          (user?['name'] as String?) ?? 'Anonymous',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          '${date.day}/${date.month}/${date.year}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(5, (i) {
                            return Icon(
                              i < rating ? Icons.star : Icons.star_border,
                              size: 14,
                              color: Colors.amber,
                            );
                          }),
                        ),
                        if (comment != null && comment.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(comment),
                        ],
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error loading reviews: $e')),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
