import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:personal_profile/models/profile.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;
  
  Future<bool> createProfile(String id, String password, Profile profile) async {
    try {
      final result = await supabase.from('profiles').insert({
        'id': id,
        'password': password,
        'data': profile.toJson(),
      }).select();
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<Profile?> getProfile(String id) async {
    try {
      final result = await supabase
          .from('profiles')
          .select()
          .eq('id', id)
          .single();
      
      return Profile.fromJson(result['data']);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateProfile(String id, String password, Profile profile) async {
    try {
      final result = await supabase
          .from('profiles')
          .update({'data': profile.toJson()})
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
