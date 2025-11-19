import 'package:flutter/material.dart';
import 'api_client.dart';
import 'user_session.dart';

class LostFormPage extends StatefulWidget {
  const LostFormPage({super.key});

  @override
  State<LostFormPage> createState() => _LostFormPageState();
}

class _LostFormPageState extends State<LostFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String? _category;
  DateTime? _lostDate;

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _lostDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _lostDate = picked);
    }
  }

  Future<void> _submitFire() async {
    final success = await ApiClient.submitLost({
      "title": _itemNameController.text.trim(),
      "itemName": _itemNameController.text.trim(),
      "category": _category,
      "description": _descriptionController.text.trim(),
      "city": _locationController.text.trim(),
      "location": _locationController.text.trim(),
      "lostDate": _lostDate?.toIso8601String(),
      "dateLost": _lostDate?.toIso8601String(),
      "contact": _contactController.text.trim(),
    });

    if (!mounted) return;

    if (success) {
      UserSession.contact = _contactController.text.trim();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✔ Lost ticket submitted!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to submit! Try again.")),
      );
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_lostDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select the lost date")),
      );
      return;
    }
    await _submitFire();
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF325D79);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, primary.withOpacity(0.9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(26),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.08),
                    ),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Report a lost item",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.search_off_rounded, color: Colors.white),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _itemNameController,
                              label: "Item name *",
                              hint: "e.g. Wallet, Phone, ID card",
                              icon: Icons.label_important_outline_rounded,
                              validator: (v) =>
                                  v!.isEmpty ? "Please enter item name" : null,
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              decoration: _fieldDecoration(
                                label: "Category *",
                                icon: Icons.category_outlined,
                              ),
                              value: _category,
                              items: const [
                                DropdownMenuItem(
                                  value: "Electronics",
                                  child: Text("Electronics"),
                                ),
                                DropdownMenuItem(
                                  value: "Documents",
                                  child: Text("Documents"),
                                ),
                                DropdownMenuItem(
                                  value: "Accessories",
                                  child: Text("Accessories"),
                                ),
                                DropdownMenuItem(
                                  value: "Bag",
                                  child: Text("Bag"),
                                ),
                                DropdownMenuItem(
                                  value: "Other",
                                  child: Text("Other"),
                                ),
                              ],
                              onChanged: (v) => setState(() => _category = v),
                              validator: (v) =>
                                  v == null ? "Select category" : null,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _descriptionController,
                              label: "Description *",
                              hint: "Describe the item & any unique marks",
                              icon: Icons.description_outlined,
                              maxLines: 3,
                              validator: (v) =>
                                  v!.isEmpty ? "Enter description" : null,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _locationController,
                              label: "Last seen location *",
                              hint: "e.g. Library, CSE Block, Parking area",
                              icon: Icons.location_on_outlined,
                              validator: (v) =>
                                  v!.isEmpty ? "Enter location" : null,
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: _pickDate,
                              child: InputDecorator(
                                decoration: _fieldDecoration(
                                  label: "Date lost *",
                                  icon: Icons.calendar_today_rounded,
                                ),
                                child: Text(
                                  _lostDate == null
                                      ? "Tap to select date"
                                      : "${_lostDate!.day.toString().padLeft(2, '0')}-"
                                            "${_lostDate!.month.toString().padLeft(2, '0')}-"
                                            "${_lostDate!.year}",
                                  style: TextStyle(
                                    color: _lostDate == null
                                        ? Colors.grey[500]
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _contactController,
                              label: "Your contact *",
                              hint: "Phone / email (for match alerts)",
                              icon: Icons.phone_iphone_rounded,
                              validator: (v) =>
                                  v!.isEmpty ? "Enter contact info" : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submitForm,
                          icon: const Icon(Icons.send_rounded, size: 18),
                          label: const Text(
                            "Submit lost ticket",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _fieldDecoration(
        label: label,
        icon: icon,
      ).copyWith(hintText: hint),
    );
  }
}
