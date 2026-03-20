import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/book_model.dart';
import '../providers/book_provider.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;

  const AddEditBookScreen({super.key, this.book});

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final title = TextEditingController();
  final author = TextEditingController();
  final isbn = TextEditingController();
  final quantity = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.book != null) {
      title.text = widget.book!.title;
      author.text = widget.book!.author;
      isbn.text = widget.book!.isbn;
      quantity.text = widget.book!.quantity.toString();
    }
  }

  @override
  void dispose() {
    title.dispose();
    author.dispose();
    isbn.dispose();
    quantity.dispose();
    super.dispose();
  }

  String generateBookId() {
    return '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(999)}';
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<BookProvider>();

    final book = Book(
      id: widget.book?.id ?? generateBookId(),
      title: title.text.trim(),
      author: author.text.trim(),
      isbn: isbn.text.trim(),
      quantity: int.parse(quantity.text.trim()),
      isIssued: widget.book?.isIssued ?? false,
    );

    if (widget.book == null) {
      await provider.addBook(book);
    } else {
      await provider.updateBook(widget.book!.id, book);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.book == null
              ? 'Book saved successfully!'
              : 'Book updated successfully!',
        ),
        backgroundColor: const Color(0xff1DBA7B),
        behavior: SnackBarBehavior.floating,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _showSavePopup() async {
    if (!_formKey.currentState!.validate()) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            widget.book == null ? 'Save Book?' : 'Update Book?',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff1D2939),
            ),
          ),
          content: Text(
            widget.book == null
                ? 'Do you want to save this book to library?'
                : 'Do you want to update this book?',
            style: const TextStyle(
              color: Color(0xff667085),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xff667085)),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1DBA7B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _saveBook();
    }
  }

  Widget _label(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Color(0xff98A2B3),
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xff1D2939),
        fontWeight: FontWeight.w500,
      ),
      validator: (value) {
        final text = value?.trim() ?? '';

        if (text.isEmpty) {
          return '$label is required';
        }

        if (label == 'ISBN-13') {
          if (!RegExp(r'^\d+$').hasMatch(text)) {
            return 'ISBN must contain numbers only';
          }
        }

        if (label == 'Quantity') {
          if (int.tryParse(text) == null) {
            return 'Enter valid quantity';
          }
          if (int.parse(text) <= 0) {
            return 'Quantity must be greater than 0';
          }
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xff98A2B3),
          fontSize: 13,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xffAEB8C5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xff1DBA7B),
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xffF3FBF8);
    const primary = Color(0xff1DBA7B);
    const titleColor = Color(0xff101828);
    const subtitleColor = Color(0xff98A2B3);
    const cardColor = Colors.white;
    const borderColor = Color(0xffEEF2F6);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xffEDF2F7)),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: titleColor,
                    ),
                    tooltip: 'Back',
                  ),
                  const SizedBox(width: 4),
                  Row(
                    children: [
                      Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Library Manager',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: titleColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'notification',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xff344054),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xffF5E7D8),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xff8D6D4B),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 18),
                child: Column(
                  children: [
                    Text(
                      widget.book == null
                          ? 'Add Collection'
                          : 'Update Collection',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.book == null
                          ? 'Add new arrivals or create publication metadata.'
                          : 'Add new arrivals or edit existing publication metadata.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: subtitleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 26),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: _label('Book Title'),
                              ),
                              const SizedBox(height: 8),
                              _inputField(
                                controller: title,
                                hint: 'e.g. The Midnight Library',
                                label: 'Book Title',
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('Author Name'),
                                        const SizedBox(height: 8),
                                        _inputField(
                                          controller: author,
                                          hint: 'e.g. Matt Haig',
                                          label: 'Author Name',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('ISBN-13'),
                                        const SizedBox(height: 8),
                                        _inputField(
                                          controller: isbn,
                                          hint: '9780255559474',
                                          label: 'ISBN-13',
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: _label('Quantity'),
                              ),
                              const SizedBox(height: 8),
                              _inputField(
                                controller: quantity,
                                hint: 'Available copies',
                                label: 'Quantity',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                              const SizedBox(height: 28),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton.icon(
                                  onPressed: _showSavePopup,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 6,
                                    shadowColor: primary.withValues(alpha: 0.30),
                                    backgroundColor: primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.save_outlined,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    widget.book == null
                                        ? 'Save Book to Library'
                                        : 'Update Book in Library',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Discard Changes',
                                  style: TextStyle(
                                    color: Color(0xff98A2B3),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Wrap(
                      spacing: 18,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: Color(0xff86EFAC),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'AUTO-SAVING ACTIVE',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xff98A2B3),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.cloud_done,
                              size: 14,
                              color: Color(0xff1DBA7B),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'DATABASE CONNECTED',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xff98A2B3),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 34),
                    const Text(
                      '© 2024 Liquid Library Management Systems. Designed for premium performance.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xff98A2B3),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
