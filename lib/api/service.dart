class AppServices {
  static String getBaseUrl() {
    return 'http://192.168.2.7:5000/';
  }

  static String getLoginEndpoint() {
    return '${getBaseUrl()}/login';
  }

  static String getLogoutEndpoint() {
    return '${getBaseUrl()}/logout';
  }

  static String getRegistEndpoint() {
    return '${getBaseUrl()}/register';
  }

  static String getAuthEndpoint() {
    return '${getBaseUrl()}/auth';
  }

  static String getDeteksiEndpoint() {
    return '${getBaseUrl()}/video_feed';
  }

  static String getProfileEndpoint() {
    return '${getBaseUrl()}/profile';
  }

  static String getProtectedEndpoint() {
    return '${getBaseUrl()}/protected';
  }

  static String getUpdatepassEndpoint() {
    return '${getBaseUrl()}/update_password';
  }

  static String getForgotpassEndpoint() {
    return '${getBaseUrl()}/forgot_password';
  }

  static String getEditprofilEndpoint() {
    return '${getBaseUrl()}/edit_profile';
  }

  static String getChangeemailEndpoint() {
    return '${getBaseUrl()}/change_email';
  }

  static String getConfirmemailEndpoint() {
    return '${getBaseUrl()}/confirm_change_email';
  }
}
