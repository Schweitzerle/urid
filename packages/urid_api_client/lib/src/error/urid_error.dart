class URIDError extends Error {
  final String description;
  final String advice;

  URIDError({required this.description, required this.advice}) {}
}

class CouldNotValidateServerIntegrity extends URIDError {
  CouldNotValidateServerIntegrity()
      : super(
            description: "Server integrity could not be validated",
            advice:
                "Do not enter any user credentials. Stop using the wallet app. Immediately inform the support team (digitaler-ausweis@ur.de).");
}

class SessionNotFoundError extends URIDError {
  SessionNotFoundError({required super.description, required super.advice});
}

class SessionNotAvailable extends URIDError {
  SessionNotAvailable({required super.description, required super.advice});
}

class SessionTimeoutError extends URIDError {
  SessionTimeoutError({required super.description, required super.advice});
}

class UserCredentialsMissing extends URIDError {
  UserCredentialsMissing({required super.description, required super.advice});
}

class UserCredentialsInvalid extends URIDError {
  UserCredentialsInvalid({required super.description, required super.advice});
}

class ClientNotAuthenticated extends URIDError {
  ClientNotAuthenticated()
      : super(
            description: "Can not full fill request with unauthenticated client",
            advice: "Login to authenticate client before repeating request");
}
