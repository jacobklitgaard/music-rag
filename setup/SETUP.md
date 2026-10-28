# Setup – recreate the system

## Requirements

| Component | Version / note |
|---|---|
| Neo4j | Neo4j Desktop 2 with a local instance (tested on Neo4j 2026.10.0). Multiple databases are needed for `music`. |
| n8n | Self-hosted in Docker, **2.32.3 or later** (Agents builder). TODO: your version |
| Ollama | Running locally with `nomic-embed-text` |
| OpenAI | API key for the agent's model |

## 1. Ollama
```bash
ollama pull nomic-embed-text
```

## 2. Neo4j
1. In Neo4j Desktop: **Local instances → Create instance**, then start it.
2. Open **Query** and run [`neo4j-setup.cypher`](neo4j-setup.cypher) (create `music`, switch to it, then run the constraints and the vector index).

## 3. n8n (Docker)
```bash
docker run -d --name n8n --restart unless-stopped \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n:latest
```
n8n runs in Docker, while Neo4j and Ollama run on the host. All URLs in the workflows therefore use `host.docker.internal`:
- Neo4j: `http://host.docker.internal:7474/db/music/query/v2`
- Ollama: `http://host.docker.internal:11434/api/embed`

## 4. Import the workflows
Import all files in [`../workflows/`](../workflows/) (**Create workflow → ⋯ → Import from File**), then:
1. Create a **Basic Auth** credential (`neo4j` + your password) and select it on every Neo4j HTTP node.
2. **Publish** both tool workflows (`music_search v2`, `music_graph v2`). The agent always runs the published version.

## 5. Load the data
Open **Music RAG - Ingestion** and click **Execute workflow**. It takes a few minutes: MusicBrainz is limited to 1 request per second, and a few hundred chunks get embedded. Then run the verify queries at the bottom of `neo4j-setup.cypher`.

## 6. Create the agent
In the project: **Agents → Create Agent**.
- **Model:** OpenAI credential + the model in [`../agent/model.txt`](../agent/model.txt)
- **Instructions:** [`../agent/instructions.txt`](../agent/instructions.txt)
- **Tools → Add tool → Workflow:** `music_search v2` and `music_graph v2`, with the descriptions in [`../agent/tool-descriptions.md`](../agent/tool-descriptions.md)
- **Skills:** see [`../agent/skills.md`](../agent/skills.md)

Test in **Preview** with a new session, then **Publish**.

## Gotchas
- After changing a tool workflow, **publish it again**, and remove and re-add it in the agent. Otherwise the agent keeps the old version and its input schema.
- Start a **new session** after changing the agent's model.
- Neo4j Desktop and Ollama must be running when the agent is used.
