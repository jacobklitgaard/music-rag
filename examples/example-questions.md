# Three example questions and results

Each question was asked in a new session in the Agents builder Preview (model GPT-5.6 Terra), on 1 November 2026. Tool calls and tool output are copied from the Sessions tab; tool output is shortened where marked.

| # | Question | Tool used | Result |
|---|---|---|---|
| 1 | Who played bass on Thriller? | music_graph | Correct, sourced |
| 2 | Which album has the most experimental, synth-heavy sound? | music_search | Grounded, but based on a narrow sample |
| 3 | Who played bass on Risqué? | music_graph | **Limitation:** data gap; the agent refused to guess |

---

## 1. Graph question – "Who played bass on Thriller?"

**Tool call:** `music_graph` with input `query: "Thriller"`

**Retrieved information** (shortened, first 16 of the returned facts):
```
Graph facts (MusicBrainz):
Thriller (1982) -BY-> Michael Jackson
Thriller (1982) -ON_LABEL-> Epic
Howard Hewett -PLAYED_ON [additional]-> Thriller (1982)
James Ingram -PLAYED_ON [additional]-> Thriller (1982)
Louis Johnson -PLAYED_ON [bass]-> Thriller (1982)
Steve Lukather -PLAYED_ON [bass]-> Thriller (1982)
Jeff Porcaro -PLAYED_ON [drums/percussion]-> Thriller (1982)
Leon Ndugu Chancler -PLAYED_ON [drums/percussion]-> Thriller (1982)
Michael Jackson -PLAYED_ON [drums/percussion]-> Thriller (1982)
Paulinho da Costa -PLAYED_ON [drums/percussion]-> Thriller (1982)
Larry Williams -PLAYED_ON [flute]-> Thriller (1982)
Michael Jackson -PLAYED_ON [foot stomps]-> Thriller (1982)
Nelson Hayes -PLAYED_ON [foot stomps]-> Thriller (1982)
Steven Ray -PLAYED_ON [foot stomps]-> Thriller (1982)
Paul McCartney -PLAYED_ON [guest]-> Thriller (1982)
David Williams -PLAYED_ON [guitar]-> Thriller (1982)
...
```

**Agent's answer:**
> - Louis Johnson — bass
> - Steve Lukather — bass
>
> Sources:
> - https://musicbrainz.org/release/747647c7-f8da-451e-9d79-f7fa1b198db2

**Screenshot:** [`../screenshots/example-1.png`](../screenshots/example-1.png)

**Assessment:** Good. The answer contains exactly the two bass credits in the graph, nothing invented, and the MusicBrainz source. It picked the right tool and passed one album title, as the tool description asks. Steve Lukather is best known as a guitarist; the graph has him on bass because the credits come from track level, and that is an example of graph data beating general knowledge.
Two weaknesses are visible in the retrieved data:
- `[additional]` and `[guest]` are not instruments. MusicBrainz stores them as attributes of a credit (e.g. "additional vocals"), and the ingestion's Code node treats every attribute as an instrument. Fix: filter attributes such as `additional`, `guest` and `solo` out before normalising.
- Credits are rolled up to album level, so the agent cannot say which track each bassist played on.

---

## 2. Vector question – "Which album has the most experimental, synth-heavy sound?"

**Tool call:** `music_search` with input
`query: "Among the albums in this collection, which is most experimental and synth-heavy in sound? Compare electronic/synth experimentation and identify the strongest match."`

**Retrieved information** (top 5; text shortened):
```
[1] Prince and the Revolution - Purple Rain | section: Critical reception | score: 0.816
    "...its synthesis of electronic elements with organic instrumentation ... were identified by critics as distinguishing, even experimental factors."
[2] Prince and the Revolution - Purple Rain | section: Introduction | score: 0.814
    "...multiple layers of guitars, keyboards, electronic synthesizer effects, drum machines ... a grandiose, synthesized, and psychedelic substance..."
[3] Level 42 - World Machine | section: Introduction | score: 0.808
    "World Machine is the sixth studio album by the English jazz-funk band Level 42, released on 18 October 1985..."
[4] Prince and the Revolution - Purple Rain | section: Music and lyrics | score: 0.803
    "...guitars, keyboards, electronic synthesizer effects, drum machines ... a grandiose, synthesized ... psychedelic sheen..."
[5] Stevie Wonder - Songs in the Key of Life | section: Composition | score: 0.801
    "...a large range of genres including funk, jazz, R&B, progressive soul, classical (notably the synthesized string arrangement in "Village Ghetto Land") and pop."

Sources: https://en.wikipedia.org/wiki/Purple_Rain_(album), https://en.wikipedia.org/wiki/World_Machine, https://en.wikipedia.org/wiki/Songs_in_the_Key_of_Life
```

**Agent's answer:**
> Prince and the Revolution — Purple Rain is the strongest match. Its production layers keyboards, electronic-synth effects, and drum machines with guitars and full-band performances, giving it a grand, synthesized, psychedelic feel. Critics also singled out its blend of electronic and organic sounds as an experimental strength.
>
> Sources:
> - https://en.wikipedia.org/wiki/Purple_Rain_(album)

**Screenshot:** [`../screenshots/example-2.png`](../screenshots/example-2.png)

**Assessment:** The answer is fully grounded: "keyboards", "drum machines" and "psychedelic" come from passages [2] and [4], and the critics' point comes from [1]. Vector search found meaning, not just words. The passages talk about synthesis and experimentation even though the query wording differs.
The limitation is in the retrieval:
- 3 of the 5 hits are from the same album, so the agent compared only 3 of 12 albums. "Most experimental" is judged on a narrow sample.
- The scores are very close (0.801–0.816), so similarity separates relevant from loosely related text poorly.
- Hit [3] (World Machine) says nothing about synthesizers. It matched the general topic (1980s pop), not the question.

Possible fixes: return more hits (top 10–15) and keep only the best passage per album, so more albums enter the comparison.

---

## 3. Limitation – "Who played bass on Risqué?"

**Tool call:** `music_graph` with input `album: "Risqué"`

**Retrieved information** (complete):
```
Graph facts (MusicBrainz):
Risqué (1979) -BY-> Chic
Risqué (1979) -ON_LABEL-> Atlantic
Risqué (1979) -PRODUCED_BY-> Bernard Edwards
Risqué (1979) -PRODUCED_BY-> Nile Rodgers

Sources:
https://musicbrainz.org/release/d2ee38b2-4c30-41c6-9844-4d8706543d64
```

**Agent's answer:**
> I don't have a bass-player credit for Risqué in this collection's data.
>
> Sources:
> - https://musicbrainz.org/release/d2ee38b2-4c30-41c6-9844-4d8706543d64

**Screenshot:** [`../screenshots/example-3.png`](../screenshots/example-3.png)

**Assessment (limitation):** The graph has no `PLAYED_ON` credits for Risqué, because MusicBrainz has no musician credits for the release used. This is a known data gap (see [`../data/README.md`](../data/README.md)).
- **What worked:** the guardrail. The agent did not guess. Bernard Edwards, who appears in the result as producer, was in fact Chic's bassist, and a model answering from general knowledge would likely have named him. The agent followed "answer ONLY from tool results" and said it lacked the data.
- **What did not:** the agent stopped after one tool. It did not try `music_search`, which searches the Wikipedia text about the album, where the band's line-up may be described. The graph alone is only as complete as its source.

Possible fixes: add an instruction such as "if music_graph has no credit for the question, try music_search before saying you don't know", and enrich the graph with band membership (`MEMBER_OF` with instrument, available in MusicBrainz).

