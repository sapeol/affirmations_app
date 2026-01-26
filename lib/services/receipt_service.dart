import '../models/user_preferences.dart';

class ReceiptService {
  Future<Map<String, dynamic>> generateWeeklyReceipt() async {
    final prefs = await UserPreferences.load();
    
    // Simulate data for demo purposes since we don't have full history tracking yet
    // In a real app, we'd query a database for this week's activity
    final streak = prefs.sanityStreak;
    final load = prefs.systemLoad;
    
    return {
      'week': 'WEEK ${DateTime.now().difference(DateTime(2025, 1, 1)).inDays ~/ 7}',
      'showed_up': '$streak days',
      'overthought': load > 0.6 ? 'YES' : 'NO',
      'quit': 'NO',
      'net_result': 'PROGRESS',
    };
  }

  String formatReceipt(Map<String, dynamic> data) {
    return """
    -------------------------
    ${data['week']} RECEIPT
    -------------------------
    SHOWED UP:   ${data['showed_up']}
    OVERTHOUGHT: ${data['overthought']}
    QUIT:        ${data['quit']}
    -------------------------
    NET RESULT:  ${data['net_result']}
    -------------------------
    """;
  }
}
