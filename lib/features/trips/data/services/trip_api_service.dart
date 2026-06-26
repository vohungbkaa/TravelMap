import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:travel_map/features/trips/domain/models/trip.dart';

part 'trip_api_service.g.dart';

@RestApi()
abstract class TripApiService {
  factory TripApiService(Dio dio) = _TripApiService;

  @GET('/todos')
  Future<List<Trip>> getTrips();

  @GET('/todos/{id}')
  Future<Trip> getTripById(@Path('id') int tripId);
}
