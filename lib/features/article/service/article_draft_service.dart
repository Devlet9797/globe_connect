import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/article_draft.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ArticleDraftService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> saveDraft({
    String? id,
    required String? title,
    required String? description,
    required String? content,
    required File? coverImage,
    required List<String> categories,
    required List<String> countries,
  }) async {
    try {
      print('Taslak kaydetme işlemi başladı');

      final user = _auth.currentUser;
      if (user == null) throw Exception('Kullanıcı oturum açmamış');
      print('Kullanıcı kontrolü yapıldı: ${user.uid}');

      String? base64Image;
      if (coverImage != null) {
        print('Kapak fotoğrafı işleniyor...');
        try {
          // Resmi yükle ve boyutunu küçült
          final bytes = await coverImage.readAsBytes();
          final image = img.decodeImage(bytes);
          if (image == null) throw Exception('Fotoğraf okunamadı');

          // Resmi maksimum 800x800 boyutuna küçült
          final resized = img.copyResize(
            image,
            width: 800,
            height: 800,
            maintainAspect: true,
          );

          // Base64'e çevir
          final jpegBytes = img.encodeJpg(resized, quality: 70);
          base64Image = base64Encode(jpegBytes);
          print('Kapak fotoğrafı Base64 formatına dönüştürüldü');
        } catch (e) {
          print('Kapak fotoğrafı işlenirken hata: $e');
          throw Exception('Kapak fotoğrafı işlenirken bir hata oluştu: $e');
        }
      }

      print('Taslak verisi hazırlanıyor...');
      final draft = ArticleDraft(
        title: title,
        description: description,
        content: content,
        coverImageBase64: base64Image,
        categories: categories,
        countries: countries,
        createdAt: DateTime.now(),
        userId: user.uid,
      );

      print('Firestore\'a taslak kaydediliyor...');
      String docId;
      if (id != null) {
        // Mevcut taslağı güncelle
        await _firestore
            .collection('article_drafts')
            .doc(id)
            .update(draft.toMap());
        docId = id;
        print('Taslak güncellendi. ID: $docId');
      } else {
        // Yeni taslak oluştur
        final docRef =
            await _firestore.collection('article_drafts').add(draft.toMap());
        docId = docRef.id;
        print('Yeni taslak oluşturuldu. ID: $docId');
      }

      return docId;
    } catch (e, stackTrace) {
      print('Taslak kaydedilirken hata oluştu: $e');
      print('Hata detayı: $stackTrace');
      throw Exception('Taslak kaydedilirken bir hata oluştu: $e');
    }
  }

  Future<String> publishDraft(String draftId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Kullanıcı oturum açmamış');

      // Taslağı al
      final draftDoc =
          await _firestore.collection('article_drafts').doc(draftId).get();
      if (!draftDoc.exists) throw Exception('Taslak bulunamadı');

      // Yayınlanmış makaleler koleksiyonuna ekle
      final publishedRef =
          await _firestore.collection('published_articles').add({
        ...draftDoc.data()!,
        'publishedAt': DateTime.now(),
      });

      // Taslağı sil
      await _firestore.collection('article_drafts').doc(draftId).delete();

      return publishedRef.id;
    } catch (e) {
      print('Makale yayınlanırken hata oluştu: $e');
      throw Exception('Makale yayınlanırken bir hata oluştu: $e');
    }
  }

  Stream<List<ArticleDraft>> getDrafts() {
    try {
      print('Taslakları getirme işlemi başladı');
      final user = _auth.currentUser;
      print('Mevcut kullanıcı: ${user?.uid}');

      if (user == null) {
        print('Kullanıcı oturum açmamış');
        throw Exception('Kullanıcı oturum açmamış');
      }

      return _firestore
          .collection('article_drafts')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) {
        print(
            'Firestore snapshot alındı. Döküman sayısı: ${snapshot.docs.length}');
        final drafts = snapshot.docs.map((doc) {
          print('Döküman verisi: ${doc.data()}');
          return ArticleDraft.fromMap(doc.data(), doc.id);
        }).toList();

        drafts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return drafts;
      });
    } catch (e, stackTrace) {
      print('Taslakları getirirken hata oluştu: $e');
      print('Hata detayı: $stackTrace');
      rethrow;
    }
  }

  Stream<List<ArticleDraft>> getPublishedArticles() {
    return _firestore
        .collection('published_articles')
        .orderBy('publishedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ArticleDraft.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> deleteDraft(String draftId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Kullanıcı oturum açmamış');

      await _firestore.collection('article_drafts').doc(draftId).delete();
    } catch (e) {
      throw Exception('Taslak silinirken bir hata oluştu: $e');
    }
  }
}
