class NotificationCounters {
  final int unreadInquiries;
  final int buyerUnreadInquiries;
  final int unreadFavorites;
  final int savedFavorites;
  final int pendingReservations;
  final int confirmedBookings;

  const NotificationCounters({
    required this.unreadInquiries,
    required this.buyerUnreadInquiries,
    required this.unreadFavorites,
    required this.savedFavorites,
    required this.pendingReservations,
    required this.confirmedBookings,
  });

  factory NotificationCounters.fromJson(Map<String, dynamic> json) {
    return NotificationCounters(
      unreadInquiries: json['unread_inquiries'] as int? ?? 0,
      buyerUnreadInquiries: json['buyer_unread_inquiries'] as int? ?? 0,
      unreadFavorites: json['unread_favorites'] as int? ?? 0,
      savedFavorites: json['saved_favorites'] as int? ?? 0,
      pendingReservations: json['pending_reservations'] as int? ?? 0,
      confirmedBookings: json['confirmed_bookings'] as int? ?? 0,
    );
  }
}
