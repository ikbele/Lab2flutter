// lib/screens/notes_screen.dart
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:provider/provider.dart';
import '../services/note_service.dart';
import '../widgets/note_item.dart';
import '../widgets/add_note_modal.dart';
import '../providers/auth_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NoteService _noteService = NoteService();
  List<Document> _notes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  // Function to fetch notes from the database
  Future<void> _fetchNotes() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user == null) {
      setState(() {
        _isLoading = false;
        _notes = [];
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Pass the user ID when fetching notes
      final fetchedNotes =
          await _noteService.getNotes(userId: authProvider.user!.$id);

      setState(() {
        _notes = fetchedNotes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching notes: $e');
      setState(() {
        _error = 'Failed to load notes. Please try again.';
        _isLoading = false;
      });
    }
  }

  // Show the add note dialog
  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AddNoteModal(
        onNoteAdded: _handleNoteAdded,
      ),
    );
  }

  // Add the new note to the state and avoid refetching
  void _handleNoteAdded(Map<String, dynamic> noteData) {
    // Create a temporary Document object
    final newNote = Document(
      $id: noteData['\$id'] ?? 'temp-id',
      $collectionId: 'notes',
      $databaseId: 'NotesDB',
      $createdAt: DateTime.now().toIso8601String(),
      $updatedAt: DateTime.now().toIso8601String(),
      $permissions: [],
      data: noteData,
    );

    setState(() {
      _notes = [newNote, ..._notes];
    });
  }

  void _handleNoteDeleted(String noteId) {
    setState(() {
      _notes = _notes.where((note) => note.$id != noteId).toList();
    });
  }

  Widget _buildEmptyNotesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You don't have any notes yet.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Tap the + button to create your first note!",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Notes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                ElevatedButton(
                  onPressed: _showAddNoteDialog,
                  child: const Text('+ Add Note'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Show loading indicator
            if (_isLoading && _notes.isEmpty)
              const Center(child: CircularProgressIndicator()),

            // Show error message
            if (_error != null && _notes.isEmpty)
              Center(
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),

            // Show notes list OR empty state
            if (!_isLoading || _notes.isNotEmpty)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchNotes,
                  child: _notes.isEmpty
                      ? _buildEmptyNotesView()
                      : ListView.builder(
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            return NoteItem(
                              note: _notes[index],
                              onNoteDeleted: _handleNoteDeleted,
                            );
                          },
                        ),
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _showAddNoteDialog,
      ),
    );
  }
}
