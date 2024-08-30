part of 'init_dependencies.dart';

/// The creation of DI inside of the _initAuth() and _initBloc() is written as an order. First, you create datasource,
/// then repository, and then use cases, and then bloc. But it's actually not mandatory, for example you can put repository
/// before the datasource and it will not give an error.

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  // Initializing supabase
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  // Initializing hive
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;

  /// the registerLazySingleton() function is used when you want to create the instance of the object only for one time.
  /// meanwhile, the registerFactory() function is used when you want to create the instance of the object every single
  /// time when it's needed.
  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
        () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  serviceLocator
  // Datasource
    ..registerFactory<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
  // Repository
    ..registerFactory<AuthRepository>(
          () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
  // Use cases
    ..registerFactory(
          () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
          () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
          () => CurrentUser(
        serviceLocator(),
      ),
    )
  // Bloc
    ..registerLazySingleton(
          () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
  // Datasource
    ..registerFactory<BlogRemoteDataSource>(
          () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
          () => BlogLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
  // Repository
    ..registerFactory<BlogRepository>(
          () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
  // Use cases
    ..registerFactory(
          () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
          () => GetAllBlogs(
        serviceLocator(),
      ),
    )
  // Bloc
    ..registerLazySingleton(
          () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}
