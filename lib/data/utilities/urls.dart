class Urls{
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';
  static const String registration = '$_baseUrl/registration';
  static const String login = '$_baseUrl/login';
  static const String createTask = '$_baseUrl/createTask';
  static const String newTask = '$_baseUrl/listTaskByStatus/New';
  static const String completedTask = '$_baseUrl/listTaskByStatus/Completed';
  static const String inProgress = '$_baseUrl/listTaskByStatus/Progress';
  static const String canceled = '$_baseUrl/listTaskByStatus/Canceled';
  static const String taskStatusCount = '$_baseUrl/taskStatusCount';
  static  String deleteTask(String id) => '$_baseUrl/deleteTask/$id';
  static  String updateProfile = '$_baseUrl/profileUpdate';
  static const String updateTask = '$_baseUrl/updateTaskStatus';
  static const String verifyEmail = '$_baseUrl/RecoverVerifyEmail';
  static const String verifyPin = '$_baseUrl/RecoverVerifyOTP';
  static const String resetPass = '$_baseUrl/RecoverResetPass';

}