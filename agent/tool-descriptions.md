# Tool descriptions

Both tools are n8n workflows in the same project as the agent, started by a **When Executed by Another Workflow** trigger and published. Each returns one text field `result` containing the retrieved text or facts **together with their sources**.

## music_search – vector retrieval

| | |
|---|---|
| Workflow | `Music RAG - Tool: music_search v2` ([JSON](../workflows/)) |
| Input | `question` (string) – the user's question or a short description, e.g. "How was Thriller received by critics?" |
| Does | Embeds the input with Ollama `nomic-embed-text`, queries the Neo4j vector index `chunk_embeddings` (cosine, top 5) |
| Returns | 5 passages, each with artist, album, Wikipedia section, similarity score and Wikipedia URL |
| Agent should use it for | Sound, style, mood, production, recording story, background, reception, sales, influence; finding albums that match a description |

**Description given to the agent:**
```
Semantic search over Wikipedia articles about the 12 albums in the collection. Finds text by MEANING, not exact words. Use it for questions about how an album sounds, its style, mood, instruments in the mix, production and recording story, background, critical reception, sales and influence, and to find albums that match a description (e.g. "heavy slap bass", "synth-heavy"). Do NOT use it for exact credits (who produced or played) – use music_graph for that. Returns the 5 most relevant text passages, each with artist, album, section, similarity score and its Wikipedia source URL.
```

**Input description:**
```
The user's question or a short description of what to find, in natural language, e.g. "How was Thriller received by critics?"
```

**Output format (illustrative):**
```
[1] Michael Jackson - Thriller | section: Composition | score: 0.xxx | source: https://en.wikipedia.org/wiki/Thriller_(album)
Michael Jackson - Thriller (Composition): ...
```

## music_graph – graph retrieval

| | |
|---|---|
| Workflow | `Music RAG - Tool: music_graph v2` ([JSON](../workflows/)) |
| Input | `name` (string) – exactly one album title, artist name, genre or label, e.g. "Thriller", "Louis Johnson" |
| Does | Fixed, parameterised Cypher: finds the node(s) by name (case-insensitive) and returns all their relationships except chunks |
| Returns | One fact per line + the MusicBrainz release URLs the facts come from |
| Agent should use it for | Credits, people, collaborations, connections between albums; chained for multi-step questions |

**Description given to the agent:**
```
Looks up facts in the music graph built from MusicBrainz credits. Finds what is CONNECTED: who produced an album, who played which instrument on it, which albums an artist produced or played on, an album's main artist, genres and record label. Use it for any question about credits, people, collaborations or connections between albums. For multi-step questions, call it several times (e.g. an artist to get their albums, then each album to get its musicians). Returns graph facts as lines like "Louis Johnson -PLAYED_ON [bass]-> Thriller (1982)" plus the MusicBrainz release URLs they come from.
```

**Input description:**
```
Exactly one album title, artist name, genre or record label, e.g. "Thriller", "Quincy Jones" or "Louis Johnson". Not a full question.
```

**Output format (illustrative):**
```
Graph facts (MusicBrainz):
Thriller (1982) -PRODUCED_BY-> Quincy Jones
Louis Johnson -PLAYED_ON [bass]-> Thriller (1982)

Sources:
https://musicbrainz.org/release/<release-id>
```

**Why a fixed query and not LLM-written Cypher:** read-only and injection-safe, and far more reliable than asking the model to write Cypher against a schema it has to remember.
