import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:greenshift/data/repository/auth_repository.dart';
import 'package:greenshift/data/repository/education_repository.dart';
import 'package:greenshift/data/model/educational_content_model.dart';
import 'package:greenshift/data/usecase/request/education_request.dart';
import 'package:greenshift/presentation/widgets/green_button.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});
  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}
class _AdminDashboardPageState extends State<AdminDashboardPage> {

  final EducationRepository _repository = EducationRepository();
  List<EducationalContentModel> _contents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  
  /// Mengambil semua konten dari backend
  Future<void> _loadContents() async {
    setState(() => _isLoading = true);
    
    final result = await _repository.getAll();
    
    setState(() {
      _contents = result?.data ?? [];
      _isLoading = false;
    });
  }
  /// Menampilkan form tambah/edit
  void _showForm({EducationalContentModel? content}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContentFormSheet(
        content: content,
        onSaved: () {
          Navigator.pop(context);
          _loadContents(); // Refresh list 
        },
      ),
    );
  }


  void _confirmDelete(EducationalContentModel content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Konten?'),
        content: Text('Yakin ingin menghapus "${content.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final success = await _repository.delete(content.id);
              
              if (success) {
                _loadContents();
                _showMessage('Konten berhasil dihapus', Colors.green);
              } else {
                _showMessage('Gagal menghapus konten', Colors.red);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
  /// Logout admin
  void _logout() async {
    // Tampilkan loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    try {
      await AuthRepository().logout();
    } catch (e) {
      debugPrint('Logout error: $e');
    }

    if (mounted) {
      Navigator.pop(context); // Tutup loading
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
  /// snackbar
  void _showMessage(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: color),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }


  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, left: 24, right: 16, bottom: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Admin',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Kelola Konten Edukasi',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }
    if (_contents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('Belum ada konten',
                style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadContents,
      color: Colors.green,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _contents.length,
        itemBuilder: (context, index) => _buildCard(_contents[index]),
      ),
    );
  }
  /// Card untuk setiap konten
  Widget _buildCard(EducationalContentModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey.shade200,
              child: item.image != null
                  ? Image.network(item.image!, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.image, color: Colors.grey.shade400))
                  : Icon(Icons.image, color: Colors.grey.shade400),
            ),
          ),
          const SizedBox(width: 12),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                _buildBadge(item.category),
              ],
            ),
          ),
          
          // Actions
          IconButton(
            onPressed: () => _showForm(content: item),
            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
          ),
          IconButton(
            onPressed: () => _confirmDelete(item),
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }
  /// Badge kategori
  Widget _buildBadge(String category) {
    final colors = {
      'organik': Colors.green,
      'anorganik': Colors.blue,
      'b3': Colors.red,
    };
    final labels = {
      'organik': 'Organik',
      'anorganik': 'Anorganik', 
      'b3': 'B3 (Berbahaya)',
    };
    
    final color = colors[category] ?? Colors.grey;
    final label = labels[category] ?? category;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
    );
  }
}


class ContentFormSheet extends StatefulWidget {
  final EducationalContentModel? content; // null = tambah baru
  final VoidCallback onSaved;
  const ContentFormSheet({
    super.key,
    this.content,
    required this.onSaved,
  });
  @override
  State<ContentFormSheet> createState() => _ContentFormSheetState();
}
class _ContentFormSheetState extends State<ContentFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final EducationRepository _repository = EducationRepository();
  String _category = 'organik';
  File? _image;
  bool _isLoading = false;
  
  final List<Map<String, String>> _categories = [
    {'key': 'organik', 'label': 'Organik'},
    {'key': 'anorganik', 'label': 'Anorganik'},
    {'key': 'b3', 'label': 'B3 (Berbahaya)'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.content != null) {
      _titleController.text = widget.content!.title;
      _contentController.text = widget.content!.content;
      _category = widget.content!.category;
    }
  }
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Gambar dari galeri
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      setState(() => _image = File(file.path));
    }
  }
  /// Menyimpan ke backend
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // Buat request object
    final request = EducationRequest(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      category: _category,
      image: _image,
    );
    // Memanggil API sesuai mode (create/update)
    bool success;
    if (widget.content != null) {
      // UPDATE
      success = await _repository.update(widget.content!.id, request);
    } else {
      // CREATE
      success = await _repository.create(request);
    }
    
    print("Save result: $success"); // Debug
    
    setState(() => _isLoading = false);
    
    if (success && mounted) {
      widget.onSaved(); 
    } else if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan. Periksa koneksi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.content != null;
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              isEdit ? 'Edit Konten' : 'Tambah Konten',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          
          const Divider(height: 1),
          
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input Judul
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Judul Artikel',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Judul wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    // Dropdown Kategori
                    DropdownButtonFormField<String>(
                      value: _category,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: _categories
                          .map((c) => DropdownMenuItem(
                                value: c['key'],
                                child: Text(c['label']!),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _category = v!),
                    ),
                    const SizedBox(height: 16),
                    // Input Konten
                    TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Isi Konten',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 6,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Konten wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    // Image Picker
                    const Text('Gambar (Opsional)',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade50,
                        ),
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(_image!, fit: BoxFit.cover),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate,
                                      size: 40, color: Colors.grey.shade400),
                                  const SizedBox(height: 8),
                                  Text('Tap untuk pilih gambar',
                                      style:
                                          TextStyle(color: Colors.grey.shade600)),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Simpan 
                    GreenButton(
                      text: isEdit ? 'Update Konten' : 'Simpan Konten',
                      isLoading: _isLoading,
                      onPressed: _save,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}