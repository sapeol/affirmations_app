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
                  const Color(0xFFE0F0FF)
                ),
                const SizedBox(height: 32),
                _buildStatSection(
                  context, 
                  "Stubbornness", 
                  data['quit'] == 'NO' ? "Maxed Out" : "Failing", 
                  Icons.spa_rounded,
                  const Color(0xFFFFE0E0)
                ),
                const SizedBox(height: 32),
                _buildStatSection(
                  context, 
                  "Net Delusion", 
                  "STEADY", 
                  Icons.blur_on_rounded,
                  const Color(0xFFE0FFE0)
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          week.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 6,
            fontWeight: FontWeight.w200,
            color: isDark ? Colors.white24 : Colors.black38,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Your Weekly Receipt",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w300,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildStatSection(BuildContext context, String title, String value, IconData icon, Color basePastel) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayPastel = isDark ? Color.lerp(basePastel, Colors.black, 0.7)! : basePastel;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: displayPastel.withValues(alpha: isDark ? 0.3 : 0.5),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: displayPastel.withValues(alpha: isDark ? 0.5 : 0.8)),
      ),
      child: Row(
        children: [
          Icon(icon, color: isDark ? Colors.white24 : Colors.black26, size: 32),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white38 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: isDark ? Colors.white70 : Colors.black87,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        children: [
          Icon(Icons.wb_sunny_outlined, size: 32, color: isDark ? Colors.white10 : Colors.black12),
          const SizedBox(height: 24),
          Text(
            "Another week of pretending.\nGood job, I guess.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white24 : Colors.black45,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
