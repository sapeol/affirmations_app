import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import '../services/streak_service.dart';
import '../locator.dart';

class StreakDetailScreen extends StatelessWidget {
  const StreakDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SYSTEM UPTIME")),
      body: FutureBuilder<UserPreferences>(
        future: UserPreferences.load(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final prefs = snapshot.data!;
          final streak = prefs.sanityStreak;
          final msg = locator<StreakService>().getStreakMessage(streak, false);

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMetricCard(context, "CURRENT UPTIME", "$streak DAYS"),
                const SizedBox(height: 16),
                _buildMessageCard(context, msg),
                const SizedBox(height: 32),
                Text(
                  "HISTORY LOG",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildHistoryList(context, prefs),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      child: Column(
        children: [
          Icon(Icons.timer_rounded, size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 32),
          ),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.outline,
              letterSpacing: 2,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          const Text("SYSTEM STATUS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 12),
          Text(
            '"$message"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context, UserPreferences prefs) {
    // Determine start date
    final firstRun = DateTime.tryParse(prefs.firstRunDate) ?? DateTime.now();
    final today = DateTime.now();
    final totalDays = today.difference(firstRun).inDays + 1;

    return ListView.builder(
      itemCount: totalDays,
      itemBuilder: (context, index) {
        // Show last 30 days or so, reverse order
        final day = today.subtract(Duration(days: index));
        final isToday = index == 0;
        final isActive = isToday && prefs.sanityStreak > 0; // Simplified logic for demo

        return ListTile(
          dense: true,
          leading: Icon(
            isActive ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: isActive ? Colors.greenAccent : Theme.of(context).colorScheme.outlineVariant,
            size: 16,
          ),
          title: Text(
            "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}",
            style: const TextStyle(fontFamily: 'Courier'),
          ),
          trailing: Text(
            isActive ? "ACTIVE" : "OFFLINE",
            style: TextStyle(
              fontSize: 10,
              color: isActive ? Colors.greenAccent : Theme.of(context).colorScheme.outline,
            ),
          ),
        );
      },
    );
  }
}
