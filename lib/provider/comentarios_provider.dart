import 'package:bible_wise_admin/models/comentario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/devocional.dart';

class ComentariosProvider extends ChangeNotifier {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  bool isLoading = false;

  Future<List<Comentario>> getReportedComments() async {
    List<Comentario> comentarios = [];
    isLoading = true;
    notifyListeners();
    comentarios = await _getFromDb();
    comentarios.sort((a, b) => DateTime.parse(a.createdAt!).isBefore(DateTime.parse(b.createdAt!)) ? 1 : 0);
    isLoading = false;
    notifyListeners();

    return comentarios;
  }

  Future<Devocional?> getDevocional({required String devocionalId}) async {
    Devocional? devocional;
    await _database.collection('devocionais').where('id', isEqualTo: devocionalId).get().then((res) {
      if(res.docs.isNotEmpty) {
        final devocionalDb = res.docs.first;
        if(devocionalDb.exists) {
          devocional = Devocional.fromJson(devocionalDb.data());
        }
      }
    });

    return devocional;
  }

  Future<Map<String, dynamic>> getComment({required String devocionalId, required String commentId}) async {
    Map<String, dynamic> comment = {};
    await _database.collection('devocionais').doc(devocionalId).collection('comentarios').where('id', isEqualTo: commentId).get().then((res) {
      if(res.docs.isNotEmpty) {
        final commentDb = res.docs.first;
        if(commentDb.exists) {
          comment = commentDb.data();
        }
      }
    });

    return comment;
  }

  Future<void> removeComment({required String commentId, required String devocionalId}) async {
    await _database.collection('devocionais').doc(devocionalId).collection('comentarios').doc(commentId).delete();
    _database.collection('devocionais').doc(devocionalId).update({'qtdComentarios': FieldValue.increment(-1)});
    return await removeReportsFromComment(commentId: commentId);
  }

  Future<void> removeReport({required String reportId}) async {
    return await _database.collection('reports').doc(reportId).delete();
  }

  Future<void> removeReportsFromComment({required String commentId}) async {
    return await _database.collection('reports').where('commentId', isEqualTo: commentId).get().then((res) {
      if(res.docs.isNotEmpty) {
        for(var doc in res.docs) {
          _database.collection('reports').doc(doc.id).delete();
        }
      }
    });
  }

  Future<List<Comentario>> _getFromDb() async {
    try {
      List<Comentario> comentarios = [];
      await _database.collection('reports').orderBy('commentId').get().then((res) async {
        if(res.docs.isNotEmpty) {
          final docs = res.docs;
          for(var doc in docs) {
            if(doc.exists) {
              final comentario = Comentario.fromJson(doc.data());
              final commentDb = await getComment(devocionalId: comentario.devocionalId!, commentId: comentario.commentId!);
              comentario.comment = commentDb["comment"];
              comentario.autor = commentDb["name"];
              comentarios.add(comentario);
            }
          }
        }
      });

      return comentarios;
    }catch(e) {
      print('NAO FOI POSSIVEL RECUPERAR OS COMENTARIOS REPORTADOS $e');
      return [];
    }
  }
}