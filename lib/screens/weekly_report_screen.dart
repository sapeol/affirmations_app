import 'package:flutter/material.dart';
import '../services/receipt_service.dart';
import '../locator.dart';

class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("EXPOSURE"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: locator<ReceiptService>().generateWeeklyReceipt(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, data['week']),
                const SizedBox(height: 60),
                _buildStatSection(
                  context, 
                  "Time Wasted", 
                  data['showed_up'], 
                  Icons.auto_awesome_outlined,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                ),
                const SizedBox(height: 32),
                _buildStatSection(
                  context, 
                  "Stubbornness", 
                  data['quit'] == 'NO' ? "Maxed Out" : "Failing", 
                  Icons.spa_rounded,
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1)
                ),
                const SizedBox(height: 32),
                _buildStatSection(
                  context, 
                  "Net Delusion", 
                  "STEADY", 
                  Icons.blur_on_rounded,
                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1)
                ),
                const SizedBox(height: 80),
                _buildClosing(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String week) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          week.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 6, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
        ),
        const SizedBox(height: 12),
        Text(
          "Your Weekly Receipt",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildStatSection(BuildContext context, String title, String value, IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1), width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), size: 32),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 2,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClosing(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.wb_sunny_outlined, size: 32, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2)),
          const SizedBox(height: 24),
          Text(
            "Another week of pretending.\nGood job, I guess.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
