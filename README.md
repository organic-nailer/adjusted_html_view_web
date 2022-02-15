<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

**THIS PACKAGE WORKS ONLY ON THE WEB.**

## Features

This package provides a more natural HTML display with Flutter on the Web. 
Because it is displayed in a Platform View instead of an iframe, you get the following benefits:

- Display according to the height of HTML display
  - ex) possible to mix HTML in Column
- Text selection
- Natural scrolling
- Custom CSS

Try it on: https://organic-nailer.github.io/adjusted_html_view_web/#/

### This package is for

- Developers that are using Flutter on the Web
- want to use HTML for parts that cannot be expressed by widgets
- want to display Rich Text passed by CMS etc

### This package is **NOT** for

- Developers that are using Flutter on Mobile or Desktop
- want to display specific sites
- want to display contents with WebView

## Usage

Use `AdjustedHtmlView` with passing richText string to `htmlText`.
You can select the security level by `HtmlValidator`.

```dart
const sampleRichText = """
<h1 id="hf19cd910e2">Heading 1</h1>
<p>Flutter is an open-source UI software development kit created by Google.</p>
""";

AdjustedHtmlView(
    htmlText: sampleRichText,
    htmlValidator: HtmlValidator.loose(),
)
```

## Additional information

### Impossible now

- Placing multiple `AdjustedHtmlView` on one screen
