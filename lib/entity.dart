class Message {
  String username;
  String text;
  dynamic timestamp;

  Message(
      {required this.username, required this.text, required this.timestamp});

  // Factory constructor to create a Message instance from a map (JSON).
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      username: json['username'] as String,
      text: json['text'] as String,
      timestamp: json['timestamp'] as dynamic,
    );
  }

  // Method to convert Message instance to a map (JSON).
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'text': text,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'Username: $username, Text: $text, Timestamp: $timestamp';
  }
}
