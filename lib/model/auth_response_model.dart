class AuthResponseModel {
  String jwtToken;
  String errorMessage;
  bool isSuccess;

  AuthResponseModel(this.jwtToken, this.errorMessage, this.isSuccess);
}
