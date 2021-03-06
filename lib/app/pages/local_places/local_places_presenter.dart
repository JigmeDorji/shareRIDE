import 'package:shareRIDE/domain/entities/local_place.dart';
import 'package:shareRIDE/domain/usecases/get_local_places_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class LocalPlacesPresenter extends Presenter {

  Function getLocalPlacesOnNext;
  Function getLocalPlacesOnComplete;
  Function getLocalPlacesOnError;

  GetLocalPlacesUseCase _getLocalPlacesUseCase;

  LocalPlacesPresenter(localPlacesRepo, locationRepo) {
    _getLocalPlacesUseCase = GetLocalPlacesUseCase(localPlacesRepo, locationRepo);
  }

  void dispose() {
    _getLocalPlacesUseCase.dispose();
  }

  void getLocalPlaces() {
    _getLocalPlacesUseCase.execute(_GetLocalPlacesPresenter(this));
  }
}

class _GetLocalPlacesPresenter implements Observer<List<LocalPlace>> {
  LocalPlacesPresenter _localPlacesPresenter;
  _GetLocalPlacesPresenter(this._localPlacesPresenter);

  void onNext(places) {
    // any cleaning or preparation goes here before invoking callback
    assert(places is List<LocalPlace>);
    assert(_localPlacesPresenter.getLocalPlacesOnNext != null);
    _localPlacesPresenter.getLocalPlacesOnNext(places);
  }

  void onComplete() {
    assert(_localPlacesPresenter.getLocalPlacesOnComplete != null);
    _localPlacesPresenter.getLocalPlacesOnComplete();
  }

  void onError(e) {
    // any cleaning or preparation goes here
    assert(_localPlacesPresenter.getLocalPlacesOnError != null);
    _localPlacesPresenter.getLocalPlacesOnError(e);
    
  }
}