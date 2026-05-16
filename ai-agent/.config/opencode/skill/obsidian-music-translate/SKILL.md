---
name: obsidian-music-translate
description: >
  Create a full line-by-line music translation and analysis note in Obsidian.
  Use this skill whenever the user pastes song lyrics and wants them translated,
  explained, or broken down — especially for English rap/UK drill lyrics with slang.
  Triggers on: "translate this song", "explain these lyrics", "break down this song",
  "add this song to my notes", "analyze these lyrics", pasting raw lyrics followed
  by a request to explain or save them. Also triggers when the user shares a song
  title + artist and asks for a breakdown. Always use this skill for music lyric
  analysis — don't just explain inline, create the Obsidian note.
---

# Obsidian Music Translate Skill

Analyze English song lyrics line by line and save a full breakdown note to Obsidian.

## Output location

`/home/sohaib/Dropbox/Notes/Obsidian Vault/Live_Style/Languages/English/Music Translating/`

**File name:** `Song Title - Artist.md`  
Example: `Trojan Horse - Dave, Central Cee.md`

## What a good breakdown looks like

The goal is to help someone with intermediate English understand every line deeply — the literal meaning, the slang, the cultural references, and the emotional message. Think of it as a personal teacher explaining a song a line at a time.

### Structure per section

```markdown
## 🎵 Verse 1

### **"[exact lyric line]"**

**Meaning:**
[1-2 sentences explaining what this line really means, not just word-for-word]

**Simple English:**
> "[rewrite the line in plain, easy English]"

**Vocabulary:**
- **word** → definition
- **another word** → definition

**Slang?**
✅ **"word"** = [slang meaning]
⚠️ **"expression"** = informal/casual spoken English
❌ Not slang — common expression

---
```

For sections with many vocabulary items, use a table instead of the ✅/⚠️/❌ format:

```markdown
| Word/Phrase | Type |
|---|---|
| Ballin' | 🔴 slang |
| Got flown out | 🟡 informal |
| Legitimate | 🟢 normal English |
```

Legend: 🟢 normal English · 🟡 informal/spoken · 🔴 street slang

### End of each major section

Add a simple paraphrase box:

```markdown
## 🎯 Full Simple Paraphrase

> [Rewrite the whole section in 4-6 plain sentences. No slang, no metaphors. Just what happened / what was said.]
```

## Section headers to use

Use these when appropriate based on the song structure:
- `## 🎵 Verse 1`, `## 🎵 Verse 2`, etc.
- `## 🎤 Chorus` / `## 🔁 Hook`
- `## 🎵 Bridge`
- `## 🎤 Outro`
- `## [Verse 1: Artist Name]` when multiple artists

## What to focus on

- **Slang and street terms**: always explain these fully — they're the hardest part
- **Cultural references**: explain who/what is being referenced and why it matters (e.g., a footballer, a TV show, a place)
- **Wordplay and double meanings**: flag these and explain both meanings
- **Metaphors**: explain what the metaphor represents in plain terms
- **Informal grammar**: note when the grammar is intentionally non-standard (e.g., "ain't got no" = double negative meaning "doesn't have")

## Getting the lyrics

There are two ways the user can provide lyrics:

**Option A — Pasted directly:** User pastes lyrics in the chat. Use them as-is.

**Option B — Already clipped to Obsidian:** User says something like "translate the song I just saved" or "translate [Song Title]". In this case:
1. Check the Lyrics inbox folder: `/home/sohaib/Dropbox/Notes/Obsidian Vault/Live_Style/Languages/English/Music Translating/Lyrics/`
2. Find the matching file (by title or most recently created)
3. Read the lyrics from that file
4. After creating the analysis, update the file's `tags` frontmatter — replace `to-translate` with `translated`

If the user gives only a title and artist (no lyrics and no file found), ask them to paste the lyrics or clip the page using the Music Lyrics web clipper template.

## Steps

1. Get the lyrics (from chat paste or from the Lyrics folder — see above)
2. Read the full lyrics before writing anything — understand the song first
3. Identify the song structure (verses, chorus, bridge, outro)
4. Go line by line, grouping related lines when they flow together
5. Write the breakdown following the format above
6. Save the analysis file to the Music Translating folder (not the Lyrics subfolder)
7. Confirm: "Saved breakdown for **[Song] - [Artist]** to your Music Translating notes."

If the lyrics are very long (more than 5 verses), offer to do it in parts — one or two verses at a time — so the note stays readable and the user can review as you go.
