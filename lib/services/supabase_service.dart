import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:personal_profile/models/profile.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;
  
  Future<bool> createProfile(String id, String password, Profile profile) async {
    try {
      final result = await supabase.from('profiles').insert({
        'id': id,
        'password': password,
        'data': profile.sections,
      }).select();
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<Profile?> getProfile(String id) async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', id)
          .single();
      return Profile(
        id: response['id'] as String,
        password: response['password'] as String,
        sections: Map<String, dynamic>.from(response['data'] as Map),
      );
    } catch (e) {
      return null;
    }
  }

  Future<bool> profileExists(String id) async {
    try {
      final response = await supabase
          .from('profiles')
          .select('id')
          .eq('id', id)
          .single();
      return response != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> validateCredentials(String id, String password) async {
    try {
      final result = await supabase
          .from('profiles')
          .select()
          .eq('id', id)
          .eq('password', password)
          .single();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProfile(String id, String password, Profile profile) async {
    try {
      final result = await supabase
          .from('profiles')
          .update({'data': profile.sections})
          .eq('id', id)
          .eq('password', password)
          .select();
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProfile(String id, String password) async {
    try {
      final result = await supabase
          .from('profiles')
          .delete()
          .eq('id', id)
          .eq('password', password)
          .select();
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
