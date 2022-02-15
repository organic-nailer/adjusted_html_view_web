import 'package:adjusted_html_view_web/adjusted_html_view_web.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
            child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                const Text("AdjustedHtmlViewSample",
                    style: TextStyle(fontSize: 40)),
                const SizedBox(height: 20),
                Card(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AdjustedHtmlView(
                    htmlText: sampleRichText,
                    htmlValidator: HtmlValidator.unsafe(),
                  ),
                )),
                const SizedBox(height: 20),
                const Text("Footer", style: TextStyle(fontSize: 40)),
              ],
            ),
          ),
        )),
      ),
    );
  }
}

const sampleRichText = """
<h1 id="hf19cd910e2">Heading 1</h1>
<h2 id="hb71f3638bb">Heading 2</h2>
<h3 id="h055e8f9099">Heading 3</h3>
<h4 id="h8c98ba6ad9">Heading 4</h4>
<h5 id="he1b3d42007">Heading 5</h5>
<p>Flutter is an open-source UI software development kit created by Google. It is used to develop cross platform applications for Android, iOS, Linux, Mac, Windows, Google Fuchsia, Web platform,[4] and the web from a single codebase.
<br>This is a <span style="font-size: 2.5em">Bigger Text</span>.<br>This is a <span style="font-size: 1.5em">Big Text</span>.<br>This is a <span style="font-size: 0.75em">Small Text</span>.<br>This text contains <strong>bold</strong>, <em>italic</em>, <u>underline</u>, <s>strikethrough</s>, <span style="background-color:#edad0b">background colored text</span>, <span style="color:#009250">colored text</span>, sub<sub>script</sub>, super<sup>script</sup> and <a href="unsafe:fastriver.dev">hyperlinks</a>.
<br><code>somethingDo()</code> is awesome function.
<br>align left</p>
<p style="text-align:center">align center</p>
<p style="text-align:right">align right</p>
<p style="text-align:justify">align stretch</p>
<blockquote>This is Quoted Text.</blockquote>
<pre><code>void main(List&lt;String&gt; args) {\n    print("This is a code block");\n}</code></pre>
<p>
<br><img src="https://via.placeholder.com/800x100?text=This+is+an+image" alt="This is an image.">
<br></p>
<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">天才なのでFlutter WebでWebViewを大きさぴったりにできるようになった<a href="https://t.co/zVpdpjDciL">https://t.co/zVpdpjDciL</a></p>&mdash; Fastriver (@Fastriver_org) <a href="https://twitter.com/Fastriver_org/status/1492411759743086593?ref_src=twsrc%5Etfw">February 12, 2022</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
<p><br></p>
<iframe width="560" height="315" src="https://www.youtube.com/embed/fq4N0hgOWzU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
<p><br></p>
<ol><li>ONE</li><li>TWO<ol><li>TWO-A</li></ol></li><li>THREE</li></ol>
<p><br></p>
<ul><li>Android</li><li>iOS</li><li>Web<ul><li>PWA</li></ul></li></ul>
""";
