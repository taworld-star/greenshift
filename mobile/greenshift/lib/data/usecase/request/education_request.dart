import 'dart:io';

class EducationRequest {
  final String title;
  final String content;
  final String category;
  final File? image;

  EducationRequest({
    required this.title,
    required this.content,
    required this.category,
    this.image,

  });
  
  // Multipart from data 
  Map<String, String> toFields() => {
      'title': title,
      'content': content,
      'category': category,
    };
}
