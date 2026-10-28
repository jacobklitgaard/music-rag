# Skills

TODO: keep ONE of the two versions below and delete the other.

---

## Version A – no skills used

The agent uses no skills. All task instructions are in [`instructions.txt`](instructions.txt), because the agent has one clear job (answer questions about one collection) and only two tools. Skills would add little over the "How to work" section.

---

## Version B – skills used

Task-specific instructions live in three skills; `instructions.txt` keeps only the role and general guardrails.

### Credits lookup
- **Description:** Questions about who produced an album, who played which instrument, or which albums a person worked on.
- **Tools:** music_graph
- **Instructions:**
```
Call music_graph with the album or person named in the question. If the question spans several albums (e.g. "albums Quincy Jones produced"), first call music_graph with the person to get the albums, then call it once per album. List credits as bullets grouped by instrument or role. Only list credits returned by the tool. End with the MusicBrainz source URLs.
```

### Sound and story
- **Description:** Questions about how an album sounds, its style, how it was recorded, its background, reception or influence.
- **Tools:** music_search
- **Instructions:**
```
Call music_search with the user's question. Answer in 2-5 sentences using only the returned passages, naming the album and section the information comes from. If the passages are about other albums than the one asked about, say the collection has no text on it. End with the Wikipedia source URLs.
```

### Recommend an album
- **Description:** Requests for an album that matches a description or resembles another album ("something with heavy slap bass", "like Thriller").
- **Tools:** music_search, then music_graph
- **Instructions:**
```
Call music_search with the description to find candidate albums. Pick at most 2 and explain why from the passages. Then call music_graph for each pick and add one notable credit (producer or bass player). Only recommend albums from the collection. End with all source URLs.
```
