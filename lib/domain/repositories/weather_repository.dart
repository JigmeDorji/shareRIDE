import 'package:shareRIDE/domain/entities/coordinates.dart';
import 'package:shareRIDE/domain/entities/weather.dart';

/// Handles the retrieval of all weather data.
abstract class WeatherRepository {

  /// Returns the current [Weather] data for a given set of [coordinates].
  Future<Weather> getWeather(Coordinates coordinates);
}