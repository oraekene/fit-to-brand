# REQUIREMENTS — tool prerequisites for fit-to-brand

The repo itself is Markdown + CSV + PS1 (no vendor dependency, no build step).
These tools are required only for the marked features. Versions are floors.

| Tool | Floor | Needed for | Install (Windows) |
|---|---|---|---|
| PowerShell | 7.0 | all hooks (`hooks/*.ps1` declare `#Requires -Version 7.0`) | `winget install --id Microsoft.PowerShell` |
| pandoc | 3.x | report export (`hooks/Export-Report.ps1`: Markdown → HTML) | `winget install --id JohnMacFarlane.Pandoc` |
| Edge or Chromium | current | report export (headless `--print-to-pdf`: HTML → PDF) | ships with Windows (Edge) |
| Image generator per run PROFILE.md | — | rendered stills (web-manual path: ChatGPT web, Gemini web, …) | outside the repo (accounts, never keys in runs) |
| Figma or named finisher | — | finished type (whatever the run PROFILE.md names) | outside the repo |

Font note: runs declare an Approved Font Source (usually Google Fonts). Exported
HTML references the declared families with system fallbacks
(`Inter, "Segoe UI", Arial, sans-serif`); exact licensed rendering happens in
the run's finishing tool (e.g. Figma), never in the export. The export is a
render of the `.md` source of truth, not a rewrite.

## Key env table (provider registry `bridge/PROVIDERS.md`)

Keys live in process env or the platform secret store — never in chat, runs,
logs, or git. Hooks check presence/validity and print PASS/FAIL only.

| Registry id | Env var | Issue | Free-tier note |
|---|---|---|---|
| openrouter | `OPENROUTER_API_KEY` | openrouter.ai/keys | `:free` models testable without credit |
| openai | `OPENAI_API_KEY` | platform.openai.com/api-keys | no free tier: auth-check only |
| google-ai-studio | `GOOGLE_AI_STUDIO_KEY` | aistudio.google.com/apikey | text free tier; image shape verified at build |
| fal | `FAL_KEY` | fal.ai dashboard | per-model billing; probe unsupported |
| ollama | — (keyless) | — | spend-safe by construction |
| custom | user-named | user endpoint | per endpoint |
