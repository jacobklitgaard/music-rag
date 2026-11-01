# Skills

The agent uses **no skills**. All task instructions are in [`instructions.txt`](instructions.txt).

**Why:** the agent has one clear job (answer questions about one collection of 12 albums) and only two tools. The "How to work" section of the instructions already says which tool to use when and how to chain calls, so splitting this into skills would add configuration without changing behaviour.

**If the agent grew**, natural skills would be:

| Skill | When | Tools |
|---|---|---|
| Credits lookup | Who produced or played on an album | music_graph (chained calls) |
| Sound and story | How an album sounds, its history and reception | music_search |
| Recommend an album | "Something with heavy slap bass", "like Thriller" | music_search, then music_graph |
