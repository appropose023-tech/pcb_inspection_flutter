class InspectionResult {
  final List<PCBDefect> defects;

  InspectionResult({required this.defects});

  factory InspectionResult.fromJson(Map<String, dynamic> json) {
    final list = (json["defects"] ?? []) as List;

    return InspectionResult(
      defects: list.map((d) => PCBDefect.fromJson(d)).toList(),
    );
  }
}

class PCBDefect {
  final int x;
  final int y;
  final int w;
  final int h;

  PCBDefect({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  factory PCBDefect.fromJson(Map<String, dynamic> json) {
    return PCBDefect(
      x: json["x"] ?? 0,
      y: json["y"] ?? 0,
      w: json["w"] ?? 0,
      h: json["h"] ?? 0,
    );
  }
}
