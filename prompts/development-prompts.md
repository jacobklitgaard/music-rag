# Development prompts

The system was built in dialogue with an AI assistant (Claude). These are the key prompts, translated from Danish and trimmed to their essence. Screenshots of the agent's tool connections are in [`../screenshots/`](../screenshots/).

## Build prompts

| # | Prompt | Result |
|---|---|---|
| 1 | "Suggest Neo4j node labels and relationship types for 12 funk/soul albums, using MusicBrainz credits and Wikipedia text. Keep it small." | Schema: Album, Artist, Genre, Label, Chunk |
| 2 | "Quincy Jones is both artist and producer, bands and people are both artists, and instruments have many spellings. How do we avoid duplicate nodes?" | One `Artist` label keyed on MusicBrainz `mbid`, instrument normalisation, unique constraints + `MERGE` |
| 3 | "I have 2-3 days. One or two free data sources, no scraping?" | MusicBrainz for the graph, Wikipedia for the vectors |
| 4 | "Here is the MusicBrainz JSON for Thriller. Write a Code node that collects credits from release and track level, removes duplicates, normalises instruments and outputs parameterised Cypher." | Build Graph Cypher node |
| 5 | "Extend to 12 albums. The same workflow must fetch each Wikipedia article, chunk it by section, embed it with nomic-embed-text and store it with its source and an ABOUT link. Wipe the database first." | Ingestion workflow |
| 6 | "Here are the chunk counts, sources and credits per album. Does anything look wrong?" | Found 4 wrong Wikipedia pages and reissues with wrong years |
| 7 | "Write tool descriptions that say what each tool does, its input, when to use it, and that it returns sources." | [Tool descriptions](../agent/tool-descriptions.md) |
| 8 | "Write instructions for a record-store music historian agent: role, which tool when, chaining calls, guardrails, cite sources." | [Agent instructions](../agent/instructions.txt) |

## Debugging prompts

Pasting the exact error and asking "why?" solved every blocker.

| Error pasted | Cause | Fix |
|---|---|---|
| "MusicBrainz web server is currently busy" | Rate limit: 1 request per second | Batching 1 request / 2 s + retry on fail |
| Neo4j "deadlock wait cycle" | 12 parallel requests MERGE'd the same shared artists | All albums in one transaction with `UNWIND` |
| Wikipedia chunk counts looked wrong | Search hit an EP, a band page and a debut album | Exact article titles instead of search |
| Toto IV 2002, Risqué 2014 | MusicBrainz returned reissues | Earliest official release of the release group |
| "unknown input item type: item_reference" | Agents builder uses the OpenAI Responses API; Ollama only partly supports it | OpenAI model for the agent |
| "Item with id 'msg_…' not found" | Old session history from the Ollama attempt | New chat session |
| "JSON Body … `"name": }`" | Agent ran an old published version of the tool without the input field | Re-import tools, publish, re-add them to the agent |
