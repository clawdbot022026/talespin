import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class ComposerScreen extends StatefulWidget {
  const ComposerScreen({Key? key}) : super(key: key);

  @override
  State<ComposerScreen> createState() => _ComposerScreenState();
}

class _ComposerScreenState extends State<ComposerScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _tagsController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _publishGenesis() async {
    final title = _titleController.text.trim();
    final tags = _tagsController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || tags.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required to forge a new multiverse.'), backgroundColor: AppTheme.magentaAccent),
      );
      return;
    }

    if (title.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title must be at least 3 characters.'), backgroundColor: AppTheme.magentaAccent),
      );
      return;
    }

    if (content.length < 50 || content.length > 280) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Genesis node must be between 50 and 280 characters.'), backgroundColor: AppTheme.magentaAccent),
      );
      return;
    }

    setState(() { _isSubmitting = true; });

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      final response = await http.post(
        Uri.parse('http://localhost:8080/api/stories'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.token}',
        },
        body: jsonEncode({
          'title': title,
          'tags': tags,
          'content': content,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        if (!mounted) return;
        Navigator.pop(context, true); // Return true to signal a refresh is needed
      } else {
        throw Exception(responseBody['error'] ?? 'Failed to weave the timeline');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anomaly detected: $e'), backgroundColor: AppTheme.magentaAccent),
      );
    } finally {
      if (mounted) setState(() { _isSubmitting = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textLight),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Forge Multiverse', style: TextStyle(color: AppTheme.cyanAccent)),
        actions: [
          _isSubmitting
              ? const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppTheme.magentaAccent, strokeWidth: 2))),
                )
              : TextButton(
                  onPressed: _publishGenesis,
                  child: const Text('PUBLISH', style: TextStyle(color: AppTheme.magentaAccent, fontWeight: FontWeight.bold)),
                )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Genesis Protocol', style: TextStyle(color: AppTheme.textMuted, fontSize: 12, letterSpacing: 2)),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: AppTheme.textLight, fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: "Story Title...",
                hintStyle: TextStyle(color: AppTheme.textMuted.withValues(alpha: 0.5), fontSize: 24),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tagsController,
              style: const TextStyle(color: AppTheme.cyanAccent, fontSize: 14),
              decoration: InputDecoration(
                hintText: "Tags (e.g. Fantasy, Dark, Magic)",
                hintStyle: TextStyle(color: AppTheme.cyanAccent.withValues(alpha: 0.3), fontSize: 14),
                border: InputBorder.none,
                icon: const Icon(Icons.tag, color: AppTheme.cyanAccent, size: 16),
              ),
            ),
            const Divider(color: AppTheme.surface),
            const SizedBox(height: 20),
            TextField(
              controller: _contentController,
              style: const TextStyle(color: AppTheme.textLight, fontSize: 18, height: 1.5),
              maxLines: null,
              maxLength: 280,
              decoration: InputDecoration(
                hintText: "Type the first words of a new universe...",
                hintStyle: TextStyle(color: AppTheme.textMuted.withValues(alpha: 0.5), fontSize: 18),
                border: InputBorder.none,
                counterStyle: const TextStyle(color: AppTheme.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
