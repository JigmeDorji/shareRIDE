import 'package:shareRIDE/domain/entities/coordinates.dart';
import 'package:shareRIDE/domain/entities/weather.dart';
import 'package:shareRIDE/domain/repositories/location_repository.dart';
import 'package:shareRIDE/domain/repositories/weather_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shareRIDE/domain/entities/location.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

/// Tracks a user's [Location] and provides [Weather] every time it changed until the [UseCase] is disposed.
class LocationTrackUseCase extends UseCase<LocationTrackResponse, void> {
  // Members
  final LocationRepository _locationRepository;
  final WeatherRepository _weatherRepository;
  DateTime _lastRetrievalTime;
  Coordinates lastKnownLocation;
  bool _initialRetrieval;

  LocationTrackUseCase(this._locationRepository, this._weatherRepository)
      : _lastRetrievalTime = DateTime.now(),
        _initialRetrieval = true,
        super();

  @override
  Future<Observable<LocationTrackResponse>> buildUseCaseObservable(_) async {
    return _locationRepository
        // on location change observable
        .onLocationChanged()
        // clean out any errors
        .where((data) => data != null)
        // convert the location data into a Location entity and get weather
        .map((data) => convertToResponse(data))
        // flatmap [[res], [res], [res]] to [res, res, res]
        .flatMap((mapper) => mapper)
        // remove duplicates if location has not changed
        .where((response) =>
            response != null &&
            response.location.toCoordinates() != lastKnownLocation)
        // update last known location
        .map((response) {
      lastKnownLocation = response.location.toCoordinates();
      return response;
    });
  }

  /// Converts location data to `LocationTrackResponse` observable
  Observable<LocationTrackResponse> convertToResponse(data) {
    // parse location data
    Location location = Location.withoutTime(
        data.latitude.toString(), data.longitude.toString(), data.speed);
    // log info
    if (location.toCoordinates() != lastKnownLocation) {
      logger.finest('Retrieved location successfully: $location');
    } else {
      logger.info('Did not update location. Identical to last known location');
    }
    // map every location to `LocationTrackResponse` [[response], [response], [response]]
    return Observable.fromFuture(getWeather(location));
  }

  /// retrieves new weather data as long as 10 or more minutes have elapsed
  Future<LocationTrackResponse> getWeather(Location location) async {
    // find time elapsed between current time and last weather retrieval time
    DateTime now = DateTime.now();
    Duration elapsed = now.difference(_lastRetrievalTime);

    // only retrieve new weather data every 10 minutes
    if (elapsed.inMinutes > 10 || _initialRetrieval) {
      _initialRetrieval = false;
      _lastRetrievalTime = DateTime.now();
      try {
        Weather weather =
            await _weatherRepository.getWeather(location.toCoordinates());
        logger.finest('Retrieved weather successfully');
        return LocationTrackResponse(location, weather);
      } catch (e) {
        logger.shout('Could not retrieve weather.', e);
        return LocationTrackResponse(location, null);
      }
    }
    logger.info(
        'Did not retrieve new weather data. Time elapsed: ${elapsed.inMinutes}:${elapsed.inSeconds % 60} minute(s).');
    return LocationTrackResponse(location, null);
  }
}

class LocationTrackResponse {
  final Location location;
  final Weather weather;
  LocationTrackResponse(this.location, this.weather);
}
