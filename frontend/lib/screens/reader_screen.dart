import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/story.dart';
import '../models/node_model.dart';
import '../theme/app_theme.dart';

class ReaderScreen extends StatefulWidget {
  final Story story;

  const ReaderScreen({Key? key, required this.story}) : super(key: key);

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late Future<List<NodeModel>> futureNodes;

  @override
  void initState() {
    super.initState();
    futureNodes = fetchStoryNodes(widget.story.id);
  }

  Future<List<NodeModel>> fetchStoryNodes(String storyId) async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/stories/$storyId/nodes'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => NodeModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load nodes: ${jsonResponse['message']}');
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.cyanAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.story.title,
          style: const TextStyle(color: AppTheme.textLight, fontSize: 18),
        ),
      ),
      body: FutureBuilder<List<NodeModel>>(
        future: futureNodes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.cyanAccent));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: AppTheme.magentaAccent)));
          }

          final nodes = snapshot.data ?? [];

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final node = nodes[index];
                      // Simple linear timeline rendering for MVP (Pre-Order Graph view)
                      return Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Timeline visual line + Avatar
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(node.authorAvatarUrl),
                                  backgroundColor: AppTheme.surface,
                                ),
                                if (index != nodes.length - 1)
                                  Container(
                                    height: 50,
                                    width: 2,
                                    color: AppTheme.cyanAccent.withOpacity(0.3),
                                    margin: const EdgeInsets.only(top: 8),
                                  )
                              ],
                            ),
                            const SizedBox(width: 16),
                            // Text bubble
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppTheme.surface,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '@${node.authorName}',
                                      style: const TextStyle(
                                        color: AppTheme.cyanAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      node.content,
                                      style: const TextStyle(
                                        color: AppTheme.textLight,
                                        fontSize: 18,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(Icons.how_to_vote, size: 14, color: AppTheme.textMuted),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${node.voteCount} votes',
                                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                                        ),
                                        const Spacer(),
                                        const Icon(Icons.call_split, size: 14, color: AppTheme.magentaAccent),
                                        const SizedBox(width: 4),
                                        const Text(
                                          'Branch',
                                          style: TextStyle(color: AppTheme.magentaAccent, fontSize: 12, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: nodes.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: AppTheme.textLight),
                  decoration: InputDecoration(
                    hintText: "Continue the timeline...",
                    hintStyle: const TextStyle(color: AppTheme.textMuted),
                    filled: true,
                    fillColor: AppTheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 25,
                backgroundColor: AppTheme.cyanAccent,
                child: IconButton(
                  icon: const Icon(Icons.send, color: AppTheme.background),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
