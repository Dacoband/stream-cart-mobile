import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/livestream/livestream_entity.dart';
import '../../repositories/livestream/livestream_repository.dart';

class GetActiveLiveStreamsUseCase {
  final LiveStreamRepository repository;
  GetActiveLiveStreamsUseCase(this.repository);

  Future<Either<Failure, List<LiveStreamEntity>>> call({bool? promotedOnly}) {
    return repository.getActiveLiveStreams(promotedOnly: promotedOnly);
  }
}
