# Git sync workflow for shared agent config in dotfiles

Use this when the machine with the new Hermes or agent-config changes is behind another branch or machine that already changed the dotfiles repo.

## Goal

Integrate upstream changes first, then push only the intended shared-config update, without accidentally bundling unrelated workstation edits.

## Recommended sequence

1. Inspect repo state.
   - Confirm current branch and upstream.
   - Check whether the branch is ahead/behind and whether the worktree contains unrelated modifications.

2. Fetch remote refs.
   - Refresh `origin/main` and the target branch before deciding the merge direction.

3. Protect local edits before integrating upstream.
   - If the worktree is dirty, stash with untracked files included.
   - Example pattern: `git stash push -u -m "pre-sync-<timestamp>"`

4. Merge or pull upstream changes first.
   - For this user's dotfiles repo, a common pattern is merging `origin/main` into the active personal branch before pushing back to `origin/work`.

5. Re-apply the local work.
   - Pop the stash.
   - Expect conflicts in frequently edited files such as `install.sh`.

6. Resolve narrowly.
   - Keep the intended shared-agent additions.
   - Do not use the conflict as an excuse to bundle unrelated local desktop tweaks.
   - If unrelated files conflict, prefer the user's existing local workstation version unless the shared-config change truly depends on the upstream change.

7. Stage selectively.
   - Add only the files that belong to the cross-PC config feature.
   - Leave unrelated modified files unstaged.

8. Commit with a scoped message.
   - Example: `feat(ai-agent): sync hermes shared config and wiki launcher`

9. Push to the actual working branch.
   - If the user uses a personal branch like `work`, push there rather than assuming `main`.

## Durable lessons from this session

- A private branch workflow changes the safety rule: the important thing is not "push to main" but "push to the branch the second machine actually pulls from."
- `skills.external_dirs` plus a narrow Stow package keeps the Hermes sync diff isolated enough that selective staging is practical.
- The safest operational split is: merge remote first, then re-apply local edits, then commit only the shared-config files.
