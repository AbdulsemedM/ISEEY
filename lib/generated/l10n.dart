// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localizely_sdk/localizely_sdk.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class L10n {
  L10n();

  static L10n? _current;

  static L10n get current {
    assert(_current != null,
        'No instance of L10n was loaded. Try to initialize the L10n delegate before accessing L10n.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<L10n> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    if (!Localizely.hasMetadata()) {
      Localizely.setMetadata(_metadata);
    }
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = L10n();
      L10n._current = instance;

      return instance;
    });
  }

  static L10n of(BuildContext context) {
    final instance = L10n.maybeOf(context);
    assert(instance != null,
        'No instance of L10n present in the widget tree. Did you add L10n.delegate in localizationsDelegates?');
    return instance!;
  }

  static L10n? maybeOf(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  static final Map<String, List<String>> _metadata = {
    'accept_button_title': [],
    'app_logout_warning_message': [],
    'app_name': [],
    'are_you_sure_message': [],
    'blocked_user_no_data_title': [],
    'blocked_user_sorry_title': [],
    'blocked_user_title': [],
    'blocked_user_unblock_title': [],
    'blocked_user_unblock_user_warning_message': [],
    'cancel_button_title': [],
    'change_password_pop_up_message': [],
    'change_password_pop_up_title': [],
    'chat_page_add_friend_title': [],
    'chat_page_block_user_title': [],
    'chat_page_block_user_warning_message': [],
    'chat_page_clear_chat_title': [],
    'chat_page_clear_chat_warning_message': [],
    'chat_page_delete_title': [],
    'chat_page_flag_user_title': [],
    'chat_page_flag_user_warning_message': [],
    'chat_page_send_message_title': [],
    'chat_page_view_profile_title': [],
    'decline_button_title': [],
    'delete_account_warning_message': [],
    'done_title': [],
    'edit_profile_account_information_title': [],
    'edit_profile_basic_information_title': [],
    'edit_profile_birthday_text_field_title': [],
    'edit_profile_confirm_password_text_field': [],
    'edit_profile_delete_account_button_title': [],
    'edit_profile_delete_account_popup_cancel': [],
    'edit_profile_delete_account_popup_confirmation': [],
    'edit_profile_delete_account_popup_message': [],
    'edit_profile_description_text_field': [],
    'edit_profile_facebook_text_field': [],
    'edit_profile_instagram_text_field': [],
    'edit_profile_example_email': [],
    'edit_profile_example_first_name': [],
    'edit_profile_example_last_name': [],
    'edit_profile_gender_selection_title': [],
    'edit_profile_gender_text_field_text': [],
    'edit_profile_missing_info_error_message': [],
    'edit_profile_new_password_text_field': [],
    'edit_profile_old_password_text_field': [],
    'edit_profile_save_button_title': [],
    'email_field_hint_text': [],
    'email_is_not_valid_error_message': [],
    'email_not_valid_error_message': [],
    'empty_email_adress_error_message': [],
    'forgot_password_button_title': [],
    'forgot_password_page_button_title': [],
    'forgot_password_page_subtitle': [],
    'friends_list_remove_friend_warning_message': [],
    'friends_list_title': [],
    'friends_page_chats_title': [],
    'friends_page_delete_chat_warning_message': [],
    'friends_page_no_chats_available_title': [],
    'gender_female': [],
    'gender_male': [],
    'gender_others': [],
    'image_picker_camera_option': [],
    'image_picker_gallery_option': [],
    'incorrect_email_adress_error_message': [],
    'invalid_email_adress_error_message': [],
    'loading_title': [],
    'login_button_title': [],
    'login_empty_credentials_message': [],
    'login_sign_up_button_title': [],
    'login_success_title': [],
    'logout_warning_message': [],
    'menu_blocked_users_title': [],
    'menu_friends_count_title': [],
    'menu_friends_title': [],
    'menu_home_title': [],
    'menu_locations_count_title': [],
    'menu_logout_title': [],
    'menu_newsletter_title': [],
    'menu_profile_title': [],
    'newsletter_page_delete_newsletter_warning_message': [],
    'newsletter_page_title': [],
    'no_restaurant_selected_error_message': [],
    'password_field_hint_text': [],
    'password_length_error_message': [],
    'profiel_page_block_user_action_title': [],
    'profiel_page_message_title': [],
    'profiel_page_unblock_user_action_title': [],
    'profile_page_birth_date_title': [],
    'restaurant_list_empty_state_text': [],
    'restaurant_list_seach_bar_hint_text': [],
    'restaurant_list_title': [],
    'restaurant_menu_not_available_error_message': [],
    'restaurant_page_menu': [],
    'restaurant_page_drink_menu': [],
    'restaurant_page_no_offers_message': [],
    'restaurant_page_offers': [],
    'signup_button_title': [],
    'sign_up_confirm_password_required_error': [],
    'sign_up_confirm_password_text_field_title': [],
    'sign_up_email_and_password_is_empty_error_message': [],
    'sign_up_email_required_error': [],
    'sign_up_email_text_field_title': [],
    'sign_up_failure_message_title': [],
    'sign_up_first_name_required_error': [],
    'sign_up_first_name_text_field_title': [],
    'sign_up_have_an_acccount_button_title': [],
    'sign_up_last_name_required_error': [],
    'sign_up_last_name_text_field_title': [],
    'sign_up_password_required_error': [],
    'sign_up_passwords_not_equal': [],
    'sign_up_terms_agreement_warning_message': [],
    'sign_up_terms_agreement_warning_title': [],
    'sign_up_terms_of_use_agreement_text': [],
    'sign_up_terms_of_use_title': [],
    'something_went_wrong': [],
    'table_list_table_number': ['slash', 'number'],
    'table_list_title': [],
    'table_pop_up_error_message': [],
    'table_pop_up_newsletter_checkbox_text': [],
    'table_pop_up_subtitile': [],
    'table_pop_up_titile': [],
    'table_title': [],
    'table_user_list_chat_with_yourself_error_message': [],
    'table_user_list_user_age': ['age'],
    'no_internet_connection': [],
    'no_chats_connection': []
  };

  /// `Ja`
  String get accept_button_title {
    return Intl.message(
      'Ja',
      name: 'accept_button_title',
      desc: '',
      args: [],
    );
  }

  /// `App beenden`
  String get app_logout_warning_message {
    return Intl.message(
      'App beenden',
      name: 'app_logout_warning_message',
      desc: '',
      args: [],
    );
  }

  /// `ISEEY`
  String get app_name {
    return Intl.message(
      'ISEEY',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Bist du sicher?`
  String get are_you_sure_message {
    return Intl.message(
      'Bist du sicher?',
      name: 'are_you_sure_message',
      desc: '',
      args: [],
    );
  }

  /// `Keine Daten gefunden`
  String get blocked_user_no_data_title {
    return Intl.message(
      'Keine Daten gefunden',
      name: 'blocked_user_no_data_title',
      desc: '',
      args: [],
    );
  }

  /// `Sorry`
  String get blocked_user_sorry_title {
    return Intl.message(
      'Sorry',
      name: 'blocked_user_sorry_title',
      desc: '',
      args: [],
    );
  }

  /// `Blockierte User`
  String get blocked_user_title {
    return Intl.message(
      'Blockierte User',
      name: 'blocked_user_title',
      desc: '',
      args: [],
    );
  }

  /// `Entsperren`
  String get blocked_user_unblock_title {
    return Intl.message(
      'Entsperren',
      name: 'blocked_user_unblock_title',
      desc: '',
      args: [],
    );
  }

  /// `Freigeben ?`
  String get blocked_user_unblock_user_warning_message {
    return Intl.message(
      'Freigeben ?',
      name: 'blocked_user_unblock_user_warning_message',
      desc: '',
      args: [],
    );
  }

  /// `Abbrechen`
  String get cancel_button_title {
    return Intl.message(
      'Abbrechen',
      name: 'cancel_button_title',
      desc: '',
      args: [],
    );
  }

  /// `Passwörter müssen gleich sein.`
  String get change_password_pop_up_message {
    return Intl.message(
      'Passwörter müssen gleich sein.',
      name: 'change_password_pop_up_message',
      desc: '',
      args: [],
    );
  }

  /// `ISEEY APP`
  String get change_password_pop_up_title {
    return Intl.message(
      'ISEEY APP',
      name: 'change_password_pop_up_title',
      desc: '',
      args: [],
    );
  }

  /// `Freund hinzufügen`
  String get chat_page_add_friend_title {
    return Intl.message(
      'Freund hinzufügen',
      name: 'chat_page_add_friend_title',
      desc: '',
      args: [],
    );
  }

  /// `Blockieren`
  String get chat_page_block_user_title {
    return Intl.message(
      'Blockieren',
      name: 'chat_page_block_user_title',
      desc: '',
      args: [],
    );
  }

  /// `User blockieren ?`
  String get chat_page_block_user_warning_message {
    return Intl.message(
      'User blockieren ?',
      name: 'chat_page_block_user_warning_message',
      desc: '',
      args: [],
    );
  }

  /// `Chat löschen`
  String get chat_page_clear_chat_title {
    return Intl.message(
      'Chat löschen',
      name: 'chat_page_clear_chat_title',
      desc: '',
      args: [],
    );
  }

  /// `Chat löschen`
  String get chat_page_clear_chat_warning_message {
    return Intl.message(
      'Chat löschen',
      name: 'chat_page_clear_chat_warning_message',
      desc: '',
      args: [],
    );
  }

  /// `Löschen`
  String get chat_page_delete_title {
    return Intl.message(
      'Löschen',
      name: 'chat_page_delete_title',
      desc: '',
      args: [],
    );
  }

  /// `Melden`
  String get chat_page_flag_user_title {
    return Intl.message(
      'Melden',
      name: 'chat_page_flag_user_title',
      desc: '',
      args: [],
    );
  }

  /// `Was möchten Sie melden?`
  String get chat_page_flag_user_warning_message {
    return Intl.message(
      'Was möchten Sie melden?',
      name: 'chat_page_flag_user_warning_message',
      desc: '',
      args: [],
    );
  }

  /// `Nachricht senden`
  String get chat_page_send_message_title {
    return Intl.message(
      'Nachricht senden',
      name: 'chat_page_send_message_title',
      desc: '',
      args: [],
    );
  }

  /// `Profil anzeigen`
  String get chat_page_view_profile_title {
    return Intl.message(
      'Profil anzeigen',
      name: 'chat_page_view_profile_title',
      desc: '',
      args: [],
    );
  }

  /// `Nein`
  String get decline_button_title {
    return Intl.message(
      'Nein',
      name: 'decline_button_title',
      desc: '',
      args: [],
    );
  }

  /// `Sind Sie sicher, dass Sie dieses Konto endgültig löschen wollen?`
  String get delete_account_warning_message {
    return Intl.message(
      'Sind Sie sicher, dass Sie dieses Konto endgültig löschen wollen?',
      name: 'delete_account_warning_message',
      desc: '',
      args: [],
    );
  }

  /// `FERTIG`
  String get done_title {
    return Intl.message(
      'FERTIG',
      name: 'done_title',
      desc: '',
      args: [],
    );
  }

  /// `Passwort ändern`
  String get edit_profile_account_information_title {
    return Intl.message(
      'Passwort ändern',
      name: 'edit_profile_account_information_title',
      desc: '',
      args: [],
    );
  }

  /// `Eigene Daten`
  String get edit_profile_basic_information_title {
    return Intl.message(
      'Eigene Daten',
      name: 'edit_profile_basic_information_title',
      desc: '',
      args: [],
    );
  }

  /// `Geburtstag`
  String get edit_profile_birthday_text_field_title {
    return Intl.message(
      'Geburtstag',
      name: 'edit_profile_birthday_text_field_title',
      desc: '',
      args: [],
    );
  }

  /// `Passwort bestätigen`
  String get edit_profile_confirm_password_text_field {
    return Intl.message(
      'Passwort bestätigen',
      name: 'edit_profile_confirm_password_text_field',
      desc: '',
      args: [],
    );
  }

  /// `Profil löschen`
  String get edit_profile_delete_account_button_title {
    return Intl.message(
      'Profil löschen',
      name: 'edit_profile_delete_account_button_title',
      desc: '',
      args: [],
    );
  }

  /// `Abbrechen`
  String get edit_profile_delete_account_popup_cancel {
    return Intl.message(
      'Abbrechen',
      name: 'edit_profile_delete_account_popup_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Läschen`
  String get edit_profile_delete_account_popup_confirmation {
    return Intl.message(
      'Läschen',
      name: 'edit_profile_delete_account_popup_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Möchtest Du Dein Profil wirklich löschen?`
  String get edit_profile_delete_account_popup_message {
    return Intl.message(
      'Möchtest Du Dein Profil wirklich löschen?',
      name: 'edit_profile_delete_account_popup_message',
      desc: '',
      args: [],
    );
  }

  /// `Beschreibung`
  String get edit_profile_description_text_field {
    return Intl.message(
      'Beschreibung',
      name: 'edit_profile_description_text_field',
      desc: '',
      args: [],
    );
  }

  /// `Facebook Link`
  String get edit_profile_facebook_text_field {
    return Intl.message(
      'Facebook Link',
      name: 'edit_profile_facebook_text_field',
      desc: '',
      args: [],
    );
  }

  /// `Instagram Link`
  String get edit_profile_instagram_text_field {
    return Intl.message(
      'Instagram Link',
      name: 'edit_profile_instagram_text_field',
      desc: '',
      args: [],
    );
  }

  /// `z.B. joeparker@gmail.com`
  String get edit_profile_example_email {
    return Intl.message(
      'z.B. joeparker@gmail.com',
      name: 'edit_profile_example_email',
      desc: '',
      args: [],
    );
  }

  /// `z.B.Joe`
  String get edit_profile_example_first_name {
    return Intl.message(
      'z.B.Joe',
      name: 'edit_profile_example_first_name',
      desc: '',
      args: [],
    );
  }

  /// `z.B. Parker`
  String get edit_profile_example_last_name {
    return Intl.message(
      'z.B. Parker',
      name: 'edit_profile_example_last_name',
      desc: '',
      args: [],
    );
  }

  /// `Geschlecht ?`
  String get edit_profile_gender_selection_title {
    return Intl.message(
      'Geschlecht ?',
      name: 'edit_profile_gender_selection_title',
      desc: '',
      args: [],
    );
  }

  /// `Geschlecht`
  String get edit_profile_gender_text_field_text {
    return Intl.message(
      'Geschlecht',
      name: 'edit_profile_gender_text_field_text',
      desc: '',
      args: [],
    );
  }

  /// `Bitte ausfüllen`
  String get edit_profile_missing_info_error_message {
    return Intl.message(
      'Bitte ausfüllen',
      name: 'edit_profile_missing_info_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Neues Passwort`
  String get edit_profile_new_password_text_field {
    return Intl.message(
      'Neues Passwort',
      name: 'edit_profile_new_password_text_field',
      desc: '',
      args: [],
    );
  }

  /// `Altes Passwort`
  String get edit_profile_old_password_text_field {
    return Intl.message(
      'Altes Passwort',
      name: 'edit_profile_old_password_text_field',
      desc: '',
      args: [],
    );
  }

  /// `Speichern`
  String get edit_profile_save_button_title {
    return Intl.message(
      'Speichern',
      name: 'edit_profile_save_button_title',
      desc: '',
      args: [],
    );
  }

  /// `z.B. mustermann@gmail.com`
  String get email_field_hint_text {
    return Intl.message(
      'z.B. mustermann@gmail.com',
      name: 'email_field_hint_text',
      desc: '',
      args: [],
    );
  }

  /// `E-Mail ungültig`
  String get email_is_not_valid_error_message {
    return Intl.message(
      'E-Mail ungültig',
      name: 'email_is_not_valid_error_message',
      desc: '',
      args: [],
    );
  }

  /// `E-Mail nicht gültig`
  String get email_not_valid_error_message {
    return Intl.message(
      'E-Mail nicht gültig',
      name: 'email_not_valid_error_message',
      desc: '',
      args: [],
    );
  }

  /// `E-Mail fehlt`
  String get empty_email_adress_error_message {
    return Intl.message(
      'E-Mail fehlt',
      name: 'empty_email_adress_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Passwort vergessen?`
  String get forgot_password_button_title {
    return Intl.message(
      'Passwort vergessen?',
      name: 'forgot_password_button_title',
      desc: '',
      args: [],
    );
  }

  /// `Senden`
  String get forgot_password_page_button_title {
    return Intl.message(
      'Senden',
      name: 'forgot_password_page_button_title',
      desc: '',
      args: [],
    );
  }

  /// `Bitte bestätigen Sie Ihre E-Mail.`
  String get forgot_password_page_subtitle {
    return Intl.message(
      'Bitte bestätigen Sie Ihre E-Mail.',
      name: 'forgot_password_page_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Freundschaft aufheben `
  String get friends_list_remove_friend_warning_message {
    return Intl.message(
      'Freundschaft aufheben ',
      name: 'friends_list_remove_friend_warning_message',
      desc: '',
      args: [],
    );
  }

  /// `Freunde`
  String get friends_list_title {
    return Intl.message(
      'Freunde',
      name: 'friends_list_title',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get friends_page_chats_title {
    return Intl.message(
      'Chats',
      name: 'friends_page_chats_title',
      desc: '',
      args: [],
    );
  }

  /// `Chat löschen?`
  String get friends_page_delete_chat_warning_message {
    return Intl.message(
      'Chat löschen?',
      name: 'friends_page_delete_chat_warning_message',
      desc: '',
      args: [],
    );
  }

  /// `Keine Chats verfügbar`
  String get friends_page_no_chats_available_title {
    return Intl.message(
      'Keine Chats verfügbar',
      name: 'friends_page_no_chats_available_title',
      desc: '',
      args: [],
    );
  }

  /// `Weiblich`
  String get gender_female {
    return Intl.message(
      'Weiblich',
      name: 'gender_female',
      desc: '',
      args: [],
    );
  }

  /// `Männlich`
  String get gender_male {
    return Intl.message(
      'Männlich',
      name: 'gender_male',
      desc: '',
      args: [],
    );
  }

  /// `Andere`
  String get gender_others {
    return Intl.message(
      'Andere',
      name: 'gender_others',
      desc: '',
      args: [],
    );
  }

  /// `Kamera`
  String get image_picker_camera_option {
    return Intl.message(
      'Kamera',
      name: 'image_picker_camera_option',
      desc: '',
      args: [],
    );
  }

  /// `Galerie`
  String get image_picker_gallery_option {
    return Intl.message(
      'Galerie',
      name: 'image_picker_gallery_option',
      desc: '',
      args: [],
    );
  }

  /// `Falscher Benutzername oder Passwort!`
  String get incorrect_email_adress_error_message {
    return Intl.message(
      'Falscher Benutzername oder Passwort!',
      name: 'incorrect_email_adress_error_message',
      desc: '',
      args: [],
    );
  }

  /// `E-Mail Adresse eingeben`
  String get invalid_email_adress_error_message {
    return Intl.message(
      'E-Mail Adresse eingeben',
      name: 'invalid_email_adress_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Einen Moment`
  String get loading_title {
    return Intl.message(
      'Einen Moment',
      name: 'loading_title',
      desc: 'loading state view title',
      args: [],
    );
  }

  /// `Anmeldung`
  String get login_button_title {
    return Intl.message(
      'Anmeldung',
      name: 'login_button_title',
      desc: '',
      args: [],
    );
  }

  /// `Bitte E-Mail und Passwort eingeben`
  String get login_empty_credentials_message {
    return Intl.message(
      'Bitte E-Mail und Passwort eingeben',
      name: 'login_empty_credentials_message',
      desc: '',
      args: [],
    );
  }

  /// `Kein Konto? Registrierung.`
  String get login_sign_up_button_title {
    return Intl.message(
      'Kein Konto? Registrierung.',
      name: 'login_sign_up_button_title',
      desc: '',
      args: [],
    );
  }

  /// `Erfolgreich!`
  String get login_success_title {
    return Intl.message(
      'Erfolgreich!',
      name: 'login_success_title',
      desc: '',
      args: [],
    );
  }

  /// `Wirklich abmelden?`
  String get logout_warning_message {
    return Intl.message(
      'Wirklich abmelden?',
      name: 'logout_warning_message',
      desc: '',
      args: [],
    );
  }

  /// `BLOCKIERTE USER`
  String get menu_blocked_users_title {
    return Intl.message(
      'BLOCKIERTE USER',
      name: 'menu_blocked_users_title',
      desc: '',
      args: [],
    );
  }

  /// `Freunde`
  String get menu_friends_count_title {
    return Intl.message(
      'Freunde',
      name: 'menu_friends_count_title',
      desc: '',
      args: [],
    );
  }

  /// `FREUNDE`
  String get menu_friends_title {
    return Intl.message(
      'FREUNDE',
      name: 'menu_friends_title',
      desc: '',
      args: [],
    );
  }

  /// `HOME`
  String get menu_home_title {
    return Intl.message(
      'HOME',
      name: 'menu_home_title',
      desc: '',
      args: [],
    );
  }

  /// `Locations`
  String get menu_locations_count_title {
    return Intl.message(
      'Locations',
      name: 'menu_locations_count_title',
      desc: '',
      args: [],
    );
  }

  /// `AUSLOGGEN`
  String get menu_logout_title {
    return Intl.message(
      'AUSLOGGEN',
      name: 'menu_logout_title',
      desc: '',
      args: [],
    );
  }

  /// `NEWSLETTER`
  String get menu_newsletter_title {
    return Intl.message(
      'NEWSLETTER',
      name: 'menu_newsletter_title',
      desc: '',
      args: [],
    );
  }

  /// `PROFIL`
  String get menu_profile_title {
    return Intl.message(
      'PROFIL',
      name: 'menu_profile_title',
      desc: '',
      args: [],
    );
  }

  /// `Newsletter löschen?`
  String get newsletter_page_delete_newsletter_warning_message {
    return Intl.message(
      'Newsletter löschen?',
      name: 'newsletter_page_delete_newsletter_warning_message',
      desc: '',
      args: [],
    );
  }

  /// `Newsletter`
  String get newsletter_page_title {
    return Intl.message(
      'Newsletter',
      name: 'newsletter_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Bitte Location auswählen.`
  String get no_restaurant_selected_error_message {
    return Intl.message(
      'Bitte Location auswählen.',
      name: 'no_restaurant_selected_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Passwort`
  String get password_field_hint_text {
    return Intl.message(
      'Passwort',
      name: 'password_field_hint_text',
      desc: '',
      args: [],
    );
  }

  /// `Passwort mindestens 8 Zeichen`
  String get password_length_error_message {
    return Intl.message(
      'Passwort mindestens 8 Zeichen',
      name: 'password_length_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Blockieren`
  String get profiel_page_block_user_action_title {
    return Intl.message(
      'Blockieren',
      name: 'profiel_page_block_user_action_title',
      desc: '',
      args: [],
    );
  }

  /// `Nachricht`
  String get profiel_page_message_title {
    return Intl.message(
      'Nachricht',
      name: 'profiel_page_message_title',
      desc: '',
      args: [],
    );
  }

  /// `Freigeben`
  String get profiel_page_unblock_user_action_title {
    return Intl.message(
      'Freigeben',
      name: 'profiel_page_unblock_user_action_title',
      desc: '',
      args: [],
    );
  }

  /// `Geburtsdatum`
  String get profile_page_birth_date_title {
    return Intl.message(
      'Geburtsdatum',
      name: 'profile_page_birth_date_title',
      desc: '',
      args: [],
    );
  }

  /// `Keine Location gefunden`
  String get restaurant_list_empty_state_text {
    return Intl.message(
      'Keine Location gefunden',
      name: 'restaurant_list_empty_state_text',
      desc: '',
      args: [],
    );
  }

  /// `Suchen nach...`
  String get restaurant_list_seach_bar_hint_text {
    return Intl.message(
      'Suchen nach...',
      name: 'restaurant_list_seach_bar_hint_text',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get restaurant_list_title {
    return Intl.message(
      'Location',
      name: 'restaurant_list_title',
      desc: '',
      args: [],
    );
  }

  /// `Momentan kein Menü vorhanden`
  String get restaurant_menu_not_available_error_message {
    return Intl.message(
      'Momentan kein Menü vorhanden',
      name: 'restaurant_menu_not_available_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Speisen`
  String get restaurant_page_menu {
    return Intl.message(
      'Speisen',
      name: 'restaurant_page_menu',
      desc: '',
      args: [],
    );
  }

  /// `Getränke`
  String get restaurant_page_drink_menu {
    return Intl.message(
      'Getränke',
      name: 'restaurant_page_drink_menu',
      desc: '',
      args: [],
    );
  }

  /// `Keine Angebote`
  String get restaurant_page_no_offers_message {
    return Intl.message(
      'Keine Angebote',
      name: 'restaurant_page_no_offers_message',
      desc: '',
      args: [],
    );
  }

  /// `Angebote`
  String get restaurant_page_offers {
    return Intl.message(
      'Angebote',
      name: 'restaurant_page_offers',
      desc: '',
      args: [],
    );
  }

  /// `Anmelden`
  String get signup_button_title {
    return Intl.message(
      'Anmelden',
      name: 'signup_button_title',
      desc: '',
      args: [],
    );
  }

  /// `Passwort bestätigen`
  String get sign_up_confirm_password_required_error {
    return Intl.message(
      'Passwort bestätigen',
      name: 'sign_up_confirm_password_required_error',
      desc: '',
      args: [],
    );
  }

  /// `Passwort bestätigen`
  String get sign_up_confirm_password_text_field_title {
    return Intl.message(
      'Passwort bestätigen',
      name: 'sign_up_confirm_password_text_field_title',
      desc: '',
      args: [],
    );
  }

  /// `E-Mail und Passwort eingeben`
  String get sign_up_email_and_password_is_empty_error_message {
    return Intl.message(
      'E-Mail und Passwort eingeben',
      name: 'sign_up_email_and_password_is_empty_error_message',
      desc: '',
      args: [],
    );
  }

  /// `E-Mail erforderlich`
  String get sign_up_email_required_error {
    return Intl.message(
      'E-Mail erforderlich',
      name: 'sign_up_email_required_error',
      desc: '',
      args: [],
    );
  }

  /// `E-Mail-Addresse`
  String get sign_up_email_text_field_title {
    return Intl.message(
      'E-Mail-Addresse',
      name: 'sign_up_email_text_field_title',
      desc: '',
      args: [],
    );
  }

  /// `Fehler!`
  String get sign_up_failure_message_title {
    return Intl.message(
      'Fehler!',
      name: 'sign_up_failure_message_title',
      desc: '',
      args: [],
    );
  }

  /// `Vorname erforderlich`
  String get sign_up_first_name_required_error {
    return Intl.message(
      'Vorname erforderlich',
      name: 'sign_up_first_name_required_error',
      desc: '',
      args: [],
    );
  }

  /// `Vorname`
  String get sign_up_first_name_text_field_title {
    return Intl.message(
      'Vorname',
      name: 'sign_up_first_name_text_field_title',
      desc: '',
      args: [],
    );
  }

  /// `Konto vorhanden? Login`
  String get sign_up_have_an_acccount_button_title {
    return Intl.message(
      'Konto vorhanden? Login',
      name: 'sign_up_have_an_acccount_button_title',
      desc: '',
      args: [],
    );
  }

  /// `Nachname erforderlich`
  String get sign_up_last_name_required_error {
    return Intl.message(
      'Nachname erforderlich',
      name: 'sign_up_last_name_required_error',
      desc: '',
      args: [],
    );
  }

  /// `Nachname`
  String get sign_up_last_name_text_field_title {
    return Intl.message(
      'Nachname',
      name: 'sign_up_last_name_text_field_title',
      desc: '',
      args: [],
    );
  }

  /// `Passwort erforderlich`
  String get sign_up_password_required_error {
    return Intl.message(
      'Passwort erforderlich',
      name: 'sign_up_password_required_error',
      desc: '',
      args: [],
    );
  }

  /// `Passwörter müssen gleich sein`
  String get sign_up_passwords_not_equal {
    return Intl.message(
      'Passwörter müssen gleich sein',
      name: 'sign_up_passwords_not_equal',
      desc: '',
      args: [],
    );
  }

  /// `Bitte Nutzungsbedingungen zustimmen.`
  String get sign_up_terms_agreement_warning_message {
    return Intl.message(
      'Bitte Nutzungsbedingungen zustimmen.',
      name: 'sign_up_terms_agreement_warning_message',
      desc: '',
      args: [],
    );
  }

  /// `ISEEY APP`
  String get sign_up_terms_agreement_warning_title {
    return Intl.message(
      'ISEEY APP',
      name: 'sign_up_terms_agreement_warning_title',
      desc: '',
      args: [],
    );
  }

  /// `Ich akzeptiere`
  String get sign_up_terms_of_use_agreement_text {
    return Intl.message(
      'Ich akzeptiere',
      name: 'sign_up_terms_of_use_agreement_text',
      desc: '',
      args: [],
    );
  }

  /// `Nutzungsbedingungen`
  String get sign_up_terms_of_use_title {
    return Intl.message(
      'Nutzungsbedingungen',
      name: 'sign_up_terms_of_use_title',
      desc: '',
      args: [],
    );
  }

  /// `Etwas ist schief gelaufen`
  String get something_went_wrong {
    return Intl.message(
      'Etwas ist schief gelaufen',
      name: 'something_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Tisch{slash}{number}`
  String table_list_table_number(Object slash, Object number) {
    return Intl.message(
      'Tisch$slash$number',
      name: 'table_list_table_number',
      desc: '',
      args: [slash, number],
    );
  }

  /// `Tische`
  String get table_list_title {
    return Intl.message(
      'Tische',
      name: 'table_list_title',
      desc: '',
      args: [],
    );
  }

  /// `Tischnummer eingeben.`
  String get table_pop_up_error_message {
    return Intl.message(
      'Tischnummer eingeben.',
      name: 'table_pop_up_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Ich stimme dem Newsletter zu`
  String get table_pop_up_newsletter_checkbox_text {
    return Intl.message(
      'Ich stimme dem Newsletter zu',
      name: 'table_pop_up_newsletter_checkbox_text',
      desc: '',
      args: [],
    );
  }

  /// `Dein Tisch #`
  String get table_pop_up_subtitile {
    return Intl.message(
      'Dein Tisch #',
      name: 'table_pop_up_subtitile',
      desc: '',
      args: [],
    );
  }

  /// `Tisch`
  String get table_pop_up_titile {
    return Intl.message(
      'Tisch',
      name: 'table_pop_up_titile',
      desc: '',
      args: [],
    );
  }

  /// `Tisch`
  String get table_title {
    return Intl.message(
      'Tisch',
      name: 'table_title',
      desc: '',
      args: [],
    );
  }

  /// `Nicht möglich!`
  String get table_user_list_chat_with_yourself_error_message {
    return Intl.message(
      'Nicht möglich!',
      name: 'table_user_list_chat_with_yourself_error_message',
      desc: '',
      args: [],
    );
  }

  /// `{age} Jahre`
  String table_user_list_user_age(Object age) {
    return Intl.message(
      '$age Jahre',
      name: 'table_user_list_user_age',
      desc: '',
      args: [age],
    );
  }

  /// `Bitte überprüfen Sie Ihre Internetverbindung!`
  String get no_internet_connection {
    return Intl.message(
      'Bitte überprüfen Sie Ihre Internetverbindung!',
      name: 'no_internet_connection',
      desc: '',
      args: [],
    );
  }

  /// `Noch keine Unterhaltungen vorhanden.`
  String get no_chats_connection {
    return Intl.message(
      'Noch keine Unterhaltungen vorhanden.',
      name: 'no_chats_connection',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<L10n> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<L10n> load(Locale locale) => L10n.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
