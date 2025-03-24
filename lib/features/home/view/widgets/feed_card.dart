import 'package:flutter/material.dart';
import '../../../article/model/article_draft.dart';
import '../../../article/view/widgets/country_flag.dart';
import 'dart:convert';

class FeedCard extends StatelessWidget {
  final ArticleDraft draft;

  const FeedCard({
    super.key,
    required this.draft,
  });

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Az önce';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} dakika önce';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} saat önce';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} gün önce';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.article_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Makale',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _formatTimeAgo(draft.createdAt),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (draft.countries.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CountryFlag(
                      countryName: draft.countries.first,
                      size: 24,
                    ),
                  ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  color: const Color(0xFF2C2C2C),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(
                            Icons.share_outlined,
                            color: Colors.white.withOpacity(0.7),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Paylaş',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    // TODO: Paylaşım işlemi
                  },
                ),
              ],
            ),
          ),
          if (draft.coverImageBase64 != null &&
              draft.coverImageBase64!.isNotEmpty)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  child: Image.memory(
                    base64Decode(draft.coverImageBase64!),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Resim yükleme hatası: $error');
                      return Container(
                        height: 200,
                        color: const Color(0xFF2C2C2C),
                        child: Center(
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.white.withOpacity(0.7),
                            size: 32,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (draft.categories.isNotEmpty)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Row(
                      children: draft.categories.map((category) {
                        String shortName = category;
                        if (category.contains(' ')) {
                          shortName = category
                              .split(' ')
                              .map((word) => word[0])
                              .join('');
                        } else if (category.length > 3) {
                          shortName = category.substring(0, 3).toUpperCase();
                        } else {
                          shortName = category.toUpperCase();
                        }

                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            shortName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          if (draft.title != null && draft.title!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                draft.title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (draft.description != null && draft.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16)
                  .copyWith(bottom: 16),
              child: Text(
                draft.description!,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
