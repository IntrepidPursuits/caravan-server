UNPROCESSABLE_ENTITY_ERRORS =
  [ActiveRecord::RecordInvalid,
    CarNotInTransit,
    InvalidCarCreation,
    InvalidCarJoin,
    InvalidInviteCodeError,
    UnauthorizedGoogleAccess,
    UnauthorizedTwitterAccess,
    UserOwnsCarError]

BAD_REQUEST_ERRORS =
[ActionController::ParameterMissing,
  ArgumentError,
  MissingInviteCodeError,
  MissingSignup]
