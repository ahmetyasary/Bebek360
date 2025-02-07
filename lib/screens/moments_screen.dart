import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/baby_provider.dart';
import '../services/photo_service.dart';
import '../models/moment.dart';
import '../models/baby.dart';

class MomentsScreen extends StatelessWidget {
  const MomentsScreen({super.key});

  Widget _buildMomentCard(
    BuildContext context, {
    required String title,
    required String date,
    required String imageUrl,
    String? description,
    List<String>? tags,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: const Icon(
                  Icons.broken_image,
                  size: 64,
                  color: Colors.grey,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
                if (tags != null && tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: tags.map((tag) {
                      return Chip(
                        label: Text(
                          tag,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        side: BorderSide.none,
                        padding: const EdgeInsets.all(0),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  // TODO: Düzenleme işlevi
                },
                icon: const Icon(Icons.edit),
                label: const Text('Düzenle'),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Paylaşma işlevi
                },
                icon: const Icon(Icons.share),
                label: const Text('Paylaş'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumCard(
    BuildContext context, {
    required String title,
    required String imageUrl,
    required int photoCount,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.network(
            imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                color: Colors.grey[300],
                child: const Icon(
                  Icons.broken_image,
                  size: 48,
                  color: Colors.grey,
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$photoCount fotoğraf',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Üst Butonlar
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    // TODO: Yeni anı ekleme
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Yeni Anı'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                onPressed: () {
                  // TODO: Albüm oluşturma
                },
                icon: const Icon(Icons.photo_album),
                tooltip: 'Albüm Oluştur',
              ),
            ],
          ),

          // Albümler
          const SizedBox(height: 24),
          const Text(
            'Albümler',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 200,
                  child: _buildAlbumCard(
                    context,
                    title: 'İlk Aylar',
                    imageUrl: 'https://example.com/photo1.jpg',
                    photoCount: 24,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 200,
                  child: _buildAlbumCard(
                    context,
                    title: 'İlk Adımlar',
                    imageUrl: 'https://example.com/photo2.jpg',
                    photoCount: 15,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 200,
                  child: _buildAlbumCard(
                    context,
                    title: 'Doğum Günü',
                    imageUrl: 'https://example.com/photo3.jpg',
                    photoCount: 32,
                  ),
                ),
              ],
            ),
          ),

          // Son Anılar
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Son Anılar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Tüm anıları görüntüle
                },
                icon: const Icon(Icons.photo_library),
                label: const Text('Tümü'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildMomentCard(
            context,
            title: 'İlk Gülümseme',
            date: '15.01.2024',
            imageUrl: 'https://example.com/smile.jpg',
            description: 'Bugün ilk kez gülümsedi! Çok tatlıydı.',
            tags: ['İlk Kez', 'Gülümseme', 'Mutlu Anlar'],
          ),
          const SizedBox(height: 8),
          _buildMomentCard(
            context,
            title: 'Park Gezisi',
            date: '14.01.2024',
            imageUrl: 'https://example.com/park.jpg',
            description: 'İlk kez parka gittik. Salıncakları çok sevdi.',
            tags: ['Park', 'Dışarıda', 'Eğlence'],
          ),
          const SizedBox(height: 8),
          _buildMomentCard(
            context,
            title: 'Kahvaltı Keyfi',
            date: '13.01.2024',
            imageUrl: 'https://example.com/breakfast.jpg',
            description: 'İlk kez kendi başına kaşık kullanmaya çalıştı.',
            tags: ['Yemek', 'Gelişim', 'Kahvaltı'],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Hızlı fotoğraf çekme
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
