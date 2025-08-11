import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/livestream/livestream_entity.dart';

abstract class LiveStreamRepository {
  Future<Either<Failure, LiveStreamEntity>> getLiveStream(String id);
  Future<Either<Failure, LiveStreamEntity>> joinLiveStream(String id); 
  Future<Either<Failure, List<LiveStreamEntity>>> getLiveStreamsByShop(String shopId);
}