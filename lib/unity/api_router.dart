class ApiRouter {
  static const String pathAPI = 'https://backend-application.pcnone.com';
  //static const String pathAPI = 'http://192.168.33.124:8080';
}

class SubPath {
  static const String getListHotelImage = '/hotel/get-images-url';

  static const String getListRoomImage = '/room/get-images-url';

  static const String addPet = '/pet/add-pet';

  static const String uploadImagePet = '/pet/upload-image';

  static const String getPetImage = '/pet/get-images';

  static const String getMyPet = '/pet/get-my-pet';

  static const String getRoomImage = '/room/get-images';

  static const String getHotelList = '/hotel/list-hotel-to-service';

  static const String getHotelImage = '/hotel/get-images';

  static const String refreshToken = '/user/refresh-token';

  static const String login = '/user/login';
}
