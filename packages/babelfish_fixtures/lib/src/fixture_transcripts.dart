import 'package:babelfish_core/babelfish_core.dart';

import 'fixture_languages.dart';

const fixtureTranscriptSegments = [
  TranscriptSegment(
    id: 'en-greeting',
    language: FixtureLanguages.english,
    text: 'Hello, welcome to Babel Fish.',
    startOffset: Duration.zero,
    endOffset: Duration(milliseconds: 1600),
    confidence: 0.99,
  ),
  TranscriptSegment(
    id: 'en-latency',
    language: FixtureLanguages.english,
    text: 'This offline demo keeps captions predictable.',
    startOffset: Duration(milliseconds: 1700),
    endOffset: Duration(milliseconds: 3800),
    confidence: 0.98,
  ),
  TranscriptSegment(
    id: 'am-greeting',
    language: FixtureLanguages.amharic,
    text: 'ሰላም፣ ወደ Babel Fish እንኳን በደህና መጡ።',
    startOffset: Duration.zero,
    endOffset: Duration(milliseconds: 2200),
    confidence: 0.97,
  ),
];
