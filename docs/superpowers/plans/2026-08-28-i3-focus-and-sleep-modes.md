# i3 Focus and Sleep Modes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add reversible i3 study and sleep modes, connect sleep timers to suspend, and relock the session while battery remains critically low.

**Architecture:** A single user-level mode controller stores transient state under `/run/user/$UID`, pauses/resumes Dunst, and starts/stops the sleep countdown. Website blocking is kept behind an explicit local domain list and reversible hosts rules; YouTube-only enforcement is not enabled until its scope is confirmed. The existing idle chain remains responsible for screensaver, lock, and suspend, while the battery monitor adds a repeated low-battery lock guard.

**Tech Stack:** Bash, i3 keybindings, i3blocks, Dunst, systemd user timers, `loginctl`, and existing `batmon`/timer scripts.

**Spec:** This plan implements the requested study mode, sleep mode, sleep timer, and low-battery relock behavior described in the conversation.

The active mode is also displayed in an i3blocks status block and refreshed immediately after mode changes.

## Global Constraints

- All mode changes must be reversible with one command or shortcut.
- Do not modify global firewall or `/etc/hosts` rules without an explicit domain list and confirmation of system-wide scope.
- Preserve the existing screensaver → lock → suspend idle chain.
- At battery `<=10%` while discharging, relock periodically until charging resumes; retain hibernation protection at `<=5%`.
- Validate shell syntax, i3 config syntax, timer state, and live Dunst/battery behavior without forcing suspend.

---

### Task 1: Add the reversible mode controller

**Files:**
- Create: `i3/.local/bin/i3-mode`
- Modify: `i3/.config/i3/config`
- Modify: `i3/.config/i3blocks/config`
- Create: `i3/.config/i3blocks/scripts/mode`

**Interfaces:**
- `i3-mode study` enables study mode.
- `i3-mode sleep` enables sleep mode.
- `i3-mode off` disables either mode and restores notifications.
- `i3-mode status` prints the active mode.

- [ ] Add state handling under `${XDG_RUNTIME_DIR:-/run/user/$UID}/i3-mode`.
- [ ] Implement `study` and `sleep` transitions with `dunstctl set-paused true`.
- [ ] Implement `off` with `dunstctl set-paused false` and sleep-timer cancellation.
- [ ] Add i3 shortcuts for study toggle, sleep toggle, and mode off.
- [ ] Add an i3blocks mode indicator showing `Normal`, `Study`, or remaining sleep time.
- [ ] Validate with `bash -n`, mode status, and Dunst pause-state checks.

### Task 2: Add sleep timer suspend integration

**Files:**
- Modify: `i3/.config/i3blocks/scripts/timer`
- Modify: `i3/.config/i3blocks/config`

**Interfaces:**
- Existing timer behavior remains notification-only.
- `i3-mode sleep <minutes>` starts a sleep countdown that calls `systemctl suspend` when it expires.
- Cancelling sleep mode cancels the countdown and clears the bar state.

- [ ] Add a separate sleep timer PID/state so it cannot kill the existing ordinary timer.
- [ ] Show remaining sleep time in the timer block.
- [ ] Suspend only after the requested countdown finishes and the system is still in sleep mode.
- [ ] Test with a non-suspending dry-run command and inspect cancellation behavior.

### Task 3: Add explicit reversible website blocking

**Files:**
- Create: `i3/.config/i3/modes/study-domains`
- Create: `i3/.local/bin/i3-mode-web-filter`
- Modify: `i3/.local/bin/i3-mode`

**Interfaces:**
- `i3-mode-web-filter enable` applies only domains listed in `study-domains`.
- `i3-mode-web-filter disable` removes only its own marked rules.
- The file contains one domain per line and is empty by default until the user supplies domains.

- [ ] Add marker-scoped rules and atomic temporary-file handling.
- [ ] Require confirmation before using `sudo` to modify `/etc/hosts`.
- [ ] Add a clear warning that `/etc/hosts` blocking is system-wide.
- [ ] Keep YouTube-only allowlisting disabled until browser-only versus system-wide scope is confirmed.
- [ ] Test marker insertion/removal on a temporary hosts file.

### Task 4: Add the low-battery relock guard

**Files:**
- Modify: `i3/.local/bin/batmon`

**Interfaces:**
- At `<=10%` and `Discharging`, call `loginctl lock-session` and repeat on later monitor cycles while still discharging.
- At `Charging` or `Full`, stop relocking and clear the low-battery lock state.
- At `<=5%`, retain the existing hibernate-then-poweroff fallback.

- [ ] Add a distinct lock threshold and flag.
- [ ] Ensure the guard does not block the existing hibernation branch.
- [ ] Test with mocked battery files and mocked `loginctl`/`systemctl`; never force real suspend during validation.

### Task 5: Document and verify the modes

**Files:**
- Modify: `i3/README.md`
- Modify: `i3/default/i3/references/keybindings.md`

- [ ] Document shortcuts, status commands, timer cancellation, and website-filter scope.
- [ ] Run shell syntax checks and `i3 -C -c ~/.config/i3/config`.
- [ ] Verify Dunst state, mode state, and that the existing idle daemon remains running.
- [ ] Run `git diff --check` and review the focused diff.
