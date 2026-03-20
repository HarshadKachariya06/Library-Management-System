import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';
import '../routes/app_routes.dart';
import 'add_edit_book_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, .05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().loadBooks();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> _getFilteredBooks(BookProvider provider) {
    final query = _searchController.text.trim().toLowerCase();

    return provider.books.where((book) {
      return book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query) ||
          book.isbn.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookProvider>(context);
    final books = _getFilteredBooks(provider);

    const bgColor = Color(0xffF3FBF8);
    const primary = Color(0xff18C37E);
    const titleColor = Color(0xff1D2939);
    const subtitleColor = Color(0xff667085);
    const mutedColor = Color(0xff98A2B3);
    const borderColor = Color(0xffECF1F4);
    const purpleColor = Color(0xff6C63FF);

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
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lumina',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: titleColor,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'LIBRARY OS',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                              color: mutedColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Julian Vane',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                      Text(
                        'ADMINISTRATOR',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: mutedColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "profile") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Profile Clicked")),
                        );
                      } else if (value == "logout") {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "profile",
                        child: Row(
                          children: [
                            Icon(Icons.person_outline),
                            SizedBox(width: 10),
                            Text("Profile"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "logout",
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red),
                            SizedBox(width: 10),
                            Text("Logout"),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xffF5E7D8),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xffEBDCCC)),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xff8D6D4B),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FadeTransition(
                opacity: fadeAnimation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 18,
                        runSpacing: 18,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Global Catalog',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: titleColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Manage ${provider.books.length} books and publications',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: subtitleColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              SizedBox(
                                width: 220,
                                height: 46,
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (_) => setState(() {}),
                                  decoration: InputDecoration(
                                    hintText: 'Search title, author or ISBN...',
                                    hintStyle: const TextStyle(
                                      fontSize: 12,
                                      color: mutedColor,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      size: 18,
                                      color: mutedColor,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(999),
                                      borderSide: const BorderSide(
                                        color: borderColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(999),
                                      borderSide: const BorderSide(
                                        color: primary,
                                        width: 1.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 46,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.addBook,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 8,
                                    shadowColor:
                                        primary.withValues(alpha: 0.30),
                                    backgroundColor: primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text(
                                    'Add Book',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      provider.isLoading
                          ? const Padding(
                              padding: EdgeInsets.only(top: 80),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : books.isEmpty
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 70,
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: const Column(
                                    children: [
                                      Icon(
                                        Icons.menu_book_rounded,
                                        size: 60,
                                        color: Color(0xffB8C1CC),
                                      ),
                                      SizedBox(height: 14),
                                      Text(
                                        'No Books Found',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: titleColor,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Try searching something else or add a new book.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: subtitleColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children:
                                      List.generate(books.length, (index) {
                                    final book = books[index];

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.95,
                                        ),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: const Color(0xffEEF2F6),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 42,
                                            width: 42,
                                            decoration: BoxDecoration(
                                              color: purpleColor,
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: purpleColor.withValues(
                                                    alpha: 0.20,
                                                  ),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.menu_book_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  book.title,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w800,
                                                    color: titleColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  book.author,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: subtitleColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 4,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    Text(
                                                      'ISBN: ${book.isbn}',
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: mutedColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const Text(
                                                      '|',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffD0D5DD),
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Qty: ${book.quantity}',
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: mutedColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const Text(
                                                      '|',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffD0D5DD),
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: book.isIssued
                                                            ? const Color(
                                                                0xffFEF3F2)
                                                            : const Color(
                                                                0xffECFDF3),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          999,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        book.isIssued
                                                            ? 'Issued'
                                                            : 'Available',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: book.isIssued
                                                              ? const Color(
                                                                  0xffD92D20)
                                                              : const Color(
                                                                  0xff039855),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _actionButton(
                                                icon: book.isIssued
                                                    ? Icons.undo_rounded
                                                    : Icons
                                                        .arrow_outward_rounded,
                                                bgColor: const Color(
                                                  0xffEEF4FF,
                                                ),
                                                iconColor: const Color(
                                                  0xff3B82F6,
                                                ),
                                                onTap: () async {
                                                  await provider
                                                      .toggleIssuedStatus(
                                                    book.id,
                                                  );

                                                  if (!context.mounted) return;

                                                  final updatedBook =
                                                      provider.books.firstWhere(
                                                    (b) => b.id == book.id,
                                                  );

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        updatedBook.isIssued
                                                            ? "Book Issued"
                                                            : "Book Available",
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(width: 8),
                                              _actionButton(
                                                icon: Icons.edit,
                                                bgColor: const Color(
                                                  0xffFFF4E8,
                                                ),
                                                iconColor: const Color(
                                                  0xffF79009,
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          AddEditBookScreen(
                                                        book: book,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(width: 8),
                                              _actionButton(
                                                icon: Icons.delete,
                                                bgColor: const Color(
                                                  0xffFEECEE,
                                                ),
                                                iconColor: const Color(
                                                  0xffF04438,
                                                ),
                                                onTap: () {
                                                  provider.deleteBook(book.id);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                      const SizedBox(height: 24),
                      Center(
                        child: Wrap(
                          spacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _pageButton(
                              child: const Icon(
                                Icons.chevron_left,
                                size: 18,
                                color: mutedColor,
                              ),
                            ),
                            _pageButton(text: '1', selected: true),
                            _pageButton(text: '2'),
                            _pageButton(text: '3'),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                '...',
                                style: TextStyle(
                                  color: mutedColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            _pageButton(text: '12'),
                            _pageButton(
                              child: const Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: mutedColor,
                              ),
                            ),
                          ],
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

  Widget _actionButton({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(
          icon,
          size: 14,
          color: iconColor,
        ),
      ),
    );
  }

  Widget _pageButton({
    String? text,
    bool selected = false,
    Widget? child,
  }) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: selected ? const Color(0xff19C37D) : Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: const Color(0xff19C37D).withValues(alpha: 0.22),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
        border: Border.all(
          color: selected ? const Color(0xff19C37D) : const Color(0xffEEF2F6),
        ),
      ),
      alignment: Alignment.center,
      child: child ??
          Text(
            text ?? '',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : const Color(0xff667085),
            ),
          ),
    );
  }
}
