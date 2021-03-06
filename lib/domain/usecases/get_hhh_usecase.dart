import 'package:shareRIDE/domain/repositories/hhh_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shareRIDE/domain/entities/hhh.dart';
import 'package:shareRIDE/domain/entities/sponsor.dart';
import 'package:shareRIDE/domain/repositories/sponsor_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

/// Retrieves this year's [HHH]
class GetHHHUseCase extends UseCase<GetHHHUseCaseResponse, void> {
  HHHRepository _hhhRepository;
  SponsorRepository _sponsorRepository;

  GetHHHUseCase(this._hhhRepository, this._sponsorRepository);

  @override
  Future<Observable<GetHHHUseCaseResponse>> buildUseCaseObservable(void ignore) async {
    final StreamController<GetHHHUseCaseResponse> controller = StreamController();
    try {
      // get current HHH and Sponsors in parallel
      List<Future> futures = List<Future>();
      futures.add(_hhhRepository.getCurrentHHH());
      futures.add(_sponsorRepository.getCurrentSponsors());
      var result = await Future.wait(futures);

      // debug mode only
      assert (result[0] is HHH);
      assert (result[1] is List<Sponsor>);

      GetHHHUseCaseResponse response = GetHHHUseCaseResponse(result[0], result[1]);
      controller.add(response);
      logger.finest('GetHHHUseCase successful.');
      controller.close();
    } catch (e) {
      print(e);
      logger.severe('GetHHHUseCase unsuccessful.');
      controller.addError(e);
    }
    return Observable(controller.stream);
  }
}

class GetHHHUseCaseResponse {
  HHH _hhh;
  List<Sponsor> _sponsors;

  HHH get hhh => _hhh;
  List<Sponsor> get sponsors => _sponsors;

  GetHHHUseCaseResponse(this._hhh, this._sponsors);

}


