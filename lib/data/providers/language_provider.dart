import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _code = 'en';
  String get code => _code;
  Locale get locale => Locale(_code);

  static const labels = <String, Map<String, String>>{
    'en': {
      'chat': 'Chat',
      'announcements': 'Announcements',
      'plans': 'Plans',
      'reports': 'Reports',
      'cashbook': 'Cashbook',
      'members': 'Members',
      'settings': 'Settings',
      'sign_in': 'Sign In',
      'sign_out': 'Sign Out',
      'username': 'Username',
      'password': 'Password',
      'search': 'Search',
      'new_announcement': '+ New Announcement',
      'new_plan': '+ New Plan',
      'new_report': '+ New Report',
      'all_members': 'All Members',
      'my_followers': 'My Followers',
      'add_member': '+ Add Member',
      'no_members': 'No members found',
      'dark': 'Dark',
      'light': 'Light',
      'english': 'English',
      'amharic': 'Amharic',
      'arabic': 'العربية',
      'display_name': 'Display Name',
      'current_password': 'Current Password',
      'new_password': 'New Password',
      'confirm_password': 'Confirm Password',
      'save': 'Save',
      'total_in': 'Total In',
      'total_out': 'Total Out',
      'balance': 'Balance',
    },
    'am': {
      'chat': 'ቻት',
      'announcements': 'ማስታወቂያዎች',
      'plans': 'እቅዶች',
      'reports': 'ሪፖርቶች',
      'cashbook': 'ጥሬ ገንዘብ',
      'members': 'አባላት',
      'settings': 'ቅንብሮች',
      'sign_in': 'ግባ',
      'sign_out': 'ውጣ',
      'username': 'የተጠቃሚ ስም',
      'password': 'የይለፍ ቃል',
      'search': 'ፈልግ',
      'new_announcement': '+ አዲስ ማስታወቂያ',
      'new_plan': '+ አዲስ እቅድ',
      'new_report': '+ አዲስ ሪፖርት',
      'all_members': 'ሁሉም አባላት',
      'my_followers': 'የእኔ ተከታዮች',
      'add_member': '+ አባል ጨምር',
      'no_members': 'አባል አልተገኘም',
      'dark': 'ጨለማ',
      'light': 'ብርሃን',
      'english': 'English',
      'amharic': 'አማርኛ',
      'arabic': 'العربية',
      'display_name': 'ማሳያ ስም',
      'current_password': 'ወቅታዊ የይለፍ ቃል',
      'new_password': 'አዲስ የይለፍ ቃል',
      'confirm_password': 'የይለፍ ቃል ያረጋግጡ',
      'save': 'አስቀምጥ',
      'total_in': 'ጠቅላላ ገቢ',
      'total_out': 'ጠቅላላ ወጪ',
      'balance': 'ቀሪ ሂሳብ',
    },
    'ar': {
      'chat': 'الدردشة',
      'announcements': 'الإعلانات',
      'plans': 'الخطط',
      'reports': 'التقارير',
      'cashbook': 'الدفتر النقدي',
      'members': 'الأعضاء',
      'settings': 'الإعدادات',
      'sign_in': 'تسجيل الدخول',
      'sign_out': 'تسجيل الخروج',
      'username': 'اسم المستخدم',
      'password': 'كلمة المرور',
      'search': 'بحث',
      'new_announcement': '+ إعلان جديد',
      'new_plan': '+ خطة جديدة',
      'new_report': '+ تقرير جديد',
      'all_members': 'كل الأعضاء',
      'my_followers': 'متابعون',
      'add_member': '+ إضافة عضو',
      'no_members': 'لا يوجد أعضاء',
      'dark': 'داكن',
      'light': 'فاتح',
      'english': 'English',
      'amharic': 'አማርኛ',
      'arabic': 'العربية',
      'display_name': 'الاسم المعروض',
      'current_password': 'كلمة المرور الحالية',
      'new_password': 'كلمة مرور جديدة',
      'confirm_password': 'تأكيد كلمة المرور',
      'save': 'حفظ',
      'total_in': 'إجمالي الداخل',
      'total_out': 'إجمالي الخارج',
      'balance': 'الرصيد',
    },
  };

  String t(String key) => labels[_code]?[key] ?? labels['en']![key] ?? key;

  LanguageProvider() { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _code = prefs.getString('asmya_lang') ?? 'en';
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _code = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('asmya_lang', code);
    notifyListeners();
  }
}
