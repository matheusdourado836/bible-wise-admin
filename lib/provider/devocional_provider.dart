import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/devocional.dart';

class DevocionalProvider extends ChangeNotifier {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  bool isLoading = false;

  Future<List<Devocional>> getAll() async {
    try {
      List<Devocional> devocionais = [];
      await _database.collection('devocionais').get().then((res) {
        if(res.docs.isNotEmpty) {
          final docs = res.docs;
          for(var devocional in docs) {
            if(devocional.exists) {
              devocionais.add(Devocional.fromJson(devocional.data()));
            }

          }
        }
      });

      return devocionais;
    }catch(e) {
      print('NAO FOI POSSIVEL RECUPERAR OS DEVOCIONAIS $e');
      return [];
    }
  }

  Future<List<Devocional>> getPendingDevocionais() async {
    List<Devocional> pendingDevocionais = [];
    isLoading = true;
    notifyListeners();
    pendingDevocionais = await _getFromDb(1);
    isLoading = false;
    notifyListeners();
    return pendingDevocionais;
  }

  Future<List<Devocional>> getRejectedDevocionais() async {
    List<Devocional> rejectedDevocionais = [];
    isLoading = true;
    notifyListeners();
    rejectedDevocionais = await _getFromDb(2);
    isLoading = false;
    notifyListeners();
    return rejectedDevocionais;
  }

  Future<List<Devocional>> getToReviewDevocionais() async {
    List<Devocional> toReviewDevocionais = [];
    isLoading = true;
    notifyListeners();
    toReviewDevocionais = await _getReviewsFromDb();
    isLoading = false;
    notifyListeners();
    return toReviewDevocionais;
  }

  Future<List<Devocional>> _getFromDb(int status) async {
    try {
      List<Devocional> devocionais = [];
      await _database.collection('devocionais').where('status', isEqualTo: status).get().then((res) {
        if(res.docs.isNotEmpty) {
          final docs = res.docs;
          for(var devocional in docs) {
            if(devocional.exists) {
              devocionais.add(Devocional.fromJson(devocional.data()));
            }

          }
        }
      });

      return devocionais;
    }catch(e) {
      print('NAO FOI POSSIVEL RECUPERAR OS DEVOCIONAIS PENDENTES $e');
      return [];
    }
  }

  Future<List<Devocional>> _getReviewsFromDb() async {
    try {
      List<Devocional> devocionais = [];
      await _database.collection('toReview').get().then((res) async {
        if(res.docs.isNotEmpty) {
          final docs = res.docs;
          for(var doc in docs) {
            if(doc.exists) {
              final data = doc.data();
              await _database.collection('devocionais').where('status', isEqualTo: 2).where('id', isEqualTo: data["devocionalId"]).get().then((res) {
                if(res.docs.isNotEmpty) {
                  final docs = res.docs;
                  if(docs.first.exists) {
                    final devocional = Devocional.fromJson(docs.first.data());
                    devocional.argument = data["argument"];
                    devocionais.add(devocional);
                  }
                }
              });
            }

          }
        }
      });

      return devocionais;
    }catch(e) {
      print('NAO FOI POSSIVEL RECUPERAR OS DEVOCIONAIS PENDENTES $e');
      return [];
    }
  }

  Future<void> updateUserData(String devocionalId, Map<String, dynamic> info) async {
    return await _database.collection('devocionais').doc(devocionalId).update(info);
  }

  Future<void> deleteDevocional({required String devocionalId}) async {
    await _database.collection('toReview').get().then((res) async {
      if(res.docs.isNotEmpty) {
        for(var doc in res.docs) {
          if(doc.exists) {
            final data = doc.data();
            if(data["devocionalId"] == devocionalId) {
              await _database.collection('toReview').doc(doc.id).delete();
            }
          }
        }
      }
    });
    return await _database.collection('devocionais').doc(devocionalId).delete();
  }

  Future<void> sendPostApprovedNotification({required String devocionalId, required String ownerId, required String title}) async {
    final res = await _functions.httpsCallableFromUri(Uri.parse('https://sendpostapprovednotification-693460458631.us-central1.run.app')).call({
      'ownerId': ownerId,
      'postId': devocionalId,
      'postTitle': title
    });
    print(res.data);
  }
}