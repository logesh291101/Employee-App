class SupportRequestUtils {
  SupportRequestUtils._();

  static String mapStatusLabel(String statusCode) {
    switch (statusCode.trim()) {
      case '1':
        return 'Open';
      case '2':
        return 'In Progress';
      case '3':
        return 'Resolved';
      case '4':
        return 'Closed';
      case '5':
        return 'On Hold';
      case '6':
        return 'Pending';
      default:
        const knownLabels = {
          'Open',
          'In Progress',
          'Resolved',
          'Closed',
          'On Hold',
          'Pending',
        };
        if (knownLabels.contains(statusCode)) return statusCode;
        return statusCode.isNotEmpty ? statusCode : 'Open';
    }
  }

  static String formatCreatedDate(String rawDate) {
    final parsed = _parseDateTime(rawDate);
    if (parsed == null) return rawDate.isNotEmpty ? rawDate : '—';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${parsed.day.toString().padLeft(2, '0')} ${months[parsed.month - 1]} ${parsed.year}';
  }

  static String formatDateTime(String rawDate) {
    final parsed = _parseDateTime(rawDate);
    if (parsed == null) return rawDate.isNotEmpty ? rawDate : '—';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour =
        parsed.hour > 12 ? parsed.hour - 12 : (parsed.hour == 0 ? 12 : parsed.hour);
    final period = parsed.hour >= 12 ? 'PM' : 'AM';
    return '${parsed.day.toString().padLeft(2, '0')} ${months[parsed.month - 1]} ${parsed.year}, $hour:${parsed.minute.toString().padLeft(2, '0')} $period';
  }

  static DateTime? _parseDateTime(String rawDate) {
    if (rawDate.trim().isEmpty) return null;
    return DateTime.tryParse(rawDate.replaceFirst(' ', 'T'));
  }
}
