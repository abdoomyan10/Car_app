// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../featuers/auth/data/datasource/auth_datasource.dart' as _i64;
import '../../featuers/auth/data/repos/auth_repo_imp1.dart' as _i469;
import '../../featuers/auth/domain/repos/auth_repository.dart' as _i875;
import '../../featuers/auth/domain/usecase/login-user.dart' as _i1048;
import '../../featuers/auth/domain/usecase/register_user.dart' as _i171;
import '../../featuers/auth/presentation/bloc/auth_bloc.dart' as _i204;
import '../../featuers/buy/data/datasource/car_datasource.dart' as _i507;
import '../../featuers/buy/data/repo/car_repo_impl.dart' as _i875;
import '../../featuers/buy/domain/repo/car_repo.dart' as _i261;
import '../../featuers/buy/domain/usecase/get_cars_usecase.dart' as _i285;
import '../../featuers/favorite/presentation/bloc/favorite_bloc.dart' as _i869;
import '../../featuers/home/presentation/bloc/home_bloc.dart' as _i765;
import '../../featuers/sale/data/datasource/sell_datasourcef.dart' as _i264;
import '../../featuers/sale/data/repo/sell_repo_impl.dart' as _i400;
import '../../featuers/sale/domain/repo/sell_repo.dart' as _i477;
import '../../featuers/sale/domain/usecases/sell_car_usecase.dart' as _i83;
import '../../featuers/sale/presentation/bloc/sell_car_bloc.dart' as _i410;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i264.SellCarRemoteDataSource>(
      () => _i264.SellCarRemoteDataSource(),
    );
    gh.lazySingleton<_i869.FavoriteBloc>(() => _i869.FavoriteBloc());
    gh.factory<_i507.CarListingsRemoteDataSource>(
      () => _i507.CarListingsRemoteDataSourceImpl(),
    );
    gh.factory<_i477.SellCarRepository>(
      () => _i400.SellCarRepositoryImpl(
        remoteDataSource: gh<_i264.SellCarRemoteDataSource>(),
      ),
    );
    gh.factory<_i64.AuthDatasource>(() => _i64.AuthDatasourceImpl());
    gh.factory<_i875.AuthRepo>(
      () => _i469.AuthRepoImpl(datasource: gh<_i64.AuthDatasource>()),
    );
    gh.factory<_i1048.LoginUsecase>(
      () => _i1048.LoginUsecase(repo: gh<_i875.AuthRepo>()),
    );
    gh.factory<_i171.RegisterUsecase>(
      () => _i171.RegisterUsecase(repo: gh<_i875.AuthRepo>()),
    );
    gh.factory<_i261.CarListingsRepository>(
      () => _i875.CarListingsRepositoryImpl(
        remoteDataSource: gh<_i507.CarListingsRemoteDataSource>(),
      ),
    );
    gh.factory<_i83.SubmitCarListing>(
      () => _i83.SubmitCarListing(repository: gh<_i477.SellCarRepository>()),
    );
    gh.factory<_i285.GetCarListings>(
      () => _i285.GetCarListings(gh<_i261.CarListingsRepository>()),
    );
    gh.lazySingleton<_i204.AuthBloc>(
      () => _i204.AuthBloc(
        gh<_i1048.LoginUsecase>(),
        gh<_i171.RegisterUsecase>(),
      ),
    );
    gh.lazySingleton<_i765.HomeBloc>(
      () => _i765.HomeBloc(gh<_i285.GetCarListings>()),
    );
    gh.lazySingleton<_i410.SellCarBloc>(
      () => _i410.SellCarBloc(submitCarListing: gh<_i83.SubmitCarListing>()),
    );
    return this;
  }
}
