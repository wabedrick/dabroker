class ApiEndpoints {
  // Auth Endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String forgotPassword = '/auth/password/forgot';
  static const String resetPassword = '/auth/password/reset';
  static const String profile = '/profile';

  // Property Endpoints
  static const String properties = '/properties';
  static String propertyDetail(String id) => '/properties/$id';
  static String propertyContact(String id) => '/properties/$id/contact';
  static String favoriteProperty(String id) => '/favorites/properties/$id';
  static const String ownerProperties = '/owner/properties';
  static String ownerPropertyDetail(String id) => '/owner/properties/$id';
  static String ownerPropertyMedia(String id) => '/owner/properties/$id/media';
  static String ownerPropertyMediaDelete(String id, String mediaId) =>
      '/owner/properties/$id/media/$mediaId';
  static const String ownerInquiries = '/owner/inquiries';
  static const String ownerInterestedBuyers = '/owner/interested-buyers';

  // Lodging Endpoints
  static const String lodgings = '/lodgings';
  static String lodgingDetail(String id) => '/lodgings/$id';
  static const String hostLodgings = '/host/lodgings';
  static String hostLodgingDetail(String id) => '/host/lodgings/$id';
  static String hostLodgingAvailability(String id) =>
      '/host/lodgings/$id/availability';
  static String lodgingAvailability(String id) => '/lodgings/$id/availability';

  // Booking Endpoints
  static const String bookings = '/bookings';
  static const String hostBookings = '/host/bookings';
  static String hostBookingApprove(String id) => '/host/bookings/$id/approve';
  static String hostBookingReject(String id) => '/host/bookings/$id/reject';
  static String bookingDetail(String id) => '/bookings/$id';
  static String bookingInquiry(String id) => '/bookings/$id/inquiry';
  static String inquiryDetail(String id) => '/inquiries/$id';
  static String inquiryMessages(String id) => '/inquiries/$id/messages';

  // Professional Endpoints
  static const String professionals = '/professionals';
  static String professionalDetail(String id) => '/professionals/$id';
  static const String applyProfessional = '/professionals/apply';

  // Consultation Endpoints
  static const String consultations = '/consultations';
  static String consultationDetail(String id) => '/consultations/$id';

  // Notification Endpoints
  static const String notificationsCounters = '/notifications/counters';
  static String notificationsByCategory(String category) =>
      '/notifications/$category';

  // Admin Endpoints
  static const String adminDashboardStats = '/admin/dashboard/stats';
  static const String adminDashboardAnalytics = '/admin/dashboard/analytics';
  static const String adminModerationLogs = '/admin/moderation-logs';
  static const String adminUsers = '/admin/users';
  static String adminUser(String id) => '/admin/users/$id';
  static const String adminProperties = '/admin/properties';
  static String adminProperty(String id) => '/admin/properties/$id';
  static String adminPropertyApprove(String id) =>
      '/admin/properties/$id/approve';
  static String adminPropertyReject(String id) =>
      '/admin/properties/$id/reject';

  static const String adminLodgings = '/admin/lodgings';
  static String adminLodging(String id) => '/admin/lodgings/$id';
  static String adminLodgingApprove(String id) => '/admin/lodgings/$id/approve';
  static String adminLodgingReject(String id) => '/admin/lodgings/$id/reject';
}
