import 'package:flutter/material.dart';
import 'lost_form_page.dart';
import 'foundformpage.dart';
import 'notification_page.dart';
import 'user_session.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF1E3A8A); // deep blue
    final Color accentBlue = const Color(0xFF2563EB);

    // TODO: replace later with real values from backend
    final int totalLost = 12;
    final int totalFound = 7;
    final int totalPending = 5;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // ---------- Layered blue background shapes ----------
          Positioned(
            top: -120,
            left: -80,
            child: _BlurCircle(
              diameter: 260,
              color: accentBlue.withOpacity(0.35),
            ),
          ),
          Positioned(
            top: 140,
            right: -120,
            child: _BlurCircle(
              diameter: 260,
              color: const Color(0xFF38BDF8).withOpacity(0.35),
            ),
          ),
          Positioned(
            bottom: -160,
            left: -40,
            child: _BlurCircle(
              diameter: 280,
              color: const Color(0xFF6366F1).withOpacity(0.28),
            ),
          ),

          // subtle top gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF020617),
                  const Color(0xFF020617).withOpacity(0.95),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- Header ----------
                  Row(
                    children: [
                      // shield avatar with layered border
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF38BDF8),
                              const Color(0xFF6366F1),
                            ],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFF020617),
                          child: Icon(
                            Icons.shield_moon_outlined,
                            color: const Color(0xFF38BDF8),
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Campus Lost & Found",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Raise a ticket when you lose or find something. Let the system do the matching.",
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Colors.white.withOpacity(0.78),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),

                      // 🔔 Notifications button
                      IconButton(
                        onPressed: () {
                          final contact = UserSession.contact;

                          if (contact == null || contact.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Submit a lost or found ticket first to receive notifications.",
                                ),
                              ),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  NotificationPage(contact: contact),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                        tooltip: "View matches & notifications",
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.06),
                          padding: const EdgeInsets.all(10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ---------- Info chip ----------
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          size: 16,
                          color: Color(0xFF38BDF8),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Honesty first – return what you find 🤝",
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    "What would you like to do?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ---------- Cards list + stats ----------
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _ActionCard(
                          title: "I lost something",
                          subtitle:
                              "Create a lost item ticket so others can help you find it.",
                          icon: Icons.search_off_rounded,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFF97316)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          tag: "Lost ticket",
                          page: const LostFormPage(),
                        ),
                        const SizedBox(height: 18),
                        _ActionCard(
                          title: "I found something",
                          subtitle:
                              "Create a found item ticket so we can find the owner.",
                          icon: Icons.volunteer_activism_rounded,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF22C55E), Color(0xFF4ADE80)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          tag: "Found ticket",
                          page: const FoundFormPage(),
                        ),
                        const SizedBox(height: 26),

                        // --------- Stats section ----------
                        Row(
                          children: [
                            Text(
                              "Today’s overview",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                "demo stats",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                label: "Lost tickets",
                                value: totalLost.toString(),
                                color: const Color(0xFFFB7185),
                                icon: Icons.report_gmailerrorred_rounded,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatCard(
                                label: "Found tickets",
                                value: totalFound.toString(),
                                color: const Color(0xFF4ADE80),
                                icon: Icons.task_alt_rounded,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatCard(
                                label: "Pending",
                                value: totalPending.toString(),
                                color: const Color(0xFF38BDF8),
                                icon: Icons.hourglass_bottom_rounded,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Center(
                          child: Text(
                            "Your one small action can bring someone’s belongings back ✨",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.white.withOpacity(0.75),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // ---------- Notification hint bar ----------
                        Builder(
                          builder: (context) {
                            final contact = UserSession.contact;
                            if (contact == null || contact.isEmpty) {
                              return Container(
                                margin: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 12,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.72),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.08),
                                  ),
                                ),
                                child: const Text(
                                  "Tip: Add your contact while submitting a ticket so we can notify you when a match is found.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------- Blurry circular background shape ----------
class _BlurCircle extends StatelessWidget {
  final double diameter;
  final Color color;

  const _BlurCircle({required this.diameter, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.9),
            blurRadius: 80,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}

// ---------- Big action card ----------
class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final String tag;
  final Widget page;

  const _ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.tag,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.35),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(3, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Small stat card ----------
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF020617).withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
