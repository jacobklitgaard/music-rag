// Export a small data sample (run in database `music`, then download the result as CSV from the Query view)

// 1) Graph sample -> data/sample/graph-sample.csv
MATCH (s)-[r]->(e)
WHERE NOT s:Chunk AND (s.title IN ['Thriller', 'The Dude'] OR e.title IN ['Thriller', 'The Dude'])
RETURN labels(s)[0] AS from_label, coalesce(s.title, s.name) AS from,
       type(r) AS relationship, r.instrument AS instrument,
       labels(e)[0] AS to_label, coalesce(e.title, e.name) AS to
ORDER BY relationship, from
LIMIT 40;

// 2) Chunk sample (no embeddings) -> data/sample/chunks-sample.csv
MATCH (c:Chunk)-[:ABOUT]->(al:Album)
WHERE al.title IN ['Thriller', 'World Machine']
RETURN c.id, c.album, c.section, c.source, left(c.text, 300) AS text_preview, size(c.embedding) AS dimensions
ORDER BY c.id
LIMIT 10;
