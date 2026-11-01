# Workflows

Exported n8n workflows (import with **Create workflow → ⋯ → Import from File**).

| File | Purpose | Screenshot |
|---|---|---|
| [`Music RAG - Ingestion.json`](Music%20RAG%20-%20Ingestion.json) | **Data ingestion**: MusicBrainz → graph, Wikipedia → vector chunks; one run loads both | [screenshot](../screenshots/Music%20RAG%20-%20Ingestion.png) |
| [`Music RAG - Tool_ music_search v2.json`](Music%20RAG%20-%20Tool_%20music_search%20v2.json) | **Vector retrieval** tool | [screenshot](../screenshots/Music%20RAG%20-%20Tool_%20music_search%20(vector).png) |
| [`Music RAG - Tool_ music_graph v2.json`](Music%20RAG%20-%20Tool_%20music_graph%20v2.json) | **Graph retrieval** tool | [screenshot](../screenshots/Music%20RAG%20-%20Tool_%20music_graph%20(graph).png) |

The agent is built in the n8n **Agents builder**, not as a workflow. Its configuration is in [`../agent/`](../agent/), and screenshots of it are in [`../screenshots/`](../screenshots/).

Credentials are not included in the exports (only their names). Create your own as described in [`../setup/SETUP.md`](../setup/SETUP.md).
