import 'package:dio/dio.dart';
import 'package:travel_map/features/trips/domain/models/trip.dart';

class TripApiService {
  const TripApiService({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<Trip>> getTrips() async {
    final response = await _dio.get<List<dynamic>>('/todos');
    final data = response.data ?? [];

    return [
      for (final item in data.take(20))
        Trip.fromApiJson(Map<String, dynamic>.from(item as Map)),
    ];
  }
}
