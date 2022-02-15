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

  /// Control which HTML tags are allowed.
  /// If it is null, [HtmlValidator.loose()] will be used.
  final HtmlValidator? htmlValidator;

  /// Classes to add to the Outer [DivElement].
  final List<String> customClasses;
  const AdjustedHtmlView(
      {Key? key,
      required this.htmlText,
      this.useDefaultStyle = true,
      this.htmlValidator,
      this.customClasses = const []})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _AdjustedHtmlViewState();
}

class _AdjustedHtmlViewState extends State<AdjustedHtmlView> {
  final viewType = "div_" + const Uuid().v4();

  /// 0だと描画処理が走らないようなので正の数を指定している
  double htmlHeight = 10;
  final String rootId = "adjusted_html_view_div";
  Timer? initTimer;
  final int initTimerIntervalms = 200;
  final int initTimerTimeoutms = 4000;
  int timerLimitCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initTimer =
        Timer.periodic(Duration(milliseconds: initTimerIntervalms), (timer) {
      final root = (window.document.getElementById(rootId) as DivElement?);
      if (root != null && root.clientHeight > htmlHeight) {
        setState(() {
          htmlHeight = root.clientHeight.toDouble();
        });
      }
      timerLimitCount++;
      if (timerLimitCount > initTimerTimeoutms / initTimerIntervalms) {
        timer.cancel();
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
          validator: widget.htmlValidator?.validator ??
              HtmlValidator.loose().validator);
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

/// NodeValidator wrapper.
class HtmlValidator {
  final NodeValidator validator;

  HtmlValidator.loose()
      : validator = NodeValidatorBuilder.common()
          ..allowInlineStyles()
          ..allowElement("a", attributes: ["*"])
          ..allowElement("img", attributes: ["*"])
          ..allowElement("style", attributes: ["*"]);

  /// Allow iframe and script for embedding.
  /// Don't use this for HTML retrieved from the network.
  HtmlValidator.unsafe()
      : validator = NodeValidatorBuilder.common()
          ..allowInlineStyles()
          ..allowElement("a", attributes: ["*"])
          ..allowElement("img", attributes: ["*"])
          ..allowElement("style", attributes: ["*"])
          ..allowElement("iframe", attributes: ["*"])
          ..allowElement("script", attributes: ["*"]);

  HtmlValidator.custom(this.validator);
}
