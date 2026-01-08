import 'package:flutter/material.dart';

class EducationListEditor extends StatefulWidget {
  final List<Map<String, dynamic>> initialEducation;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;

  const EducationListEditor({
    super.key,
    required this.initialEducation,
    required this.onChanged,
  });

  @override
  State<EducationListEditor> createState() => _EducationListEditorState();
}

class _EducationListEditorState extends State<EducationListEditor> {
  late List<Map<String, dynamic>> _education;

  @override
  void initState() {
    super.initState();
    _education = List.from(widget.initialEducation);
  }

  void _addEducation() {
    showDialog(
      context: context,
      builder: (context) => _EducationDialog(
        onSave: (edu) {
          setState(() {
            _education.add(edu);
          });
          widget.onChanged(_education);
        },
      ),
    );
  }

  void _editEducation(int index) {
    showDialog(
      context: context,
      builder: (context) => _EducationDialog(
        initialValue: _education[index],
        onSave: (edu) {
          setState(() {
            _education[index] = edu;
          });
          widget.onChanged(_education);
        },
      ),
    );
  }

  void _removeEducation(int index) {
    setState(() {
      _education.removeAt(index);
    });
    widget.onChanged(_education);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Education', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: _addEducation,
            ),
          ],
        ),
        if (_education.isEmpty)
          const Text('No education added.', style: TextStyle(color: Colors.grey))
        else
          ..._education.asMap().entries.map((entry) {
            final index = entry.key;
            final edu = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(edu['institution'] ?? ''),
                subtitle: Text('${edu['degree'] ?? ''} ${edu['year'] != null ? '(${edu['year']})' : ''}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _editEducation(index)),
                    IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () => _removeEducation(index)),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}

class _EducationDialog extends StatefulWidget {
  final Map<String, dynamic>? initialValue;
  final ValueChanged<Map<String, dynamic>> onSave;

  const _EducationDialog({this.initialValue, required this.onSave});

  @override
  State<_EducationDialog> createState() => _EducationDialogState();
}

class _EducationDialogState extends State<_EducationDialog> {
  late TextEditingController _institutionController;
  late TextEditingController _degreeController;
  late TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _institutionController = TextEditingController(text: widget.initialValue?['institution'] ?? '');
    _degreeController = TextEditingController(text: widget.initialValue?['degree'] ?? '');
    _yearController = TextEditingController(text: widget.initialValue?['year']?.toString() ?? '');
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _degreeController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialValue == null ? 'Add Education' : 'Edit Education'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _institutionController,
            decoration: const InputDecoration(labelText: 'Institution/School'),
          ),
          TextField(
            controller: _degreeController,
            decoration: const InputDecoration(labelText: 'Degree/Course'),
          ),
          TextField(
            controller: _yearController,
            decoration: const InputDecoration(labelText: 'Year (Optional)'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_institutionController.text.isEmpty || _degreeController.text.isEmpty) return;
            widget.onSave({
              'institution': _institutionController.text,
              'degree': _degreeController.text,
              'year': _yearController.text,
            });
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
