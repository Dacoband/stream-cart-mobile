import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/services/signalr_service.dart';

class DisconnectSignalRUseCase {
  final SignalRService signalRService;

  DisconnectSignalRUseCase(this.signalRService);

  Future<Either<Failure, void>> call() async {
    try {
      await signalRService.disconnect();
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure('Failed to disconnect SignalR: $e'));
    }
  }
}