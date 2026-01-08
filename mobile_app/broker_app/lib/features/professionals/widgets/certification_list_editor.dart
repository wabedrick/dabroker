import 'package:flutter/material.dart';

class CertificationListEditor extends StatefulWidget {
  final List<Map<String, dynamic>> initialCertifications;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;

  const CertificationListEditor({
    super.key,
    required this.initialCertifications,
    required this.onChanged,
  });

  @override
  State<CertificationListEditor> createState() => _CertificationListEditorState();
}

class _CertificationListEditorState extends State<CertificationListEditor> {
  late List<Map<String, dynamic>> _certifications;

  @override
  void initState() {
    super.initState();
    _certifications = List.from(widget.initialCertifications);
  }

  void _addCertification() {
    showDialog(
      context: context,
      builder: (context) => _CertificationDialog(
        onSave: (cert) {
          setState(() {
            _certifications.add(cert);
          });
          widget.onChanged(_certifications);
        },
      ),
    );
  }

  void _editCertification(int index) {
    showDialog(
      context: context,
      builder: (context) => _CertificationDialog(
        initialValue: _certifications[index],
        onSave: (cert) {
          setState(() {
            _certifications[index] = cert;
          });
          widget.onChanged(_certifications);
        },
      ),
    );
  }

  void _removeCertification(int index) {
    setState(() {
      _certifications.removeAt(index);
    });
    widget.onChanged(_certifications);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Certifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: _addCertification,
            ),
          ],
        ),
        if (_certifications.isEmpty)
          const Text('No certifications added.', style: TextStyle(color: Colors.grey))
        else
          ..._certifications.asMap().entries.map((entry) {
            final index = entry.key;
            final cert = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(cert['name'] ?? ''),
                subtitle: Text('${cert['issuer'] ?? ''} ${cert['year'] != null ? '(${cert['year']})' : ''}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _editCertification(index)),
                    IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () => _removeCertification(index)),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}

class _CertificationDialog extends StatefulWidget {
  final Map<String, dynamic>? initialValue;
  final ValueChanged<Map<String, dynamic>> onSave;

  const _CertificationDialog({this.initialValue, required this.onSave});

  @override
  State<_CertificationDialog> createState() => _CertificationDialogState();
}

class _CertificationDialogState extends State<_CertificationDialog> {
  late TextEditingController _nameController;
  late TextEditingController _issuerController;
  late TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialValue?['name'] ?? '');
    _issuerController = TextEditingController(text: widget.initialValue?['issuer'] ?? '');
    _yearController = TextEditingController(text: widget.initialValue?['year']?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issuerController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialValue == null ? 'Add Certification' : 'Edit Certification'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Certification Name'),
          ),
          TextField(
            controller: _issuerController,
            decoration: const InputDecoration(labelText: 'Issuing Organization'),
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
            if (_nameController.text.isEmpty || _issuerController.text.isEmpty) return;
            widget.onSave({
              'name': _nameController.text,
              'issuer': _issuerController.text,
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
