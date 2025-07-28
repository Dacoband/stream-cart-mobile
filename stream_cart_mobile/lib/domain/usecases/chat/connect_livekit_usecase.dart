import 'package:dartz/dartz.dart';
import 'package:stream_cart_mobile/core/error/failures.dart';
import '../../../core/services/livekit_service.dart';

class ConnectLiveKitUseCase {
  final LivekitService livekitService;

  ConnectLiveKitUseCase(this.livekitService);

  Future<Either<Failure, void>> call({
    required String chatRoomId,
    required String userId,
    required String userName,
  }) async {
    try {
      print('ConnectLiveKitUseCase: chatRoomId=$chatRoomId, userId=$userId, userName=$userName');
      await livekitService.initializeRoom(chatRoomId: chatRoomId, userId: userId, userName: userName);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Lỗi kết nối LiveKit: ${e.toString()}'));
    }
  }
}