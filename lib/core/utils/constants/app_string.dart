class AppStrings{
  static final AppStrings _instance = AppStrings._internal();

  factory AppStrings(){
    return _instance;
  }

  AppStrings._internal();

  //network repository
  static String somethingWentWrong = "Something went wrong";
  static String authError = "Unauthorized";
  static String checkInternet = "Check your internet connection";

  static String selectSchoolType = "Select Your Institution Type";
  static String selectSchool = "Select School";
  static String recent = "RECENT";
  static String keyWord = "KEYWORD";
  static String helpTogether = "Let\'s help together in this";
  static String schoolManagement = 'School\nManagement\nSystem!';
  static String loginTypeSelectionDescription = 'We provide school administration faster and easyers. It makes communication between parents, teachers, and students faster and more effective.';
  static String chooseCategory = "Choose your category";

  static String welcomeBack = "Welcome Back!";
  static String signInTo = "Sign in to Educare ERP.";
  static String forgotPassword = "Forgot Password?";
  static String cafeteriaLogin = "Login as cafeteria?";
  static String click = " Click Here";


  static String educareErp = "Educare ERP";




}