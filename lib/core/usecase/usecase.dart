import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

/// '<>' means type parameter. which means Class Usecase has 2 type parameters. the SuccessType and Params.

abstract interface class Usecase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}