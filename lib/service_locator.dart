import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:project_kisan/data/datasources/remote/agmarknet_api_client.dart';
import 'package:project_kisan/data/repositories/market_repository_impl.dart';
import 'package:project_kisan/domain/repositories/market_repository.dart';

import 'data/datasources/remote/gemini_service.dart';
import 'data/repositories/assistant_repository_impl.dart';
import 'domain/repositories/assistant_repository.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Dio
  sl.registerLazySingleton(Dio.new);

  // Services
  sl.registerLazySingleton(() => GeminiService.instance);
  sl.registerLazySingleton(() => AgmarknetApiClient(sl()));

  // Repositories
  sl.registerLazySingleton<AssistantRepository>(
    () => AssistantRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<MarketRepository>(
    () => MarketRepositoryImpl(sl()),
  );
}
