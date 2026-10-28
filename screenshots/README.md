# Screenshots

TODO: add these files (macOS: Cmd+Shift+4 and drag a region). Make each workflow readable: zoom so node names and sticky notes can be read.

| File | Shows |
|---|---|
| `01-ingestion.png` | **Data ingestion** workflow, whole canvas with sticky notes |
| `02-tool-music-search.png` | **Vector retrieval** tool workflow |
| `03-tool-music-graph.png` | **Graph retrieval** tool workflow |
| `04-agent-config.png` | Agents builder: model + instructions |
| `05-agent-tools.png` | Agents builder: the two connected workflow tools (and skills, if used) |
| `06-neo4j-graph.png` | Neo4j Query: e.g. the Quincy Jones network (query in [`../setup/export-sample.cypher`](../setup/export-sample.cypher) or below) |
| `example-1.png` … `example-3.png` | The three example questions: chat answer + tool calls from the Sessions tab |

Query for `06-neo4j-graph.png`:
```cypher
MATCH (q:Artist {name:'Quincy Jones'})<-[r1:PRODUCED_BY]-(al:Album)
OPTIONAL MATCH (b:Artist)-[r2:PLAYED_ON {instrument:'bass'}]->(al)
RETURN q, r1, al, b, r2
```
