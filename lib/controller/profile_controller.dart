import 'package:get/get.dart';
import 'package:lottery/controller/base/state_controller.dart';
import 'package:lottery/global/local_storage.dart';
import 'package:lottery/global/secure_local_storage.dart';
import 'package:lottery/model/user_model.dart';
import 'package:lottery/routes/app_routes.dart';
import 'package:lottery/server/api.dart';
import 'package:lottery/server/server_repository.dart';

class ProfileController extends StateController {
  UserModel? _userModel;

  Future<ProfileController> init() async {
    if (Get.find<SecureLocalStorage>().accessToken.isNotEmpty) {
      await refreshProfile(init: true);
    }
    return this;
  }

  refreshProfile({bool init = false}) async {
    var entity = await Get.find<ServerRepository>().loadEntityData<UserModel>(Api.getProfile,
        decoder: (json) => UserModel.fromJson(json)
    );
    if (checkEntity(entity)) {
      await saveProfile(entity.data);
      if (!init) {
        update();
      }
    }
  }

  saveProfile(UserModel? userModel) async {
    await Get.find<SecureLocalStorage>().writeAccessToken(userModel?.profile?.token);
    await Get.find<LocalStorage>().setMemberCode(userModel?.profile?.memberCode);
    this._userModel = userModel;
  }

  clearUser() async {
    await Get.find<SecureLocalStorage>().deleteAccessToken();
    await Get.find<LocalStorage>().clear();
    _userModel = null;
  }

  logout() async {
    showLoading();
    await clearUser();
    stopLoading();
    Get.offAllNamed(AppRoutes.signInPage);
  }
}