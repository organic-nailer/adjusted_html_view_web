import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:uuid/uuid.dart';

/// A HTML viewer that can adjust html's display size.
class AdjustedHtmlView extends StatefulWidget {
  /// The HTML content to display.
  /// This will be passed into the [DivElement.innerHtml] setter.
  /// So, it should be a valid HTML string.
  /// This doesn't support perfect HTML that includes head, body, etc.
  final String htmlText;

  /// Whether you want to use the default style sheet.
  /// If you want to use your own style sheet,
  /// you can set this to false and provide your own style sheet.
  /// In the case of using your own style sheet,
  /// you need to prepare style sheets in [index.html].
  final bool useDefaultStyle;

  /// Classes to add to the Outer [DivElement].
  final List<String> customClasses;
  const AdjustedHtmlView(
      {Key? key,
      required this.htmlText,
      this.useDefaultStyle = true,
      this.customClasses = const []})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _AdjustedHtmlViewState();
}

class _AdjustedHtmlViewState extends State<AdjustedHtmlView> {
  final viewType = "div_" + const Uuid().v4();
  double htmlHeight = 10;
  final String rootId = "adjusted_html_view_div";
  Timer? initTimer;
  NodeValidator validator = NodeValidatorBuilder.common()
    ..allowInlineStyles()
    ..allowElement("a", attributes: ["*"])
    ..allowElement("img", attributes: ["*"])
    ..allowElement("style", attributes: ["*"]);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      final root = (window.document.getElementById(rootId) as DivElement?);
      if (root != null && root.clientHeight != 0) {
        print(root.clientHeight);
        setState(() {
          htmlHeight = root.clientHeight.toDouble();
        });
        timer.cancel();
      } else {
        print("wait");
      }
    });
  }

  @override
  void dispose() {
    initTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewType, (viewId) {
      final element = DivElement();
      element.id = rootId;
      element.classes.addAll(widget.customClasses);
      element.setInnerHtml(
          (widget.useDefaultStyle ? _getDefaultStyle(textTheme, rootId) : "") +
              widget.htmlText,
          validator: validator);
      element.style.height = "max-content";
      element.style.overflow = "hidden";
      element.style.userSelect = "text";
      return element;
    });
    return SizedBox(
      height: htmlHeight,
      child: HtmlElementView(
        viewType: viewType,
      ),
    );
  }
}

String _getDefaultStyle(TextTheme textTheme, String rootId) {
  return """
<style>
#$rootId img {
  max-width: 100%;
  height: auto;
}

#$rootId {
  font-family: 'Roboto', sans-serif;
  line-height: 1.5;
  color: ${_colorToHex(textTheme.bodyText1?.color) ?? "#000000"};
}
</style>
""";
}

String? _colorToHex(Color? color) {
  if (color == null) {
    return null;
  }
  final argb = color.value.toRadixString(16).padLeft(8, '0');

  /// CSSはRGBAなので順番を入れ替える
  return "#" + argb.substring(2, argb.length) + argb.substring(0, 2);
}
