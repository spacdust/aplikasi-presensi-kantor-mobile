class AppUrl {
  //Base URL localhost
  // static const baseUrl = "http://192.168.1.18:8000/api/";
  // static const baseUrl = "http://192.168.1.20:8000/api/";
  static const baseUrl = "https://kehadiranapp-disbudpar.my.id/api/";

  static const login = "${baseUrl}loginapi";
  static const checkLocation = "${baseUrl}getDistance";
  static const getLocation = "${baseUrl}getLocation";
  static const getHoliday = "${baseUrl}getHoliday";
  static const getHolidayToday = "${baseUrl}getHolidayToday";
  static const getAttendance = "${baseUrl}getByPosition";
  static const getAttendanceById = "${baseUrl}getById";
  static const getPrecenseByAttendance = "${baseUrl}getPresenceNow";
  static const getPrecenseByUser = "${baseUrl}getPresenceByUser";
  static const getPermissionByUser = "${baseUrl}getPermissionByUser";
  static const regisface = "${baseUrl}regisface";
  static const storePresence = "${baseUrl}storePresence";
  static const storePermission = "${baseUrl}storePermission";
  static const updatePassword = "${baseUrl}updatePassword";
}
