# Where space usually goes

Sizes vary. Measure each with `du -sh PATH`, one explicit path at a time.

## Group A: regenerable (safe)

| Item | macOS path | Linux path | Clean command (user runs it) |
|---|---|---|---|
| npm cache | `~/.npm` | `~/.npm` | `npm cache clean --force` |
| pip cache | `~/Library/Caches/pip` | `~/.cache/pip` | `pip cache purge` |
| uv cache | `~/.cache/uv` | `~/.cache/uv` | `uv cache prune` |
| Homebrew | `~/Library/Caches/Homebrew` | `~/.cache/Homebrew` | `brew cleanup --prune=all` |
| Playwright browsers | `~/Library/Caches/ms-playwright` | `~/.cache/ms-playwright` | `npx playwright uninstall --all` |
| iOS simulators | `~/Library/Developer/CoreSimulator` | n/a | `xcrun simctl delete unavailable` |
| Xcode build output | `~/Library/Developer/Xcode/DerivedData` | n/a | Xcode › Settings › Locations › delete, or move the folder to the Trash |
| Docker images | inside the VM disk | `/var/lib/docker` | `docker system prune` (shows what it removes first) |
| Browser caches | `~/Library/Caches/Google`, `Firefox` | `~/.cache/google-chrome` | clear from the browser's settings with the browser closed |
| apt / dnf caches | n/a | `/var/cache/apt` | needs admin: explain, let the user decide |
| journal logs | n/a | `/var/log/journal` | needs admin: explain, let the user decide |

## Group B: you decide

| Item | Where | How to check if it is used | Action |
|---|---|---|---|
| Ollama models | `~/.ollama/models` | `ollama list`, then search the user's code and config for each name | `ollama rm NAME`, one per line |
| MLX / Hugging Face models | `~/MLXModels`, `~/.cache/huggingface` | which app loads them; is that app still installed | app gone: Trash; else external disk |
| VM disks (Colima, Docker Desktop, UTM) | `~/.colima`, `~/Library/Containers/com.docker.docker` | is the VM running, is it needed soon | stop it, then archive to an external disk |
| Old app support folders | `~/Library/Application Support/APP` | is the app still installed and used | uninstall the app the official way, then Trash the folder |
| `node_modules` in old projects | project folders | repo committed and pushed, not opened lately | Trash; `npm install` brings it back |
| Downloads, Movies | `~/Downloads`, `~/Movies` | last opened date | Trash or external disk |

## Group C: in an app's own settings

Messages and WhatsApp attachments, iCloud "Optimize Mac Storage", photo libraries, mail downloads, a pending OS update.

## Extra read-only checks

| Check | macOS | Linux |
|---|---|---|
| Time Machine local snapshots (hidden "System Data") | `tmutil listlocalsnapshots /`; user can run `tmutil thinlocalsnapshots / 1000000000 4` | n/a |
| Purgeable vs real free | `diskutil info /` (Container Free Space) vs `df -h /` | `df -h /` |
| Docker / Colima / Podman | `docker system df`, `colima status`, `podman system df` | same |
| node_modules and build output | `find ~/Projects -maxdepth 6 -name node_modules -type d -prune -exec du -sh {} +` | same |
| Stale large files (approx. last use) | `find ~/Downloads ~/Movies ~/Desktop -type f -size +500M -atime +180` | same |
| Trash | `du -sh ~/.Trash` (needs Full Disk Access; else read the Finder size) | `du -sh ~/.local/share/Trash` |
| Homebrew dry run | `brew cleanup -n` | `brew cleanup -n` |
| Login items | `osascript -e 'tell application "System Events" to get the name of every login item'`, `ls ~/Library/LaunchAgents` | `systemctl --user list-unit-files --state=enabled` |
| Package caches, logs | n/a | `du -sh /var/cache`, `journalctl --disk-usage`, `snap list --all` |

Name the search roots explicitly. Never `find ~` over the whole home on a large disk: it can run for minutes.

## Why "Documents" is huge on macOS

System Settings › Storage shows "Documents" as every user file that fits no other category: models, VM disks, caches,
app support folders, and hidden folders such as `~/.ollama`, `~/.colima` or an app's VM bundle. The `~/Documents`
folder itself is often tiny. Measure the home folder's top level, hidden folders included, and show the user those
names instead of saying "Documents is heavy".

## Keep, never clean

Agent threads and sessions (active or archived), their git worktrees and merged git branches. They are the record of
why things were done. If they are in the way, archive them; report their size only.

## RAM and CPU

- `top -l 1 -o mem -n 15` (macOS) or `ps aux --sort=-%mem | head -16` (Linux): the 15 heaviest processes.
- Login items: System Settings › General › Login Items (macOS), `systemctl --user list-unit-files --state=enabled` (Linux).
- Local AI models: one loaded model can hold several GB of RAM. Keep the defaults under about a third of total RAM.
- A disk over about 90% full slows everything: swap and caches have no room.
