# Three example questions and results

TODO: run each question in a NEW session in the Agents builder Preview. Paste the agent's actual answer, the tool calls (from the Sessions tab) and the key retrieved lines. Add a screenshot of each to `../screenshots/` and link it.

---

## 1. Graph question – "Who played bass on Thriller?"

**Tool calls:** TODO e.g. `music_graph("Thriller")`

**Retrieved information (shortened):**
```
- **Louis Johnson** — bass
- **Steve Lukather** — bass

Sources:

- https://musicbrainz.org/release/747647c7-f8da-451e-9d79-f7fa1b198db2
```

**Agent's answer:**
> TODO paste

**Screenshot:** [`../screenshots/example-1.png`](../screenshots/example-1.png)

**Assessment:** TODO. Check: are the names exactly those in the graph? Is the source given? A typical good result: correct, sourced, no invented names. Note that credits are rolled up to album level, so the answer can't say which track each bassist played on.

---

## 2. Vector question – "Which album has the most experimental, synth-heavy sound?"

**Tool calls:** TODO e.g. `music_search("most experimental, synth-heavy sound")`

**Retrieved information (shortened):**
```
TODO paste the top passages: album, section, score, URL
```

**Agent's answer:**
> TODO paste

**Screenshot:** [`../screenshots/example-2.png`](../screenshots/example-2.png)

**Assessment:** TODO. Check: do the top passages actually talk about synthesizers? Does the answer stay within what the passages say? "Most" is a comparison over the whole collection, but the tool only returns the 5 best passages, so the agent cannot really compare all 12 albums. Worth noting.

---

## 3. Limitation – "Who played bass on Risqué?"

**Tool calls:** TODO e.g. `music_graph("Risqué")`, maybe `music_search(...)`

**Retrieved information (shortened):**
```
TODO paste – expected: producers (Bernard Edwards, Nile Rodgers) but no PLAYED_ON credits
```

**Agent's answer:**
> TODO paste

**Screenshot:** [`../screenshots/example-3.png`](../screenshots/example-3.png)

**Assessment (limitation):** MusicBrainz has no musician credits for the Risqué release used, so the graph cannot answer. TODO: describe what the agent did:
- **Good outcome:** it says the collection has no bass credit, or falls back to the Wikipedia text (Bernard Edwards was Chic's bassist and is likely named in the article) and cites it.
- **Failure:** it guesses a name without a source.

Either way this shows the graph is only as complete as its source, and why combining graph and vector retrieval matters.
