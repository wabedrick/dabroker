enum NotificationCategory { inquiries, favorites, bookings, reservations }

extension NotificationCategoryPath on NotificationCategory {
  String get pathSegment {
    switch (this) {
      case NotificationCategory.inquiries:
        return 'inquiries';
      case NotificationCategory.favorites:
        return 'favorites';
      case NotificationCategory.bookings:
        return 'bookings';
      case NotificationCategory.reservations:
        return 'reservations';
    }
  }

  String get label {
    switch (this) {
      case NotificationCategory.inquiries:
        return 'Chats';
      case NotificationCategory.favorites:
        return 'Favourites';
      case NotificationCategory.bookings:
        return 'Bookings';
      case NotificationCategory.reservations:
        return 'Reservations';
    }
  }
}

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    required this.category,
    this.relatedPropertyId,
    this.metadata,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final NotificationCategory category;
  final String? relatedPropertyId;
  final Map<String, dynamic>? metadata;

  factory NotificationItem.fromJson(
    Map<String, dynamic> json,
    NotificationCategory category,
  ) {
    if (category == NotificationCategory.inquiries) {
      final property = json['property'] as Map<String, dynamic>? ?? {};
      return NotificationItem(
        id: json['public_id'] as String? ?? json['id'].toString(),
        title: 'Chat: ${property['title'] ?? 'Unknown Property'}',
        body: json['message'] as String? ?? 'No message',
        createdAt:
            DateTime.tryParse(json['created_at'] as String? ?? '') ??
            DateTime.now(),
        isRead: json['buyer_read_at'] != null,
        category: category,
        relatedPropertyId:
            property['public_id']?.toString() ?? property['id']?.toString(),
        metadata: {
          ...json,
          'inquiry_id': json['public_id'] as String? ?? json['id'].toString(),
        },
      );
    } else if (category == NotificationCategory.favorites) {
      // Check if this is a property (buyer's favorites) or interested buyer (owner's view)
      final isProperty = json['owner'] != null || json['price'] != null;

      if (isProperty) {
        // Buyer's favorite property
        final owner = json['owner'] as Map<String, dynamic>? ?? {};
        final address = json['address'] as String?;
        final city = json['city'] as String?;
        final state = json['state'] as String?;
        final country = json['country'] as String?;

        // Build location string from available components
        final location = [
          address,
          city,
          state,
          country,
        ].where((part) => part != null && part.isNotEmpty).join(', ');

        // Extract property ID safely - could be string or int
        final propertyId = json['id'];
        final propertyIdStr = propertyId != null ? propertyId.toString() : '';

        return NotificationItem(
          id: propertyIdStr,
          title: json['title'] as String? ?? 'Property',
          body:
              '${owner['name'] ?? 'Listed by'} • ${location.isNotEmpty ? location : 'Location unavailable'}',
          createdAt:
              DateTime.tryParse(json['created_at'] as String? ?? '') ??
              DateTime.now(),
          isRead: true,
          category: category,
          relatedPropertyId: propertyIdStr.isNotEmpty ? propertyIdStr : null,
          metadata: json,
        );
      } else {
        // Owner's interested buyers
        final property = json['property'] as Map<String, dynamic>? ?? {};
        final buyer = json['user'] as Map<String, dynamic>? ?? {};
        return NotificationItem(
          id: json['public_id'] as String? ?? json['id'].toString(),
          title: 'New Interested Buyer',
          body:
              '${buyer['name'] ?? 'Someone'} liked ${property['title'] ?? 'your property'}',
          createdAt:
              DateTime.tryParse(json['created_at'] as String? ?? '') ??
              DateTime.now(),
          isRead: json['owner_read_at'] != null,
          category: category,
          relatedPropertyId:
              property['public_id']?.toString() ?? property['id']?.toString(),
          metadata: {},
        );
      }
    } else if (category == NotificationCategory.bookings ||
        category == NotificationCategory.reservations) {
      final lodging = json['lodging'] as Map<String, dynamic>? ?? {};
      final user = json['user'] as Map<String, dynamic>? ?? {};
      final isHostView = category == NotificationCategory.reservations;

      final title = isHostView
          ? 'New Reservation: ${lodging['title']}'
          : 'Booking: ${lodging['title']}';

      final body = isHostView
          ? '${user['name'] ?? 'Guest'} requested ${json['check_in']} - ${json['check_out']}'
          : 'Status: ${json['status']} (${json['check_in']} - ${json['check_out']})';

      return NotificationItem(
        id: json['id'].toString(),
        title: title,
        body: body,
        createdAt:
            DateTime.tryParse(json['created_at'] as String? ?? '') ??
            DateTime.now(),
        isRead: true, // Bookings don't have a read state in this context yet
        category: category,
        relatedPropertyId: lodging['id']?.toString(),
        metadata: json,
      );
    }

    return NotificationItem(
      id: json['id'].toString(),
      title: json['title'] as String? ?? 'Notification',
      body: json['body'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      isRead: json['is_read'] as bool? ?? false,
      category: category,
      relatedPropertyId: (json['property_id'] ?? json['related_id'])
          ?.toString(),
      metadata:
          (json['metadata'] as Map<String, dynamic>?) ?? <String, dynamic>{},
    );
  }
}
