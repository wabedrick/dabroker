import 'package:broker_app/data/models/pagination.dart';
import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/data/models/property_list_response.dart';
import 'package:broker_app/features/admin/data/admin_repository.dart';
import 'package:broker_app/features/admin/providers/admin_dashboard_provider.dart';
import 'package:broker_app/features/admin/providers/admin_property_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {
  late MockAdminRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockAdminRepository();
    container = ProviderContainer(
      overrides: [adminRepositoryProvider.overrideWithValue(mockRepository)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  const testProperty = Property(
    id: '1',
    title: 'Test Property',
    status: 'pending',
  );

  final testResponse = PropertyListResponse(
    data: [testProperty],
    meta: const PaginationMeta(
      currentPage: 1,
      from: 1,
      lastPage: 1,
      perPage: 15,
      to: 1,
      total: 1,
    ),
    links: const PaginationLinks(first: '', last: ''),
  );

  test('AdminPropertiesNotifier loads properties', () async {
    when(
      () => mockRepository.fetchProperties(status: 'pending'),
    ).thenAnswer((_) async => testResponse);

    container.read(adminPropertiesProvider('pending').notifier);

    // Initial state is loading
    expect(
      container.read(adminPropertiesProvider('pending')),
      const AsyncValue<List<Property>>.loading(),
    );

    // Wait for load to complete
    await Future.delayed(Duration.zero);

    final state = container.read(adminPropertiesProvider('pending'));
    expect(state, isA<AsyncData<List<Property>>>());
    expect(state.value!.length, 1);
    expect(state.value!.first.id, '1');

    verify(() => mockRepository.fetchProperties(status: 'pending')).called(1);
  });

  test(
    'AdminPropertiesNotifier approves property and removes from list',
    () async {
      when(
        () => mockRepository.fetchProperties(status: 'pending'),
      ).thenAnswer((_) async => testResponse);
      when(
        () => mockRepository.approveProperty('1'),
      ).thenAnswer((_) async => testProperty.copyWith(status: 'approved'));

      final notifier = container.read(
        adminPropertiesProvider('pending').notifier,
      );
      await Future.delayed(Duration.zero); // Wait for load

      await notifier.approve('1');

      final state = container.read(adminPropertiesProvider('pending'));
      expect(state.value, isEmpty);

      verify(() => mockRepository.approveProperty('1')).called(1);
    },
  );

  test(
    'AdminPropertiesNotifier rejects property and removes from list',
    () async {
      when(
        () => mockRepository.fetchProperties(status: 'pending'),
      ).thenAnswer((_) async => testResponse);
      when(
        () => mockRepository.rejectProperty('1', 'reason'),
      ).thenAnswer((_) async => testProperty.copyWith(status: 'rejected'));

      final notifier = container.read(
        adminPropertiesProvider('pending').notifier,
      );
      await Future.delayed(Duration.zero); // Wait for load

      await notifier.reject('1', 'reason');

      final state = container.read(adminPropertiesProvider('pending'));
      expect(state.value, isEmpty);

      verify(() => mockRepository.rejectProperty('1', 'reason')).called(1);
    },
  );
}
