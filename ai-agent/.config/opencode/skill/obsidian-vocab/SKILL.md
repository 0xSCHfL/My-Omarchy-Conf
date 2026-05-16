---
name: obsidian-vocab
description: >
  Add a new word or phrase to the user's Obsidian language vocabulary notes.
  Use this skill whenever the user wants to save, add, or note down a new word,
  phrase, expression, or slang term in any language (English, French, Spanish,
  Russian, German). Triggers on phrases like: "add this word to my notes",
  "save this vocabulary", "add to my Obsidian", "note this word down",
  "add [word] to my [language] vocab", "save this expression". Also triggers
  when the user shares a word with a definition and wants it stored.
---

# Obsidian Vocab Skill

Add new vocabulary entries to the user's Obsidian language notes.

## Vault paths

Base: `/home/sohaib/Dropbox/Notes/Obsidian Vault/Live_Style/Languages/`

| Language | Vocabulary file |
|----------|----------------|
| English  | `English/Vocabulary/Vocabulary.md` |
| French   | `Frensh/Vocabulaire/Untitled.md` |
| Spanish  | `Spanish/Vocabulario.md` |
| Russian  | `Russian/Словарный запас.md` |
| German   | `Germany/Vokabular/Untitled.md` |

## Entry format

Match the existing style in each file exactly. The standard format is:

```
- **Word / Synonym**: short clear definition 🎯  (example sentence or usage note)
```

Rules:
- Bold the word or phrase
- Keep the definition short and simple — like explaining to a friend, not a dictionary
- Add 1-2 relevant emojis when they make the meaning clearer or more memorable
- Add a usage example or context note in parentheses when helpful
- If the word has a slang or informal meaning, note it: `(slang: ...)`
- For words with multiple related meanings, put them on the same line separated by `/`

## Examples of good entries

```
- **Quicksand**: soft sand that pulls you down if you step in it 🏜️  (used as a metaphor for dangerous situations you can't escape)
- **Irrational**: not based on logic or reason  (e.g., making a decision out of pure anger)
- **Ballin'**: slang for being rich and living a luxury life 💰  (e.g., "He's really ballin' now" = he's very successful)
- **Petite**: small and slim in body size 👗  (used to describe a person, especially a woman)
```

## Steps

1. Identify the language — ask if not clear from context
2. Read the target vocabulary file to understand the existing style and check the word isn't already there
3. Generate the entry in the correct format
4. Append it to the end of the file (or under the appropriate section header if the file uses sections like `# General`, `# Bad Terms`, etc.)
5. Confirm to the user: "Added **[word]** to your [Language] vocabulary."

If the user gives you a word without a definition, generate one yourself — simple, clear, with an example. Don't ask for the definition unless the word is extremely obscure or ambiguous.
