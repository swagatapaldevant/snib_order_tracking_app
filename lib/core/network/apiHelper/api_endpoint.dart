
class ApiEndPoint{

  static final ApiEndPoint _instance = ApiEndPoint._internal();

  factory ApiEndPoint(){
    return _instance;
  }

  ApiEndPoint._internal();

  //static const baseurl = "http://192.168.29.243:8001/api";
  //static const baseurl = "https://thecityofjoy.in/s_and_ib_backend/api";
  static const baseurl = "https://freight.sibservices.in/sib_backend/api";

  //auth module
  static const loginApi =  "/login";
  static const tokenVerify =  "/getLoginUser";

  static const dashboardApi =  "/getTaskForPartner";
  static const getOtp =  "/sendOtp";
  static const verifyOtp =  "/pickupConsignment";
  static const dropOff =  "/dropOffConsignment";
  static const getTaskForPartnerByDate =  "/getTaskForPartnerByDate";






}