# 💻 Code Examples & Usage Guide

## Login Implementation

### Example 1: Basic Login
```dart
// In your LoginScreen
final email = 'user@example.com';
final password = 'password123';

// Method 1: Using LoginCubit (Recommended)
context.read<LoginCubit>().login(email, password);

// Method 2: Direct API call
final apiService = ApiService();
final user = await apiService.loginUser(email, password);
if (user != null) {
  await SessionService.saveUserId(user['id']);
  // Navigate to home
}
```

### Example 2: Login with Error Handling
```dart
Future<void> performLogin(String email, String password) async {
  try {
    emit(const LoginLoading());
    
    final user = await _authRepository.login(email, password);
    
    if (user == null) {
      emit(const LoginFailure('Invalid email or password'));
      return;
    }
    
    emit(LoginSuccess(user));
  } catch (e) {
    emit(LoginFailure('Login failed: ${e.toString()}'));
  }
}
```

### Example 3: Login Form Validation
```dart
bool validateEmail(String email) {
  return email.contains('@') && email.isNotEmpty;
}

bool validatePassword(String password) {
  return password.length >= 6;
}

void onLoginPressed() {
  if (!validateEmail(_emailController.text)) {
    showError('Invalid email');
    return;
  }
  
  if (!validatePassword(_passwordController.text)) {
    showError('Password must be at least 6 characters');
    return;
  }
  
  context.read<LoginCubit>().login(
    _emailController.text,
    _passwordController.text,
  );
}
```

---

## Signup Implementation

### Example 1: Basic Signup
```dart
// In your SignUpScreen
final userData = {
  'email': _emailController.text,
  'username': _usernameController.text,
  'password': _passwordController.text,
  'name': _nameController.text,
  'lastname': _lastnameController.text,
};

context.read<SignupCubit>().signup(userData);
```

### Example 2: Signup with Validation
```dart
bool validateSignupData(Map<String, String> data) {
  if (data['email']!.isEmpty || !data['email']!.contains('@')) {
    return false;
  }
  if (data['username']!.isEmpty || data['username']!.length < 3) {
    return false;
  }
  if (data['password']!.isEmpty || data['password']!.length < 6) {
    return false;
  }
  if (data['name']!.isEmpty) {
    return false;
  }
  return true;
}

Future<void> performSignup(Map<String, String> userData) async {
  if (!validateSignupData(userData)) {
    emit(const SignupFailure('Please fill in all fields correctly'));
    return;
  }
  
  emit(const SignupLoading());
  
  try {
    final user = await _authRepository.signup(userData);
    
    if (user == null) {
      emit(const SignupFailure('Failed to create account'));
      return;
    }
    
    emit(SignupSuccess(user));
  } catch (e) {
    emit(SignupFailure(e.toString()));
  }
}
```

### Example 3: Password Confirmation
```dart
bool validatePasswordMatch(String password, String confirmPassword) {
  return password == confirmPassword;
}

void onSignupPressed() {
  if (!validatePasswordMatch(
    _passwordController.text,
    _confirmPasswordController.text,
  )) {
    showError('Passwords do not match');
    return;
  }
  
  // Proceed with signup
  context.read<SignupCubit>().signup(userData);
}
```

---

## API Service Usage

### Example 1: Fetching Events
```dart
Future<List<Event>> fetchEvents() async {
  try {
    final apiService = ApiService();
    final data = await apiService.getEvents();
    
    return data.map<Event>((json) => Event.fromJson(json)).toList();
  } catch (e) {
    print('Error fetching events: $e');
    return [];
  }
}
```

### Example 2: Fetching Single Event
```dart
Future<Event?> fetchEventDetails(int eventId) async {
  try {
    final apiService = ApiService();
    final data = await apiService.getEvent(eventId);
    
    if (data == null) return null;
    
    return Event.fromJson(data);
  } catch (e) {
    print('Error fetching event: $e');
    return null;
  }
}
```

### Example 3: Creating Event
```dart
Future<Event?> createEvent({
  required String title,
  required String description,
  required String date,
  required String location,
}) async {
  try {
    final apiService = ApiService();
    
    final eventData = {
      'title': title,
      'description': description,
      'date': date,
      'location': location,
    };
    
    final data = await apiService.createEvent(eventData);
    
    if (data == null) return null;
    
    return Event.fromJson(data);
  } catch (e) {
    print('Error creating event: $e');
    return null;
  }
}
```

---

## Session Management

### Example 1: Save User Session
```dart
Future<void> saveUserSession(User user) async {
  // Save user ID
  await SessionService.saveUserId(user.id);
  
  // Optionally save other data
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_email', user.email);
  await prefs.setString('user_name', user.fullName);
}
```

### Example 2: Check if User is Logged In
```dart
Future<bool> checkUserLoggedIn() async {
  final isLoggedIn = await SessionService.isLoggedIn();
  return isLoggedIn;
}

Future<void> initializeApp() async {
  final isLoggedIn = await checkUserLoggedIn();
  
  if (isLoggedIn) {
    // Navigate to home
    Navigator.of(context).pushReplacementNamed('/home');
  } else {
    // Navigate to login
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
```

### Example 3: Get Current User Data
```dart
Future<User?> getCurrentUserData() async {
  final userId = await SessionService.getUserId();
  
  if (userId == null) return null;
  
  final apiService = ApiService();
  final data = await apiService.getUser(userId);
  
  if (data == null) return null;
  
  return User.fromJson(data);
}
```

### Example 4: Logout User
```dart
Future<void> logoutUser() async {
  // Clear session
  await SessionService.clearSession();
  
  // Clear any cached data
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  
  // Navigate to login
  Navigator.of(context).pushReplacementNamed('/login');
}
```

---

## User Profile Management

### Example 1: Update User Profile
```dart
Future<bool> updateUserProfile({
  required int userId,
  required String name,
  required String lastname,
  String? dateOfBirth,
  String? photo,
}) async {
  try {
    final apiService = ApiService();
    
    final data = {
      'name': name,
      'lastname': lastname,
    };
    
    if (dateOfBirth != null) {
      data['date_of_birth'] = dateOfBirth;
    }
    
    if (photo != null) {
      data['photo'] = photo;
    }
    
    final success = await apiService.updateUser(userId, data);
    
    return success;
  } catch (e) {
    print('Error updating profile: $e');
    return false;
  }
}
```

### Example 2: Change User Password
```dart
Future<bool> changePassword({
  required int userId,
  required String currentPassword,
  required String newPassword,
}) async {
  try {
    // First verify current password
    final email = await getStoredEmail(); // From preferences
    final user = await ApiService().loginUser(email, currentPassword);
    
    if (user == null) {
      print('Current password is incorrect');
      return false;
    }
    
    // Update password
    final success = await ApiService().updateUser(userId, {
      'password': newPassword,
    });
    
    return success;
  } catch (e) {
    print('Error changing password: $e');
    return false;
  }
}
```

---

## Error Handling

### Example 1: Handle API Errors
```dart
Future<dynamic> safeApiCall(Future<dynamic> Function() call) async {
  try {
    return await call();
  } on SocketException {
    throw 'No internet connection';
  } on TimeoutException {
    throw 'Request timeout - please try again';
  } catch (e) {
    if (e.toString().contains('401')) {
      throw 'Invalid credentials';
    } else if (e.toString().contains('400')) {
      throw 'Invalid request data';
    } else if (e.toString().contains('404')) {
      throw 'Resource not found';
    } else {
      throw 'An error occurred: $e';
    }
  }
}
```

### Example 2: Show Error Message
```dart
void showErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}
```

### Example 3: Handle Success Message
```dart
void showSuccessMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    ),
  );
}
```

---

## Event Management

### Example 1: Add Event to Favorites
```dart
Future<bool> addEventToFavorites(int eventId) async {
  try {
    final apiService = ApiService();
    final response = await apiService.addFavorite(eventId);
    
    return response != null;
  } catch (e) {
    print('Error adding to favorites: $e');
    return false;
  }
}
```

### Example 2: Remove Event from Favorites
```dart
Future<bool> removeEventFromFavorites(int favoriteId) async {
  try {
    final apiService = ApiService();
    await apiService.removeFavorite(favoriteId);
    
    return true;
  } catch (e) {
    print('Error removing from favorites: $e');
    return false;
  }
}
```

### Example 3: Get User's Favorite Events
```dart
Future<List<Event>> getUserFavorites() async {
  try {
    final apiService = ApiService();
    final data = await apiService.getFavorites();
    
    return data.map<Event>((json) => Event.fromJson(json)).toList();
  } catch (e) {
    print('Error fetching favorites: $e');
    return [];
  }
}
```

---

## Testing Examples

### Example 1: Unit Test for Login
```dart
void main() {
  group('LoginCubit', () {
    late LoginCubit loginCubit;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      loginCubit = LoginCubit(mockAuthRepository);
    });

    test('emits [LoginLoading, LoginSuccess] when login is successful', () async {
      final user = User(
        id: 1,
        email: 'test@example.com',
        username: 'testuser',
        name: 'Test',
        lastname: 'User',
      );

      when(mockAuthRepository.login('test@example.com', 'password123'))
          .thenAnswer((_) async => user);

      expect(
        loginCubit.stream,
        emitsInOrder([
          const LoginLoading(),
          LoginSuccess(user),
        ]),
      );

      await loginCubit.login('test@example.com', 'password123');
    });
  });
}
```

### Example 2: Integration Test
```dart
void main() {
  group('Authentication Flow', () {
    testWidgets('Login screen navigates to home on successful login',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byType(LoginScreen), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(HomeApp), findsOneWidget);
    });
  });
}
```

---

## Database Queries (Backend)

### Example 1: Check User Login
```python
# In Django views.py
def loginUser(request):
    email = request.data.get('email')
    password = request.data.get('password')
    
    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({'error': 'Invalid email or password'}, status=401)
    
    if user.check_password(password):
        return Response(UserSerializer(user).data)
    else:
        return Response({'error': 'Invalid email or password'}, status=401)
```

### Example 2: Create New User
```python
def createUser(request):
    email = request.data.get('email')
    username = request.data.get('username')
    password = request.data.get('password')
    
    # Check duplicates
    if User.objects.filter(email=email).exists():
        return Response({'error': 'Email already exists'}, status=400)
    
    if User.objects.filter(username=username).exists():
        return Response({'error': 'Username already exists'}, status=400)
    
    # Create user
    user = User.objects.create_user(
        email=email,
        username=username,
        password=password,
        name=request.data.get('name', ''),
        lastname=request.data.get('lastname', ''),
    )
    
    return Response(UserSerializer(user).data, status=201)
```

---

## Tips & Best Practices

### 1. Always Handle Errors
```dart
try {
  // API call
} catch (e) {
  // Handle error gracefully
  showErrorMessage(context, 'An error occurred: $e');
}
```

### 2. Show Loading State
```dart
BlocListener<LoginCubit, LoginState>(
  listener: (context, state) {
    if (state is LoginLoading) {
      // Show loading indicator
    }
  },
)
```

### 3. Validate User Input
```dart
if (email.isEmpty || !email.contains('@')) {
  showErrorMessage(context, 'Invalid email format');
  return;
}
```

### 4. Cache User Data Locally
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setString('user_data', jsonEncode(user.toJson()));
```

### 5. Use Environment Variables for URLs
```dart
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://event-anouncement-app-production.up.railway.app'
);
```

---

## Common Issues & Solutions

### Issue: "Network Error"
```dart
// Solution: Check connectivity first
import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> hasInternet() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}
```

### Issue: "Request Timeout"
```dart
// Solution: Set timeout for HTTP requests
final client = http.Client();
final response = await client.get(uri).timeout(
  const Duration(seconds: 10),
  onTimeout: () => throw TimeoutException('Request timeout'),
);
```

### Issue: "Invalid JSON Response"
```dart
// Solution: Validate response format
dynamic parseResponse(String responseBody) {
  try {
    return json.decode(responseBody);
  } catch (e) {
    throw FormatException('Invalid JSON response: $e');
  }
}
```

---

This guide covers all common scenarios and best practices for using the Eventify API!
