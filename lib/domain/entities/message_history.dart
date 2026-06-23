enum MessageSource {
  typed,
  symbol,
  phrase,
  aiExpanded,
}

class MessageEntry {
  final String id;
  final String text;
  final String profileId;
  final DateTime timestamp;
  final MessageSource source;

  const MessageEntry({
    required this.id,
    required this.text,
    required this.profileId,
    required this.timestamp,
    required this.source,
  });

  MessageEntry copyWith({
    String? id,
    String? text,
    String? profileId,
    DateTime? timestamp,
    MessageSource? source,
  }) {
    return MessageEntry(
      id: id ?? this.id,
      text: text ?? this.text,
      profileId: profileId ?? this.profileId,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'MessageEntry(id: $id, profileId: $profileId, source: $source, timestamp: $timestamp)';
}
