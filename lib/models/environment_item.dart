import 'dart:convert';

class EnvironmentItem {
  String? key;
  String? initialValue;
  String? currentValue;
  bool disabled;
  EnvironmentItem({
    this.key,
    this.initialValue,
    this.currentValue,
    this.disabled: false,
  });

  EnvironmentItem copyWith({
    String? key,
    String? initialValue,
    String? currentValue,
    bool? isActive,
  }) {
    return EnvironmentItem(
      key: key ?? this.key,
      initialValue: initialValue ?? this.initialValue,
      currentValue: currentValue ?? this.currentValue,
      disabled: isActive ?? this.disabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'initialValue': initialValue,
      'currentValue': currentValue,
      'isActive': disabled,
    };
  }

  factory EnvironmentItem.fromMap(Map<String, dynamic> map) {
    return EnvironmentItem(
      key: map['key'],
      initialValue: map['initialValue'],
      currentValue: map['currentValue'],
      disabled: map['isActive'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EnvironmentItem.fromJson(String source) =>
      EnvironmentItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EnvironmentItem(key: $key, initialValue: $initialValue, currentValue: $currentValue, isActive: $disabled)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnvironmentItem &&
        other.key == key &&
        other.initialValue == initialValue &&
        other.currentValue == currentValue &&
        other.disabled == disabled;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        initialValue.hashCode ^
        currentValue.hashCode ^
        disabled.hashCode;
  }
}
