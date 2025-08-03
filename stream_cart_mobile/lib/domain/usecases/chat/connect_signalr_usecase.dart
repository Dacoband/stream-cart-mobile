import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/services/signalr_service.dart';

class ConnectSignalRUseCase {
  final SignalRService signalRService;

  ConnectSignalRUseCase(this.signalRService);

  Future<Either<Failure, void>> call() async {
    try {
      await signalRService.connect();
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure('Failed to connect SignalR: $e'));
    }
  }
}