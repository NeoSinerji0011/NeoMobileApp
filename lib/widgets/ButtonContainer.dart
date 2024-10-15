import 'package:flutter/material.dart';
import 'package:sigortadefterim/AppStyle.dart';

class ButtonContainer extends StatelessWidget {
  final String title;
  final bool isFilled;

  ButtonContainer({@required this.title, @required this.isFilled});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: isFilled ? ColorData.renkSolukBeyaz : ColorData.renkMavi, border: Border.all(color: ColorData.renkMavi, width: 2), borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 0, 8),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 150,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(title, overflow: TextOverflow.ellipsis, style: isFilled ? TextStyleData.boldMavi18 : TextStyleData.boldBeyaz18),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: isFilled ? ColorData.renkMavi : ColorData.renkBeyaz, borderRadius: BorderRadius.circular(100)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset("assets/images/ic_right_arrow.png", color: isFilled ? ColorData.renkBeyaz : ColorData.renkMavi),
              ),
            ),
          )
        ],
      ),
    );
  }
}
