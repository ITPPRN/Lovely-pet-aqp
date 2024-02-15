class ApiRouter {
  static const String pathAPI = 'https://backend-application.pcnone.com';
  //static const String pathAPI = 'http://192.168.33.124:8080';
}

class SubPath {
  static const String getListHotelImage = '/hotel/get-images-url';

  static const String history = '/service-history/list-service-history';

  static const String reserve = '/booking/reserve';

  static const String userRegister = '/user/register';

  static const String uploadImageUserRegister = '/user/upload-image-register';

  static const String uploadSlip = '/booking/upload-slip';

  static const String getBookingList = '/booking/list-booking-all-for-user';

  static const String getListRoomImage = '/room/get-images-url';

  static const String addPet = '/pet/add-pet';

  static const String uploadImagePet = '/pet/upload-image';

  static const String getPetImage = '/pet/get-images';

  static const String getMyPet = '/pet/get-my-pet';

  static const String getMyProfile = '/user/profile';

  static const String getAdditionalService =
      '/additional-service/list-service-for-user';

  static const String getRoomImage = '/room/get-images';

  static const String getHotelList = '/hotel/list-hotel-to-service';

  static const String getHotelImage = '/hotel/get-images';

  static const String refreshToken = '/user/refresh-token';

  static const String login = '/user/login';

  static const String review = '/review/review';
  static const String listReview = '/review/list-review';

  static const String cancel = '/booking/cancel';
}
