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
                    letterSpacing: 4,
                    fontWeight: FontWeight.w900,
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
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.timer_rounded, size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w900, 
              fontSize: 32,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 2,
              fontSize: 10,
              fontWeight: FontWeight.w900,
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
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text("SYSTEM STATUS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4))),
          const SizedBox(height: 12),
          Text(
            '"$message"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context, UserPreferences prefs) {
    final firstRun = DateTime.tryParse(prefs.firstRunDate) ?? DateTime.now();
    final today = DateTime.now();
    final totalDays = today.difference(firstRun).inDays + 1;

    return ListView.builder(
      itemCount: totalDays,
      itemBuilder: (context, index) {
        final day = today.subtract(Duration(days: index));
        final isToday = index == 0;
        final isActive = isToday && prefs.sanityStreak > 0;

        return ListTile(
          dense: true,
          leading: Icon(
            isActive ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: isActive ? Colors.greenAccent : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
            size: 16,
          ),
          title: Text(
            "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}",
            style: TextStyle(
              fontFamily: 'Courier', 
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          trailing: Text(
            isActive ? "ACTIVE" : "OFFLINE",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: isActive ? Colors.greenAccent : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        );
      },
    );
  }
}
