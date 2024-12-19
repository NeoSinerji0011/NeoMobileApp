import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:sigortadefterim/AppStyle.dart';

class MyRadioButton extends StatelessWidget {
  const MyRadioButton({
    this.label,
    this.padding,
    this.groupValue,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final int groupValue;
  final int value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) onChanged(value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            MyRadio<int>(
              activeColor: ColorData.renkMavi,
              groupValue: groupValue,
              value: value,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              onChanged: (int newValue) {
                onChanged(newValue);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(label,style:TextStyle(color:ColorData.renkMavi,fontSize: 17,fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

const double _kOuterRadius = 15.0;
const double _kInnerRadius = 10;

class MyRadio<T> extends StatefulWidget {
  const MyRadio({
    Key key,
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
    this.activeColor,
    this.materialTapTargetSize,
  }) : super(key: key);

  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final Color activeColor;
  final MaterialTapTargetSize materialTapTargetSize;

  @override
  _MyRadioState<T> createState() => _MyRadioState<T>();
}

class _MyRadioState<T> extends State<MyRadio<T>> with TickerProviderStateMixin {
  bool get _enabled => widget.onChanged != null;

  Color _getInactiveColor(ThemeData themeData) {
    return _enabled ? themeData.unselectedWidgetColor : themeData.disabledColor;
  }

  void _handleChanged(bool selected) {
    if (selected) widget.onChanged(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ThemeData themeData = Theme.of(context);
    Size size;
    switch (widget.materialTapTargetSize ?? themeData.materialTapTargetSize) {
      case MaterialTapTargetSize.padded:
        size = const Size(2 * kRadialReactionRadius + 8.0, 2 * kRadialReactionRadius + 8.0);
        break;
      case MaterialTapTargetSize.shrinkWrap:
        size = const Size(2 * kRadialReactionRadius, 2 * kRadialReactionRadius);
        break;
    }
    final BoxConstraints additionalConstraints = BoxConstraints.tight(size);
    return _RadioRenderObjectWidget(
      selected: widget.value == widget.groupValue,
      activeColor: widget.activeColor ?? themeData.toggleableActiveColor,
      inactiveColor: _getInactiveColor(themeData),
      onChanged: _enabled ? _handleChanged : null,
      additionalConstraints: additionalConstraints,
      vsync: this,
    );
  }
}

class _RadioRenderObjectWidget extends LeafRenderObjectWidget {
  const _RadioRenderObjectWidget({
    Key key,
    @required this.selected,
    @required this.activeColor,
    @required this.inactiveColor,
    @required this.additionalConstraints,
    this.onChanged,
    @required this.vsync,
  })  : assert(selected != null),
        assert(activeColor != null),
        assert(inactiveColor != null),
        assert(vsync != null),
        super(key: key);

  final bool selected;
  final Color inactiveColor;
  final Color activeColor;
  final ValueChanged<bool> onChanged;
  final TickerProvider vsync;
  final BoxConstraints additionalConstraints;

  @override
  _RenderRadio createRenderObject(BuildContext context) => _RenderRadio(
        value: selected,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        onChanged: onChanged,
        vsync: vsync,
        additionalConstraints: additionalConstraints,
      );

  @override
  void updateRenderObject(BuildContext context, _RenderRadio renderObject) {
    renderObject
      ..value = selected
      ..activeColor = activeColor
      ..inactiveColor = inactiveColor
      ..onChanged = onChanged
      ..additionalConstraints = additionalConstraints
      ..vsync = vsync;
  }
}

class _RenderRadio extends RenderToggleable {
  _RenderRadio({
    bool value,
    Color activeColor,
    Color inactiveColor,
    ValueChanged<bool> onChanged,
    BoxConstraints additionalConstraints,
    @required TickerProvider vsync,
  }) : super(
          value: value,
          tristate: false,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          onChanged: onChanged,
          additionalConstraints: additionalConstraints,
          vsync: vsync,
        );

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    paintRadialReaction(canvas, offset, size.center(Offset.zero));

    final Offset center = (offset & size).center;
    final Color radioColor = onChanged != null ? activeColor : inactiveColor;

    // Outer circle
    final Paint paint = Paint()
      ..color = Color.lerp(inactiveColor, radioColor, position.value)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, _kOuterRadius, paint);

    // Inner circle
    if (!position.isDismissed) {
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(center, _kInnerRadius * position.value, paint);
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config
      ..isInMutuallyExclusiveGroup = true
      ..isChecked = value == true;
  }
}
