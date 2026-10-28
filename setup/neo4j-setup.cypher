// Music RAG – Neo4j setup
// Run once, before the first ingestion. Then switch to the database `music` (":use music" or the database picker).
// Constraints and indexes survive the ingestion workflow's "Wipe Database" step.

CREATE DATABASE music IF NOT EXISTS;

// ---- run the rest in database `music` ----

CREATE CONSTRAINT album_mbid  IF NOT EXISTS FOR (n:Album)  REQUIRE n.mbid IS UNIQUE;
CREATE CONSTRAINT artist_mbid IF NOT EXISTS FOR (n:Artist) REQUIRE n.mbid IS UNIQUE;
CREATE CONSTRAINT genre_name  IF NOT EXISTS FOR (n:Genre)  REQUIRE n.name IS UNIQUE;
CREATE CONSTRAINT label_name  IF NOT EXISTS FOR (n:Label)  REQUIRE n.name IS UNIQUE;
CREATE CONSTRAINT chunk_id    IF NOT EXISTS FOR (n:Chunk)  REQUIRE n.id IS UNIQUE;

CREATE VECTOR INDEX chunk_embeddings IF NOT EXISTS
FOR (c:Chunk) ON (c.embedding)
OPTIONS { indexConfig: {
  `vector.dimensions`: 768,
  `vector.similarity_function`: 'cosine'
}};

// ---- verify after running the ingestion workflow ----

// Node counts per label
MATCH (n) RETURN labels(n)[0] AS label, count(*) AS count ORDER BY label;

// Credits and producers per album
MATCH (al:Album)
OPTIONAL MATCH (al)<-[p:PLAYED_ON]-()
OPTIONAL MATCH (al)-[:PRODUCED_BY]->(prod)
RETURN al.title, al.year, count(DISTINCT p) AS credits, collect(DISTINCT prod.name) AS producers
ORDER BY al.year;

// Chunks per album, and are they linked to the graph?
MATCH (c:Chunk) OPTIONAL MATCH (c)-[:ABOUT]->(al:Album)
RETURN c.album, collect(DISTINCT c.source) AS source, count(c) AS chunks, count(al) AS linked
ORDER BY c.album;
