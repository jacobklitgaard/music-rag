# Workflows

TODO: export each workflow from n8n (**open workflow → ⋯ → Download**) and put the files here with these names:

| File | Purpose | Screenshot |
|---|---|---|
| `01-ingestion.json` | Data ingestion: MusicBrainz → graph, Wikipedia → vector chunks, one run loads both | [`../screenshots/01-ingestion.png`](../screenshots/01-ingestion.png) |
| `02-tool-music-search.json` | Vector retrieval tool | [`../screenshots/02-tool-music-search.png`](../screenshots/02-tool-music-search.png) |
| `03-tool-music-graph.json` | Graph retrieval tool | [`../screenshots/03-tool-music-graph.png`](../screenshots/03-tool-music-graph.png) |

The agent is built in the n8n **Agents builder**, not as a workflow. Its configuration is in [`../agent/`](../agent/), and screenshots of it are in [`../screenshots/`](../screenshots/).

Credentials are not included in the exports (only their names). Create your own as described in [`../setup/SETUP.md`](../setup/SETUP.md).
