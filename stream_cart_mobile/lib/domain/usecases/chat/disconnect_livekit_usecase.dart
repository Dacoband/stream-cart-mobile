import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/services/livekit_service.dart';

class DisconnectLiveKitUseCase {
  final LivekitService livekitService;

  DisconnectLiveKitUseCase(this.livekitService);

  Future<Either<Failure, void>> call() async {
    try {
      await livekitService.disconnect();
      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Lỗi ngắt kết nối LiveKit: ${e.toString()}'));
    }
  }
}