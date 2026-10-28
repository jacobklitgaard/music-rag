# Data

## Sources

| Source | Used for | Access |
|---|---|---|
| [MusicBrainz API](https://musicbrainz.org/doc/MusicBrainz_API) | Graph: release, main artist, label, genres, producer and instrument credits (release and track level) | Free, no key; max 1 request/s; `User-Agent` header required |
| [Wikipedia API](https://en.wikipedia.org/w/api.php) (English) | Vector: full plain-text article per album (`prop=extracts&explaintext=1`) | Free, no key |

The 12 albums and their exact Wikipedia titles are in [`sample/albums.json`](sample/albums.json) and in the **Album List** node of the ingestion workflow.

For each album, MusicBrainz is searched by release group and the **earliest official release** is used, so reissues don't give wrong years or reissue credits.

## Schema

### Nodes

| Label | Properties | Key | Count |
|---|---|---|---|
| `Album` | `mbid`, `title`, `key` ("Artist - Title"), `year` | `mbid` (unique) | 12 |
| `Artist` | `mbid`, `name` (people **and** bands) | `mbid` (unique) | TODO |
| `Genre` | `name` | `name` (unique) | TODO |
| `Label` | `name` | `name` (unique) | TODO |
| `Chunk` | `id`, `text`, `embedding` (768 floats), `section`, `source` (Wikipedia URL), `album`, `artist` | `id` (unique) | TODO |

### Relationships

| Type | From → To | Properties | Meaning |
|---|---|---|---|
| `BY` | Album → Artist | – | Main artist |
| `PRODUCED_BY` | Album → Artist | – | Producer |
| `PLAYED_ON` | Artist → Album | `instrument` | Played this (normalised) instrument on the album |
| `HAS_GENRE` | Album → Genre | – | MusicBrainz genre tag |
| `ON_LABEL` | Album → Label | – | Record label |
| `ABOUT` | Chunk → Album | – | Links vector chunks to the graph |

### Indexes and constraints
- Vector index `chunk_embeddings` on `Chunk.embedding`: 768 dimensions, cosine
- Unique constraints on `Album.mbid`, `Artist.mbid`, `Genre.name`, `Label.name`, `Chunk.id`

Fill in the TODO counts with:
```cypher
MATCH (n) RETURN labels(n)[0] AS label, count(*) AS count ORDER BY label;
```

### Normalisation
- One `Artist` label for people and bands, keyed on the MusicBrainz ID. Quincy Jones is one node, whether he is the main artist (The Dude) or the producer.
- Instruments mapped to a small set: `bass`, `guitar`, `keys`, `drums/percussion`, `horns`, `saxophone`, `vocals` (e.g. `electric bass guitar`, `fretless bass guitar` → `bass`).
- Credits rolled up from track to album level.

### Known data issues
- **Risqué** (0 musician credits) and **I Am** (1) – missing in MusicBrainz.
- **Toto IV** lists Bruce Dickinson as producer – a reissue credit stored at track level in MusicBrainz.

## Sample

[`sample/`](sample/) contains:
- `albums.json` – the 12 albums with their Wikipedia titles
- `graph-sample.csv` – TODO: export with the first query in [`../setup/export-sample.cypher`](../setup/export-sample.cypher)
- `chunks-sample.csv` – TODO: export with the second query (text only, embeddings left out)
