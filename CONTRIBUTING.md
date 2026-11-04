# Contributing

Thanks for helping. resource-optimizer is one skill file, one reference file and one measuring script, so changes are small.

## How to contribute

- **Bugs and ideas:** open an [issue](https://github.com/maumoya/resource-optimizer/issues). Say your OS, what you
  asked, what the skill replied, and what you expected.
- **Security problems:** do not open a public issue; follow [SECURITY.md](SECURITY.md).
- **Changes:** fork, branch, and open a pull request against `main`.

## Requirements for a pull request

- English only, plain words, short sentences.
- Keep the skill's promise: measure first, the user approves each step, the agent never deletes on its own.
- The Lint and CodeQL checks must pass before merge.
- No tracking, network calls or data collection (see [PRIVACY.md](PRIVACY.md)).

## Tests

The `evals/` folder is the test suite, in the format `claude plugin eval` reads. Run it from the repository root:

```bash
claude plugin eval . --allow-tools
```

The free offline check runs in CI and locally:

```bash
bash scripts/lint_skill.sh
```

**Policy:** every change to the skill's behavior adds or updates a test case in `evals/` that would fail without the
change. Pull requests that change behavior without a test are not merged.

## License

By contributing you agree that your contribution is licensed under the [MIT License](LICENSE).
