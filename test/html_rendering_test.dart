import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

void main() {
  testWidgets('provider descriptions render formatted HTML', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HtmlWidget(
            '<p>Provider <strong>description</strong></p>'
            '<ul><li>Installation</li><li>Maintenance</li></ul>',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      find.textContaining('Provider description', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Installation', findRichText: true), findsOneWidget);
    expect(find.text('Maintenance', findRichText: true), findsOneWidget);
  });

  testWidgets('custom page links remain tappable', (tester) async {
    String? tappedUrl;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HtmlWidget(
            '<p><a href="https://khidmaplus.com/terms">Read terms</a></p>',
            onTapUrl: (url) {
              tappedUrl = url;
              return true;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final link = find.text('Read terms', findRichText: true);
    // RichText fills the paragraph width; tap inside the actual link glyphs.
    await tester.tapAt(tester.getTopLeft(link) + const Offset(20, 8));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(tappedUrl, 'https://khidmaplus.com/terms');
  });
}
