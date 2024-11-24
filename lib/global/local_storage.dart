import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';

class LocalStorage extends GetxService{
  static const _LANG_ID = 'lang_id';
  static const _OTP_EXPIRED_DATE = "otp_expired_date";
  static const _MEMBER_CODE = "member_code";

  Future<LocalStorage> init() async {
    await SpUtil.getInstance();
    return this;
  }

  Future setLangId(String? langId) async {
    await SpUtil.putString(_LANG_ID, langId ?? '');
  }

  String get langId {
    return SpUtil.getString(_LANG_ID, defValue: 'en')!;
  }

  Future setMemberCode(String? memberCode) async {
    await SpUtil.putString(_MEMBER_CODE, memberCode ?? '');
  }

  String get memberCode {
    return SpUtil.getString(_MEMBER_CODE)!;
  }

  Future setOtpExpiredDate(int? timeStamp) async {
    await SpUtil.putInt(_OTP_EXPIRED_DATE, timeStamp ?? 0);
  }

  int get otpExpiredDate {
    return SpUtil.getInt(_OTP_EXPIRED_DATE, defValue: 0)!;
  }

  clear() async {
    await SpUtil.remove(_OTP_EXPIRED_DATE);
    await SpUtil.remove(_MEMBER_CODE);
  }
}