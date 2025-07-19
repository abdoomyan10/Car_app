import 'package:car_appp/core/cubit/theme_cubit.dart' as _i319;
import 'package:car_appp/featuers/auth/data/datasource/auth_datasource.dart'
    as _i43;
import 'package:car_appp/featuers/auth/data/repos/auth_repo_imp1.dart' as _i751;
import 'package:car_appp/featuers/auth/domain/repos/auth_repository.dart'
    as _i976;
import 'package:car_appp/featuers/auth/domain/usecase/login-user.dart' as _i911;
import 'package:car_appp/featuers/auth/presentation/bloc/auth_bloc.dart'
    as _i797;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt initGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i319.ThemeCubit>(() => _i319.ThemeCubit());
    gh.factory<_i43.AuthDatasource>(() => _i43.AuthDatasourceImpl());
    gh.factory<_i976.AuthRepo>(
      () => _i751.AuthRepoImpl(datasource: gh<_i43.AuthDatasource>()),
    );
    gh.factory<_i911.LoginUsecase>(
      () => _i911.LoginUsecase(repo: gh<_i976.AuthRepo>()),
    );
    gh.lazySingleton<_i797.AuthBloc>(
      () => _i797.AuthBloc(gh<_i911.LoginUsecase>()),
    );
    return this;
  }
}
