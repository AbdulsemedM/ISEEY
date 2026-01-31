# Auth Repository

`AuthRepository` handles authentication, device/location updates, and local persistence via `HttpService`.

## Login (`login`)

- Validates email (non-empty, format) and password (non-empty, length ≥ 8).
- POST `users/login` with email, password, `device_token` (FCM), `device_type` (ios/android).
- On success: sets current user ID in `StateManagement`, saves token + user to SharedPreferences, triggers post-login location update with retries.

## Signup (`signup`)

- POST `users/signup` with first_name, last_name, email, password, device_token, device_type.
- On success: sets current user ID and auto-calls `login()` so user is signed in and location flow runs.

## Device & location

- **updateDeviceDetails**: POST `users/updateDeviceDetails` with FCM token and device_type (auth required).
- **updateUserCurrentLocation**: POST `users/updatelatlng` with lat/lng (auth required).
- **Post-login location**: up to 3 retries with exponential backoff; failure does not block login.

## Persistence

- **SharedPreferences**: `isFromLogin`, `token`, and full user JSON under key `userdata` (via `_saveUserData` / `_storeMapData`).

## Dependencies

- `HttpService`, `UserModel`/`UserResult`, `StateManagement`, `GlobalWidgets`, `L10n`, `fcmRegistrationToken` (GlobalVariables).
