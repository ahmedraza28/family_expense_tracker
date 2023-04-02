import 'package:flutter/material.dart';

class CustomChipsList extends StatelessWidget {
  final List<String> chipLabels;
  final double chipHeight;
  final double chipGap;
  final double? chipWidth;
  final double fontSize;
  final bool isScrollable;
  final FontWeight? fontWeight;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final Color labelColor;

  const CustomChipsList({
    required this.chipLabels,
    required this.chipHeight,
    super.key,
    this.isScrollable = false,
    this.chipGap = 0.0,
    this.fontWeight,
    this.chipWidth,
    this.fontSize = 12,
    this.borderWidth = 1.0,
    this.borderColor = const Color.fromRGBO(122, 122, 122, 1),
    this.backgroundColor = Colors.white,
    this.labelColor = const Color.fromRGBO(122, 122, 122, 1),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: chipHeight,
      child: isScrollable
          ? ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: chipLabels.length,
              separatorBuilder: (ctx, i) => SizedBox(width: chipGap),
              itemBuilder: (ctx, i) => buildChipListItem(i),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < chipLabels.length; i++)
                  Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0 : chipGap),
                    child: buildChipListItem(i),
                  )
              ],
            ),
    );
  }

  Widget buildChipListItem(int i) {
    return CustomChipWidget(
      width: chipWidth,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      content: chipLabels[i],
      labelStyle: TextStyle(
        color: labelColor,
        fontSize: fontSize,
        height: 1,
        fontWeight: fontWeight,
      ),
    );
  }
}

class CustomChipWidget extends StatelessWidget {
  const CustomChipWidget({
    required this.content,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.backgroundColor = Colors.white,
    this.borderColor = const Color.fromRGBO(122, 122, 122, 1),
    this.borderWidth = 1,
    this.labelStyle = const TextStyle(
      color: Color.fromRGBO(122, 122, 122, 1),
      fontSize: 12,
      height: 1,
    ),
    super.key,
  });

  final double? width;
  final double? height;
  final String content;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final Color borderColor;
  final double borderWidth;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Center(
        child: Text(
          content,
          style: labelStyle,
        ),
      ),
    );
  }
}
