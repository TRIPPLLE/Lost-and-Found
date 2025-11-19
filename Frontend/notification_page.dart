import 'package:flutter/material.dart';
import 'api_client.dart';

class NotificationPage extends StatefulWidget {
  final String contact;

  const NotificationPage({super.key, required this.contact});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final contact = widget.contact.trim();

    if (contact.isEmpty) {
      setState(() {
        _error = "No contact set. Submit a Lost/Found ticket first.";
        _notifications = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final list = await ApiClient.fetchNotifications(contact);
      setState(() {
        _notifications = list.whereType<Map<String, dynamic>>().toList(
          growable: false,
        );
      });
    } catch (e) {
      setState(() {
        _error = "Failed to load notifications: $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications (${widget.contact})")),
      body: RefreshIndicator(
        onRefresh: _loadNotifications,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(_error!, textAlign: TextAlign.center),
          ),
        ],
      );
    }

    if (_notifications.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 60),
          Center(
            child: Text(
              "No notifications yet.",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final n = _notifications[index];
        return _buildNotificationCard(n);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> n) {
    final message = (n['message'] ?? '') as String;
    final lostTitle = (n['lostTitle'] ?? '') as String;
    final foundTitle = (n['foundTitle'] ?? '') as String;
    final score = n['score'];
    final otherContact = (n['otherContact'] ?? '') as String?;
    final createdAt = n['createdAt'];

    final titles = [
      if (lostTitle.isNotEmpty) "Lost: $lostTitle",
      if (foundTitle.isNotEmpty) "Found: $foundTitle",
    ].join("\n");

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (titles.isNotEmpty)
              Text(
                titles,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            if (message.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(message, style: const TextStyle(fontSize: 13)),
            ],
            if (score != null) ...[
              const SizedBox(height: 4),
              Text(
                "Match score: $score",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
            if (otherContact != null && otherContact.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.phone_iphone_rounded, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Contact them: $otherContact",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (createdAt != null) ...[
              const SizedBox(height: 4),
              Text(
                "Time: $createdAt",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
