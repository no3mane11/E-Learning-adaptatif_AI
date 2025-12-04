/// Constantes API
class ApiConstants {
  ApiConstants._();

  // Base URL - À configurer selon votre backend
  // Pour le développement local, utilisez: 'http://localhost:3000/api/v1'
  // Pour un backend distant, remplacez par votre URL
  static const String baseUrl = 'http://localhost:3000/api/v1';
  
  // Mode développement - désactive les appels API réels
  static const bool useMockData = true;
  
  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  
  static const String courses = '/courses';
  static const String courseDetails = '/courses/{id}';
  static const String lessons = '/lessons';
  static const String lessonDetails = '/lessons/{id}';
  
  static const String sessions = '/sessions';
  static const String sessionHistory = '/sessions/history';
  static const String sessionDetails = '/sessions/{id}';
  
  static const String emotions = '/emotions';
  static const String emotionAnalysis = '/emotions/analyze';
  
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String recommendations = '/recommendations';
  
  // Professor endpoints
  static const String professorCourses = '/professor/courses';
  static const String professorStudents = '/professor/students';
  static const String professorAnalytics = '/professor/analytics';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}

