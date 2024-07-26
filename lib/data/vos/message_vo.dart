import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_vo.g.dart';

@JsonSerializable()
class MessageVO {
  @JsonKey(name: "timeStamp")
  String? timeStamp;

  @JsonKey(name: "text")
  String? text;

  @JsonKey(name: "imageUrl")
  String? imageUrl;

  @JsonKey(name: "senderId")
  String? senderId;

  @JsonKey(name: "senderName")
  String? senderName;

  @JsonKey(name: "senderProfile")
  String? senderProfile;

  factory MessageVO.fromJson(Map<String, dynamic> json) =>
      _$MessageVOFromJson(json);

  Map<String, dynamic> toJson() => _$MessageVOToJson(this);

  MessageVO(
    this.timeStamp,
    this.text,
    this.imageUrl,
    this.senderId,
    this.senderName,
    this.senderProfile,
  );

  MessageVO copyWith({
    String? timeStamp,
    String? text,
    String? imageUrl,
    String? senderId,
    String? senderName,
    String? senderProfile,
  }) {
    return MessageVO(
      timeStamp ?? this.timeStamp,
      text ?? this.text,
      imageUrl ?? this.imageUrl,
      senderId ?? this.senderId,
      senderName ?? this.senderName,
      senderProfile ?? this.senderProfile,
    );
  }

  String getFormattedTime() {
    DateTime lastMessageDateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp ?? "0"));
    return DateFormat("hh:mm a").format(lastMessageDateTime);
  }

  String getLatestMessage(String userId) {
    if (userId == senderId) {
      if (text?.isEmpty ?? false) {
        return "You sent an image message.";
      } else {
        return "You: $text";
      }
    } else {
      if (text?.isEmpty ?? false) {
        return "$senderName sent an image message.";
      } else {
        return "$senderName: $text";
      }
    }
  }

  String getLastMessageTime() {
    DateTime lastMessageDateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp ?? "0"));
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

    if (lastMessageDateTime.year == now.year &&
        lastMessageDateTime.month == now.month &&
        lastMessageDateTime.day == now.day) {
      // If it's today, show time
      return DateFormat("hh:mm a").format(lastMessageDateTime);
    } else if (lastMessageDateTime.year == yesterday.year &&
        lastMessageDateTime.month == yesterday.month &&
        lastMessageDateTime.day == yesterday.day) {
      // If it's yesterday, show "yesterday"
      return "Yesterday";
    } else {
      // If it's neither today nor yesterday, show the date
      return DateFormat("dd.M.yy").format(lastMessageDateTime);
    }
  }
}
