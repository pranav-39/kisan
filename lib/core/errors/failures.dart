import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  
  const Failure({required this.message, this.code});
  
  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred. Please try again later.',
    super.code,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to load cached data.',
    super.code,
  });
}

class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed. Please try again.',
    super.code,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Validation failed. Please check your input.',
    super.code,
  });
}

class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'Permission denied. Please grant the required permissions.',
    super.code,
  });
}

class LocationFailure extends Failure {
  const LocationFailure({
    super.message = 'Failed to get location. Please enable location services.',
    super.code,
  });
}

class ImageProcessingFailure extends Failure {
  const ImageProcessingFailure({
    super.message = 'Failed to process image. Please try again.',
    super.code,
  });
}

class AIServiceFailure extends Failure {
  const AIServiceFailure({
    super.message = 'AI service is currently unavailable. Please try again later.',
    super.code,
  });
}

class SyncFailure extends Failure {
  const SyncFailure({
    super.message = 'Failed to sync data. Will retry automatically.',
    super.code,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.code,
  });
}
