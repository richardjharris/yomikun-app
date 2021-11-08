# yomikun/app

Flutter application for browsing the Yomikun Japanese names database
(Android/iOS/web/desktop)

# Design

There are a few types of query you can do:
 - browse all names/readings (prefix search etc)
 - show stats for kanji first name
 - show stats for kanji surname
 - show stats for kana name (reverse)
 - full name

There could be a mode selector that toggles through these.
Some would be unavailable if the input is kanji.

Typing * or ? switches to wildcard mode.

---

Simpler mode (to start with) is just prompt user with
six buttons to choose the query type?

--

Also stats: most common names, unisex names, etc.

---

Pleco system: E (full-text) / E white (subject only) / C (pinyin)
 type santia and you get santian etc.
 type santiago: changes to E
 backspace: changes to C again.
 but if you manually select E, it stays that way.
 賛成: switches to C (can't change)
 similarly changes to E (full-text) if no titled results. this time it doesn't
  auto change back.

Pleco supports kanji, pinyin with or without tones, Pinyin + characters, English













