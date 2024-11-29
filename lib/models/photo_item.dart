class PhotoItem {
  final String path;
  final String description;
  final String frame;
  final DateTime dateAdded;

  PhotoItem({
    required this.path,
    this.description = '',
    this.frame = '',
    DateTime? dateAdded,
  }) : dateAdded = dateAdded ?? DateTime.now();

  PhotoItem copyWith({
    String? path,
    String? description,
    String? frame,
    DateTime? dateAdded,
  }) {
    return PhotoItem(
      path: path ?? this.path,
      description: description ?? this.description,
      frame: frame ?? this.frame,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}
