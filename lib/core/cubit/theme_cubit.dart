import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(LightTheme());

  setTheme(String theme) async {}

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return json['dark'] == true ? DarkTheme() : LightTheme();
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {'dark': state is DarkTheme ? true : false};
  }
}
