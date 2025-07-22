class ApiEndpoint {
  static const String mainBase = 'http://31.220.31.202:5000';

  static const String baseUrl = 'http://31.220.31.202:5000/api';

  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/user/create-user';
  static const String forgotPassword = '$baseUrl/auth/forgot-password-request';
  static const String verifyOtp = '$baseUrl/auth/verify-user';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String updatePassword = '$baseUrl/auth/update-password';
  static const String saveFixedData =
      '$baseUrl/user-expense-plan/add-expense-plan';

  static const String getPresentMonth =
      '$baseUrl/finance-report/get-present-month-summary';
  static const String getCoursesList = '$baseUrl/course?limit=5';

  static const String addIncomeData = '$baseUrl/income/add-income';
  static const String addExpenseData = '$baseUrl/expense/add-expense';
  static const String getNotification = '$baseUrl/notifications';

  static const String getProfile = '$baseUrl/auth/me';
  static const String updateProfile =
      '$baseUrl/user-profile/update-profile-data';
  static const String getDailyIncome =
      '$baseUrl/income/get-income-data-by-date';
  static const String getDailyExpense =
      '$baseUrl/expense/get-expense-data-by-date';

  static const getDaily = '$baseUrl/finance-report/get-daily-summary';
  static const getWeek = '$baseUrl/finance-report/get-weekly-summary';
  static const getMonthly = '$baseUrl/finance-report/get-present-month-summary';

  static const getDailyCash =
      '$baseUrl/finance-report/get-daily-summary?page=1&method=cash';

  static const getDailyCard =
      '$baseUrl/finance-report/get-daily-summary?page=1&method=card';

  static const getWeeklyCash =
      '$baseUrl/finance-report/get-weekly-summary?method=cash';
  static const getWeeklyCard =
      '$baseUrl/finance-report/get-weekly-summary?method=card';
  static const getWeekly = '$baseUrl/finance-report/get-weekly-summary';

  static const chat = '$baseUrl/finance-report/get-finanse-data-from-ai';

  static const getReportCategory =
      '$baseUrl/finance-report/get-present-month-expance-with-category-percent';

  static const addExpenseVoice = '$baseUrl/expense/add-expense-by-voice';
}
