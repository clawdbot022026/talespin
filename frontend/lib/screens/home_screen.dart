import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/story.dart';
import '../theme/app_theme.dart';
import '../widgets/story_card.dart';
import '../screens/reader_screen.dart';
import '../screens/composer_screen.dart';
import '../screens/auth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Story>> futureStories;

  @override
  void initState() {
    super.initState();
    futureStories = fetchTrendingStories();
  }

  Future<List<Story>> fetchTrendingStories() async {
    // Assuming the Go backend is running locally
    final response = await http.get(Uri.parse('http://localhost:8080/api/stories/trending'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => Story.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load multiverses: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to connect to the Multiverse Engine');
    }
  }

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
            child: Consumer<AuthProvider>(
              builder: (context, auth, _) {
                return InkWell(
                  onTap: () async {
                    if (!auth.isAuthenticated) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthScreen(initialIsLogin: true),
                          fullscreenDialog: true,
                        ),
                      );
                    } else {
                      // Placeholder for Phase 2 User Profile Screen
                      auth.logout(); // Temp: Tap to logout
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: AppTheme.surface,
                    radius: 16,
                    backgroundImage: auth.isAuthenticated && auth.user?.avatarUrl != null
                        ? NetworkImage(auth.user!.avatarUrl)
                        : null,
                    child: !auth.isAuthenticated || auth.user?.avatarUrl == null
                        ? const Icon(Icons.person, size: 18, color: AppTheme.magentaAccent)
                        : null,
                  ),
                );
              }
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
              FutureBuilder<List<Story>>(
                future: futureStories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(50.0),
                        child: CircularProgressIndicator(color: AppTheme.cyanAccent),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: AppTheme.magentaAccent),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No multiverses found. Be the first to start one!',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                    );
                  }

                  return Column(
                    children: snapshot.data!.map((story) => StoryCard(
                          story: story,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ReaderScreen(story: story)),
                            );
                          },
                        )).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final auth = Provider.of<AuthProvider>(context, listen: false);
          
          if (!auth.isAuthenticated) {
             final didLogin = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthScreen(initialIsLogin: false),
                  fullscreenDialog: true,
                ),
              );
              if (didLogin != true) return;
          }

          if (!context.mounted) return;

          final shouldRefresh = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ComposerScreen(),
              fullscreenDialog: true,
            ),
          );

          if (shouldRefresh == true) {
            setState(() {
              futureStories = fetchTrendingStories();
            });
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('A new Multiverse was born.'), backgroundColor: AppTheme.cyanAccent),
              );
            }
          }
        },
        backgroundColor: AppTheme.magentaAccent,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}
