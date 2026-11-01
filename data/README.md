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
| `Artist` | `mbid`, `name` (people **and** bands) | `mbid` (unique) | 205 |
| `Genre` | `name` | `name` (unique) | 2 |
| `Label` | `name` | `name` (unique) | 9 |
| `Chunk` | `id`, `text`, `embedding` (768 floats), `section`, `source` (Wikipedia URL), `album`, `artist` | `id` (unique) | 171 |

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

Counts from a full ingestion run (1 November 2026), reproduced with:
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
- **Only 2 genres** – MusicBrainz has genre tags for few of these releases, so `HAS_GENRE` is sparse; style questions rely on the vector side.
- **`additional`, `guest` and `solo` appear as instruments** – they are credit attributes in MusicBrainz (e.g. "additional vocals"), not instruments; the normaliser should filter them (see [example 1](../examples/example-questions.md)).
- **"Production" sections are embedded** – the chunker skips Personnel/Credits, but some articles list credits under "Production" (e.g. World Machine), so a few chunks duplicate graph data (see [`chunks-sample.csv`](sample/chunks-sample.csv)).

## Sample

[`sample/`](sample/) contains:
- `albums.json` – the 12 albums with their Wikipedia titles
- [`graph-sample.csv`](sample/graph-sample.csv) – 40 relationships around Thriller and The Dude, exported with the first query in [`../setup/export-sample.cypher`](../setup/export-sample.cypher)
- [`chunks-sample.csv`](sample/chunks-sample.csv) – 10 chunks from Thriller and World Machine, exported with the second query (text preview only, embeddings left out)
