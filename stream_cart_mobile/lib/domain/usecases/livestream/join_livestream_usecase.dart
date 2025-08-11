import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/livestream/livestream_entity.dart';
import '../../repositories/livestream/livestream_repository.dart';

class JoinLiveStreamUseCase {
  final LiveStreamRepository repository;
  JoinLiveStreamUseCase(this.repository);

  Future<Either<Failure, LiveStreamEntity>> call(String id) async {
    return await repository.joinLiveStream(id);
  }
}
