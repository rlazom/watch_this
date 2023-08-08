enum FilterMapEntryKey {
  FULL_TEXT,
  CATEGORY_NAME,
  PROGRAM_NAME,
  MONTH_YEAR_DATE,
  MONTH_DATE,
  YEAR_DATE,
}

enum DirectoryType {
  CACHE,
  APP_DOCUMENTS,
}

enum SourceType {
  LOCAL,
  REMOTE,
}

enum SmoothButtonTheme {
  BLUE,
  YELLOW,
  GREEN,
  RED,
}

enum ButtonStatus {
  active,
  inactive,
  disabled,
}

enum AuthError {
  forbiddenService,
  invalidEmail,
  userDisabled,
  userNotFound,
  wrongPassword,
  emailNotVerified,
  emailAlreadyInUse,
  invalidCredential,
  operationNotAllowed,
  weakPassword,
  error,
}

enum SignType {
  none,
  createAccount,
  signIn,
  signOut,
  forgotPassword,
}

enum TopProvider {
  netflix,
  amazon,
  google,
  apple,
  disney,
}

enum MediaType {
  movie,
  person,
  tv,
}