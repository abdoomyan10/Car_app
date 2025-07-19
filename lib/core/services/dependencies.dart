import 'package:car_appp/core/services/dependecies.config.dart';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'initGetIt',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  getIt.initGetIt();
}
