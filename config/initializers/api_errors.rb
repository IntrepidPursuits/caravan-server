UNPROCESSABLE_ENTITY_ERRORS =
  [ActiveRecord::RecordInvalid,
    CarNotStartedError,
    InvalidCarCreation,
    InvalidCarJoin,
    InvalidInviteCodeError,
    UnauthorizedAccess]

BAD_REQUEST_ERRORS =
[ActionController::ParameterMissing,
  ArgumentError,
  MissingInviteCodeError,
  MissingSignup]
