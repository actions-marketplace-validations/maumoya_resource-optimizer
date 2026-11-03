<!-- Header: create it with skill-forger-e2e's make_header.sh, then put its img tag here, centered, width 100%. -->

<!-- Regenerate the row with badges.sh: it adds Scorecard, Best Practices and measured benefit badges when they exist. -->
<p align="center">
  <img src="https://img.shields.io/badge/Claude%20Code-skill%20%2B%20plugin-7c5cfc" alt="Claude Code skill and plugin">
  <img src="https://img.shields.io/badge/license-MIT-blue" alt="MIT license">
  <a href="https://opensource.org/license/mit"><img src="https://img.shields.io/badge/Open%20Source-OSI%20approved%20license-3DA639?logo=opensourceinitiative&logoColor=white" alt="Open Source: OSI-approved MIT license"></a>
  <img src="https://img.shields.io/badge/privacy-no%20tracking%20%C2%B7%20no%20data%20collected-7c5cfc" alt="Privacy: no tracking, no data collected">
  <a href="https://scorecard.dev/viewer/?uri=github.com/maumoya/resource-optimizer"><img src="https://api.scorecard.dev/projects/github.com/maumoya/resource-optimizer/badge" alt="OpenSSF Scorecard"></a>
</p>

# Resource Optimizer

Frees disk space and eases RAM and CPU load on macOS and Linux: measures read-only, ranks what fills the disk with a plain need-it answer, gives you one command per group to run, proves the result before/after. Never deletes on its own.

<!-- Put a picture or a ≤10 s GIF here: one input → one result. -->

## Install

Claude Code plugin:

```
/plugin marketplace add maumoya/resource-optimizer
/plugin install resource-optimizer@resource-optimizer
```

Any agent that reads skills:

```
npx skills add maumoya/resource-optimizer
```

## Use

Type: `/resource-optimizer` or say "my disk is full".

## Results

First real run, a 16 GB Mac mini with a 494 GB disk (2026-11-03). Measured with `scripts/measure.sh` and `df -h /`;
the user ran every command.

| Step | What was cleared | Free space |
|---|---|---|
| Start | (macOS Storage showed 474.82 GB used) | 29 GiB |
| Group A | npm, uv, pip and Homebrew caches; Xcode build output to the Trash | 36 GiB |
| Group B | 4 unused local AI models, iOS simulators, old app leftovers to the Trash | 57 GiB |
| Trash emptied by the user | | 84 GiB |

`measure.sh after`: used 461.64 GB → 403.67 GB, **58 GB freed**, with nothing deleted by the agent.

## How it is tested

`evals/` holds one case per promise. Run `claude plugin eval . --allow-tools`.
Every PR runs `scripts/lint_skill.sh` in CI.

## FAQ

### What does it do?

Frees disk space and eases RAM and CPU load on macOS and Linux: measures read-only, ranks what fills the disk with a plain need-it answer, gives you one command per group to run, proves the result before/after. Never deletes on its own.

### Does it send my data anywhere?

No. It is instructions and local scripts only.

<!-- Draft this with skill-forger-e2e's owner_profile.sh, then let the owner edit it. -->
## About the author

Hi, I'm **Mauricio Alonso Moya Tapia** ([@maumoya](https://github.com/maumoya)). I built resource-optimizer because my 16 GB Mac mini ran out of space and every cleaner I tried wanted to delete things on its own.

Say hi or follow my work on [GitHub](https://github.com/maumoya).

## License

MIT © 2026 Mauricio Alonso Moya Tapia
