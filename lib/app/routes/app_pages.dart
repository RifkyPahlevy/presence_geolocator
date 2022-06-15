import 'package:get/get.dart';

import 'package:precense_geolocator/app/modules/add_pegawai/bindings/add_pegawai_binding.dart';
import 'package:precense_geolocator/app/modules/add_pegawai/views/add_pegawai_view.dart';
import 'package:precense_geolocator/app/modules/all_precense/bindings/all_precense_binding.dart';
import 'package:precense_geolocator/app/modules/all_precense/views/all_precense_view.dart';
import 'package:precense_geolocator/app/modules/detail_precense/bindings/detail_precense_binding.dart';
import 'package:precense_geolocator/app/modules/detail_precense/views/detail_precense_view.dart';
import 'package:precense_geolocator/app/modules/home/bindings/home_binding.dart';
import 'package:precense_geolocator/app/modules/home/views/home_view.dart';
import 'package:precense_geolocator/app/modules/login/bindings/login_binding.dart';
import 'package:precense_geolocator/app/modules/login/views/login_view.dart';
import 'package:precense_geolocator/app/modules/new_password/bindings/new_password_binding.dart';
import 'package:precense_geolocator/app/modules/new_password/views/new_password_view.dart';
import 'package:precense_geolocator/app/modules/profile/bindings/profile_binding.dart';
import 'package:precense_geolocator/app/modules/profile/views/profile_view.dart';
import 'package:precense_geolocator/app/modules/reset_password/bindings/reset_password_binding.dart';
import 'package:precense_geolocator/app/modules/reset_password/views/reset_password_view.dart';
import 'package:precense_geolocator/app/modules/update_password/bindings/update_password_binding.dart';
import 'package:precense_geolocator/app/modules/update_password/views/update_password_view.dart';
import 'package:precense_geolocator/app/modules/update_profile/bindings/update_profile_binding.dart';
import 'package:precense_geolocator/app/modules/update_profile/views/update_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      transition: Transition.fadeIn,
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PEGAWAI,
      page: () => AddPegawaiView(),
      binding: AddPegawaiBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => NewPasswordView(),
      binding: NewPasswordBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_PROFILE,
      page: () => UpdateProfileView(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_PASSWORD,
      page: () => UpdatePasswordView(),
      binding: UpdatePasswordBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PRECENSE,
      page: () => DetailPrecenseView(),
      binding: DetailPrecenseBinding(),
    ),
    GetPage(
      name: _Paths.ALL_PRECENSE,
      page: () => AllPrecenseView(),
      binding: AllPrecenseBinding(),
    ),
  ];
}
