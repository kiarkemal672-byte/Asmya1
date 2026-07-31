class User {
  final String id;
  final String username;
  final String displayName;
  final String? handle;
  final String role;
  final String? side;
  final String? adminSubrole;
  final String? avatarUrl;
  final String? bio;
  final String preferredLanguage;
  final bool darkMode;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    this.handle,
    required this.role,
    this.side,
    this.adminSubrole,
    this.avatarUrl,
    this.bio,
    this.preferredLanguage = 'en',
    this.darkMode = true,
  });

  factory User.fromJson(Map<String, dynamic> j) => User(
    id: j['id'] ?? '',
    username: j['username'] ?? '',
    displayName: j['display_name'] ?? '',
    handle: j['handle'],
    role: j['role'] ?? 'STUDENT',
    side: j['side'],
    adminSubrole: j['admin_subrole'],
    avatarUrl: j['avatar_url'],
    bio: j['bio'],
    preferredLanguage: j['preferred_language'] ?? 'en',
    darkMode: j['dark_mode'] ?? true,
  );

  String get initials {
    final parts = displayName.split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    return (parts.first[0] + (parts.length > 1 ? parts[1][0] : ''))
        .toUpperCase();
  }
}

class Conversation {
  final String id;
  final String title;
  final String? description;
  final bool isGroup;
  final String? adminSubrole;
  final String? avatarInitials;
  final String? lastMessage;
  final String? lastSenderName;
  final DateTime? lastMessageAt;

  Conversation({
    required this.id,
    required this.title,
    this.description,
    this.isGroup = true,
    this.adminSubrole,
    this.avatarInitials,
    this.lastMessage,
    this.lastSenderName,
    this.lastMessageAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> j) => Conversation(
    id: j['id'] ?? '',
    title: j['title'] ?? '',
    description: j['description'],
    isGroup: j['is_group'] ?? true,
    adminSubrole: j['admin_subrole'],
    avatarInitials: j['avatar_initials'],
    lastMessage: j['last_message'],
    lastSenderName: j['last_sender_name'],
    lastMessageAt: j['last_message_at'] != null
        ? DateTime.tryParse(j['last_message_at'].toString())
        : null,
  );
}

class Announcement {
  final String id;
  final String? authorId;
  final String authorName;
  final String authorInitials;
  final String title;
  final String content;
  final DateTime createdAt;

  Announcement({
    required this.id,
    this.authorId,
    required this.authorName,
    required this.authorInitials,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> j) => Announcement(
    id: j['id'] ?? '',
    authorId: j['author_id'],
    authorName: j['author_name'] ?? '',
    authorInitials: j['author_initials'] ?? '',
    title: j['title'] ?? '',
    content: j['content'] ?? '',
    createdAt: j['created_at'] != null
        ? DateTime.tryParse(j['created_at'].toString()) ?? DateTime.now()
        : DateTime.now(),
  );
}

class Plan {
  final String id;
  final String title;
  final String? description;
  final String status;
  final DateTime? dueDate;
  final List<String> assigneeTags;
  final int reportCount;
  final DateTime createdAt;

  Plan({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.dueDate,
    this.assigneeTags = const [],
    this.reportCount = 0,
    required this.createdAt,
  });

  factory Plan.fromJson(Map<String, dynamic> j) => Plan(
    id: j['id'] ?? '',
    title: j['title'] ?? '',
    description: j['description'],
    status: (j['status'] ?? 'PENDING').toString(),
    dueDate: j['due_date'] != null
        ? DateTime.tryParse(j['due_date'].toString())
        : null,
    assigneeTags: (j['assignee_tags'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
    reportCount: (j['report_count'] ?? 0) as int,
    createdAt: j['created_at'] != null
        ? DateTime.tryParse(j['created_at'].toString()) ?? DateTime.now()
        : DateTime.now(),
  );
}

class Report {
  final String id;
  final String? planId;
  final String authorName;
  final String authorInitials;
  final String title;
  final String content;
  final DateTime createdAt;

  Report({
    required this.id,
    this.planId,
    required this.authorName,
    required this.authorInitials,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> j) => Report(
    id: j['id'] ?? '',
    planId: j['plan_id'],
    authorName: j['author_name'] ?? '',
    authorInitials: j['author_initials'] ?? '',
    title: j['title'] ?? '',
    content: j['content'] ?? '',
    createdAt: j['created_at'] != null
        ? DateTime.tryParse(j['created_at'].toString()) ?? DateTime.now()
        : DateTime.now(),
  );
}

class CashbookTransaction {
  final String id;
  final String type;
  final String category;
  final double amount;
  final String description;
  final String userInitials;
  final DateTime transactionDate;

  CashbookTransaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.description,
    required this.userInitials,
    required this.transactionDate,
  });

  factory CashbookTransaction.fromJson(Map<String, dynamic> j) =>
      CashbookTransaction(
        id: j['id'] ?? '',
        type: j['type'] ?? 'EXPENSE',
        category: j['category'] ?? 'OTHER',
        amount: double.tryParse(j['amount']?.toString() ?? '0') ?? 0,
        description: j['description'] ?? '',
        userInitials: j['user_initials'] ?? '',
        transactionDate: j['transaction_date'] != null
            ? DateTime.tryParse(j['transaction_date'].toString()) ?? DateTime.now()
            : DateTime.now(),
      );
}

class CashbookSummary {
  final double totalIn;
  final double totalOut;
  final double balance;
  CashbookSummary({
    required this.totalIn,
    required this.totalOut,
    required this.balance,
  });
  factory CashbookSummary.fromJson(Map<String, dynamic> j) => CashbookSummary(
    totalIn: double.tryParse(j['total_in']?.toString() ?? '0') ?? 0,
    totalOut: double.tryParse(j['total_out']?.toString() ?? '0') ?? 0,
    balance: double.tryParse(j['balance']?.toString() ?? '0') ?? 0,
  );
}
