class Announcement {
  String id;
  String title;
  String body;
  String authorName;
  String postedAt;

  Announcement(this.id, this.title, this.body, this.authorName, this.postedAt);
}

class AnnouncementScope {
  final String scopeContext;
  final String filterType;
  final String filterContent;

  AnnouncementScope({
    required this.scopeContext,
    required this.filterType,
    required this.filterContent,
  });

  factory AnnouncementScope.fromJson(Map<String, dynamic> json) {
    return AnnouncementScope(
      scopeContext: json['scope_context'] as String,
      filterType: json['filter_type'] as String,
      filterContent: json['filter_content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scope_context': scopeContext,
      'filter_type': filterType,
      'filter_content': filterContent,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnnouncementScope &&
        other.scopeContext == scopeContext &&
        other.filterType == filterType &&
        other.filterContent == filterContent;
  }

  @override
  int get hashCode => hashValues(scopeContext, filterType, filterContent);

  @override
  String toString() {
    return 'ScopeData(scopeContext: $scopeContext, filterType: $filterType, filterContent: $filterContent)';
  }
}