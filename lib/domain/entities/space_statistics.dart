/// Space Statistics domain entity for Innerverse
library;

import 'package:equatable/equatable.dart';

import 'conversation.dart';

/// Space Statistics domain model
class SpaceStatistics extends Equatable {
  final int? id;
  final SpaceType spaceType;
  final int visitCount;
  final int totalTimeSpent;
  final int messageCount;
  final int conversationCount;
  final DateTime? lastVisitedAt;
  final DateTime? firstVisitedAt;

  const SpaceStatistics({
    this.id,
    required this.spaceType,
    this.visitCount = 0,
    this.totalTimeSpent = 0,
    this.messageCount = 0,
    this.conversationCount = 0,
    this.lastVisitedAt,
    this.firstVisitedAt,
  });

  /// Get time spent as formatted string
  String get timeSpentText {
    final hours = totalTimeSpent ~/ 3600;
    final minutes = (totalTimeSpent % 3600) ~/ 60;

    if (hours > 0) {
      return '$hours h ${minutes > 0 ? '$minutes min' : ''}';
    } else if (minutes > 0) {
      return '$minutes min';
    }
    return 'Less than a minute';
  }

  /// Get average time per visit (in seconds)
  double get averageTimePerVisit {
    if (visitCount == 0) return 0;
    return totalTimeSpent / visitCount;
  }

  /// Get average time per visit as text
  String get averageTimePerVisitText {
    final avgSeconds = averageTimePerVisit;
    if (avgSeconds == 0) return 'N/A';

    final minutes = (avgSeconds / 60).round();
    if (minutes > 0) {
      return '$minutes min';
    }
    return '${avgSeconds.round()} sec';
  }

  /// Get average messages per conversation
  double get averageMessagesPerConversation {
    if (conversationCount == 0) return 0;
    return messageCount / conversationCount;
  }

  /// Check if space has been visited
  bool get hasBeenVisited => visitCount > 0;

  /// Get space display name
  String get displayName => spaceType.displayName;

  /// Get space emoji
  String get emoji => spaceType.emoji;

  /// Create a copy with updated fields
  SpaceStatistics copyWith({
    int? id,
    SpaceType? spaceType,
    int? visitCount,
    int? totalTimeSpent,
    int? messageCount,
    int? conversationCount,
    DateTime? lastVisitedAt,
    DateTime? firstVisitedAt,
  }) {
    return SpaceStatistics(
      id: id ?? this.id,
      spaceType: spaceType ?? this.spaceType,
      visitCount: visitCount ?? this.visitCount,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      messageCount: messageCount ?? this.messageCount,
      conversationCount: conversationCount ?? this.conversationCount,
      lastVisitedAt: lastVisitedAt ?? this.lastVisitedAt,
      firstVisitedAt: firstVisitedAt ?? this.firstVisitedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        spaceType,
        visitCount,
        totalTimeSpent,
        messageCount,
        conversationCount,
        lastVisitedAt,
        firstVisitedAt,
      ];
}

/// Summary of all space statistics
class SpaceStatisticsSummary extends Equatable {
  final int totalVisits;
  final int totalTimeSpent;
  final int totalMessages;
  final int totalConversations;
  final SpaceType? mostVisitedSpace;
  final SpaceType? mostTimeSpentSpace;
  final List<SpaceStatistics> allStats;

  const SpaceStatisticsSummary({
    this.totalVisits = 0,
    this.totalTimeSpent = 0,
    this.totalMessages = 0,
    this.totalConversations = 0,
    this.mostVisitedSpace,
    this.mostTimeSpentSpace,
    this.allStats = const [],
  });

  /// Get total time spent as formatted string
  String get totalTimeSpentText {
    final hours = totalTimeSpent ~/ 3600;
    final minutes = (totalTimeSpent % 3600) ~/ 60;

    if (hours > 0) {
      return '$hours h ${minutes > 0 ? '$minutes min' : ''}';
    } else if (minutes > 0) {
      return '$minutes min';
    }
    return 'Less than a minute';
  }

  /// Get percentage of visits for a space
  double getVisitPercentage(SpaceType space) {
    if (totalVisits == 0) return 0;
    final stats = allStats.firstWhere(
      (s) => s.spaceType == space,
      orElse: () => SpaceStatistics(spaceType: space),
    );
    return (stats.visitCount / totalVisits) * 100;
  }

  /// Get percentage of time for a space
  double getTimePercentage(SpaceType space) {
    if (totalTimeSpent == 0) return 0;
    final stats = allStats.firstWhere(
      (s) => s.spaceType == space,
      orElse: () => SpaceStatistics(spaceType: space),
    );
    return (stats.totalTimeSpent / totalTimeSpent) * 100;
  }

  @override
  List<Object?> get props => [
        totalVisits,
        totalTimeSpent,
        totalMessages,
        totalConversations,
        mostVisitedSpace,
        mostTimeSpentSpace,
        allStats,
      ];
}
