# Design Tokens - ZeroHeight Integration

This directory contains design tokens exported from Figma via ZeroHeight and auto-generated Dart files.

## Architecture Overview

```
Figma (Design) --> ZeroHeight (Tokens) --> GitHub PR (JSON) --> Dart Code (Output)
```

**Flow:**

1. **Figma** - Designers create/update design tokens
2. **ZeroHeight** - Syncs with Figma and exports tokens as JSON
3. **GitHub PR** - ZeroHeight pushes JSON files to a new PR
4. **Dart Code** - GitHub Action generates typed Dart constants

## How It Works

### 1. Figma → ZeroHeight Sync

- Designers maintain design tokens in Figma (colors, typography, spacing, etc.)
- ZeroHeight connects to Figma and extracts design tokens
- Tokens are exported in JSON format with `$type` and `$value` fields

### 2. ZeroHeight → GitHub PR

- When tokens are updated, ZeroHeight creates a PR to this repository
- The PR contains JSON files in `lib/tokens/*.json`
- Branch naming pattern: `zeroheight-tokens-YYYYMMDDHHMMSS`

### 3. GitHub Actions Workflow

- Workflow triggers on PRs that modify `lib/tokens/*.json`
- Filters to only run on PRs from ZeroHeight (bot user or branch name)
- Runs the Dart token generator script
- Auto-commits generated `.dart` files back to the PR

### 4. Generated Dart Code

- JSON tokens are parsed and converted to strongly-typed Dart constants
- Colors are converted to `Color(0xAARRGGBB)` format
- Token references like `{Scale.400(16)}` are resolved to actual values
- Files follow Dart naming conventions (snake_case files, PascalCase classes)

## Files

| File        | Description                                   |
| ----------- | --------------------------------------------- |
| `*.json`    | Raw token files from ZeroHeight (DO NOT EDIT) |
| `*.dart`    | Auto-generated Dart code (DO NOT EDIT)        |
| `README.md` | This documentation                            |

## Token Generator Script

Located at: `tool/generate_tokens.dart`

### Run manually:

```bash
dart run tool/generate_tokens.dart
```

### What it does:

1. Scans `lib/tokens/` for JSON files
2. Parses ZeroHeight's token format
3. Generates Dart classes with static constants
4. Handles color, number, and string token types
5. Resolves token references (e.g., `{Scale.400(16)}` → `16`)
6. Cleans up key names (e.g., `100(4)` → `100`)

## GitHub Workflow Configuration

File: `.github/workflows/zeroheight_tokens.yml`

### Trigger conditions:

- PR modifies files matching `lib/tokens/*.json`
- PR is from ZeroHeight (checks bot username, branch name, or PR title)

### Steps:

1. Checkout PR branch
2. Setup Flutter/Dart
3. Run token generator
4. Format generated files
5. Commit and push changes back to PR

## Token Types Supported

| Type          | JSON Example                  | Dart Output         |
| ------------- | ----------------------------- | ------------------- |
| Color         | `"$value": "#FF0000"`         | `Color(0xFFFF0000)` |
| Color (alpha) | `"$value": "#FF000080"`       | `Color(0x80FF0000)` |
| Number        | `"$value": 16`                | `16`                |
| Reference     | `"$value": "{Scale.400(16)}"` | `16`                |
| String        | `"$value": "Inter"`           | `"Inter"`           |

## Adding New Token Types

To support additional token types, edit `tool/generate_tokens.dart`:

1. Add case to `_convertValue()` function
2. Handle the new `$type` value
3. Return appropriate Dart representation

## Troubleshooting

### Workflow not triggering

- Ensure PR modifies `lib/tokens/*.json` files
- Check if PR author matches ZeroHeight bot patterns

### Permission denied on push

- Check repository Settings → Actions → Workflow permissions
- Enable "Read and write permissions"
- Enable "Allow GitHub Actions to create and approve pull requests"

### Generated code has errors

- Check JSON format matches ZeroHeight's expected structure
- Ensure `$type` and `$value` fields are present
- Run generator locally to debug: `dart run tool/generate_tokens.dart`
