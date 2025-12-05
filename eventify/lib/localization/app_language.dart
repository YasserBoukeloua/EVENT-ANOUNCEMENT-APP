class AppLanguage {
  static String code = 'en';

  static void setCode(String newCode) {
    code = newCode;
  }

  static String t(String key) {
    final map = code == 'fr' ? _fr : _en;
    return map[key] ?? key;
  }

  static const Map<String, String> _en = {
    'home_hello_prefix': 'Hello',
    'home_events_this_week': 'You have 3 events this week',
    'home_upcoming': 'Upcoming events',
    'home_top_picks': 'Top Picks',
    'home_filter_all': 'All',
    'home_filter_recent': 'Recent',
    'home_filter_closest': 'Closest',
    'home_search_hint': 'Search...',
    'home_view_all': 'View all',
    'profile_title': 'Profile',
    'profile_personal_info': 'Personal Information',
    'profile_activity': 'Activity',
    'profile_manage_account': 'Manage my account',
    'profile_app_privacy': 'App & Privacy',
    'profile_my_privacy_data': 'My Privacy & data',
    'profile_logout': 'Logout',
    'settings_title': 'Settings',
    'settings_notifications': 'Notifications',
    'settings_push_notifications': 'Push Notifications',
    'settings_push_desc': 'Receive notifications about upcoming events',
    'settings_email_notifications': 'Email Notifications',
    'settings_email_desc': 'Receive event updates via email',
    'settings_language_section': 'Language',
    'settings_app_language': 'App Language',
    'settings_event_preferences': 'Event Preferences',
    'settings_categories': 'Categories',
    'settings_preferred_locations': 'Preferred Locations',
    'settings_free_events_only': 'Free Events Only',
    'settings_free_events_desc': 'Show only free events',
    'settings_general': 'General',
    'settings_privacy_policy': 'Privacy Policy',
    'settings_terms_of_service': 'Terms of Service',
    'settings_about': 'About',
    'settings_help_support': 'Help & Support',
  };

  static const Map<String, String> _fr = {
    'home_hello_prefix': 'Bonjour',
    'home_events_this_week': 'Vous avez 3 événements cette semaine',
    'home_upcoming': 'Événements à venir',
    'home_top_picks': 'Sélections',
    'home_filter_all': 'Tous',
    'home_filter_recent': 'Récents',
    'home_filter_closest': 'Les plus proches',
    'home_search_hint': 'Rechercher...',
    'home_view_all': 'Tout voir',
    'profile_title': 'Profil',
    'profile_personal_info': 'Informations personnelles',
    'profile_activity': 'Activité',
    'profile_manage_account': 'Gérer mon compte',
    'profile_app_privacy': 'Application & confidentialité',
    'profile_my_privacy_data': 'Ma confidentialité et mes données',
    'profile_logout': 'Se déconnecter',
    'settings_title': 'Paramètres',
    'settings_notifications': 'Notifications',
    'settings_push_notifications': 'Notifications push',
    'settings_push_desc': 'Recevoir des notifications sur les prochains événements',
    'settings_email_notifications': 'Notifications par e-mail',
    'settings_email_desc': 'Recevoir les mises à jour des événements par e-mail',
    'settings_language_section': 'Langue',
    'settings_app_language': 'Langue de l’application',
    'settings_event_preferences': 'Préférences des événements',
    'settings_categories': 'Catégories',
    'settings_preferred_locations': 'Lieux préférés',
    'settings_free_events_only': 'Événements gratuits uniquement',
    'settings_free_events_desc': 'Afficher uniquement les événements gratuits',
    'settings_general': 'Général',
    'settings_privacy_policy': 'Politique de confidentialité',
    'settings_terms_of_service': 'Conditions d’utilisation',
    'settings_about': 'À propos',
    'settings_help_support': 'Aide et support',
  };
}


