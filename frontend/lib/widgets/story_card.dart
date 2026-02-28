import 'package:flutter/material.dart';
import '../models/story.dart';
import '../theme/app_theme.dart';

class StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;

  const StoryCard({Key? key, required this.story, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.cyanAccent.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Avatar & Author
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(story.authorAvatarUrl),
                    radius: 16,
                    backgroundColor: AppTheme.background,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    story.authorName,
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.auto_graph, color: AppTheme.cyanAccent, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '+${story.weeklyVoteVelocity} velocity',
                    style: const TextStyle(color: AppTheme.cyanAccent, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                story.title,
                style: const TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              // Tags & Stats 
              Row(
                children: [
                  ...story.tags.map((tag) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.magentaAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.magentaAccent.withOpacity(0.3)),
                      ),
                      child: Text(
                        '#$tag',
                        style: const TextStyle(
                          color: AppTheme.magentaAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )).toList(),
                  const Spacer(),
                  Text(
                    '${story.totalNodes} Nodes Deep',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
