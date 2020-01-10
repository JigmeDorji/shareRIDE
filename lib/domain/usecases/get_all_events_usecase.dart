import 'package:shareRIDE/domain/repositories/event_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shareRIDE/domain/entities/event.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class GetAllEventsUseCase extends UseCase<List<Event>, void> {
  EventRepository _eventRepository;
  GetAllEventsUseCase(this._eventRepository);

  @override
  Future<Observable<List<Event>>> buildUseCaseObservable(void ignore) async {
    final StreamController<List<Event>> controller = StreamController();
    try {
      List<Event> events = await _eventRepository.getAllEvents();
      controller.add(events);
      logger.finest('GetAllEventsUseCase successful.');
      controller.close();
    } catch (e) {
      print(e);
      logger.severe('GetAllEventsUseCase unsuccessful.');
      controller.addError(e);
    }
    return Observable(controller.stream);
  }
}
