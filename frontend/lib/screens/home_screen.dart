import 'package:flutter/material.dart';
import '../models/story.dart';
import '../theme/app_theme.dart';
import '../widgets/story_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'TaleSpin',
          style: TextStyle(
            color: AppTheme.cyanAccent,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.0,
            fontSize: 28,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.textLight),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: AppTheme.surface,
              radius: 16,
              child: const Icon(Icons.person, size: 18, color: AppTheme.magentaAccent),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'Trending Multiverses',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              ...mockTrendingStories.map((story) => StoryCard(
                    story: story,
                    onTap: () {
                      // Navigate to Reader in next iteration
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppTheme.surface,
                          content: Text(
                            'Entering ${story.title}...',
                            style: const TextStyle(color: AppTheme.cyanAccent),
                          ),
                        ),
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.magentaAccent,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}
