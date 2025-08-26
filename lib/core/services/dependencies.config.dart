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
import '../../featuers/auth/presentation/bloc/auth_bloc.dart' as _i204;
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
    gh.lazySingleton<_i204.AuthBloc>(
      () => _i204.AuthBloc(gh<_i1048.LoginUsecase>()),
    );
    gh.factory<_i83.SubmitCarListing>(
      () => _i83.SubmitCarListing(repository: gh<_i477.SellCarRepository>()),
    );
    gh.lazySingleton<_i410.SellCarBloc>(
      () => _i410.SellCarBloc(submitCarListing: gh<_i83.SubmitCarListing>()),
    );
    return this;
  }
}
