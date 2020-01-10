import 'package:shareRIDE/domain/entities/coordinates.dart';
import 'package:shareRIDE/domain/entities/location.dart';
import 'package:shareRIDE/domain/repositories/local_places_repository.dart';
import 'package:shareRIDE/domain/repositories/location_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shareRIDE/domain/entities/local_place.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class GetLocalPlacesUseCase extends UseCase<List<LocalPlace>, void> {
  final LocalPlacesRepository _localPlacesRepository;
  final LocationRepository _locationRepository;
  GetLocalPlacesUseCase(this._localPlacesRepository, this._locationRepository);

  @override
  Future<Observable<List<LocalPlace>>> buildUseCaseObservable(_) async {
    final StreamController<List<LocalPlace>> controller = StreamController();
    try {
      Location location = await _locationRepository.getLocation();
      Coordinates coordinates = Coordinates(location.lat, location.lon);
      List<LocalPlace> places = await _localPlacesRepository.getLocalRestaurants(latlon: coordinates);
      places.addAll(await _localPlacesRepository.getLocalHotels(latlon: coordinates));
      controller.add(places);
      logger.finest('GetLocalPlacesUseCase successful.');
      controller.close();
    } catch (e) {
      print(e);
      logger.severe('GetLocalPlacesUseCase unsuccessful.');
      controller.addError(e);
    }
    return Observable(controller.stream);
  }
}


