# Provider presets — one-line toolchains for `ftb quickstart -Preset <name>`

Each preset answers Q0.1–Q0.5 in one choice, with capability flags and fallbacks
filled from `brand/SKILL.md` (Provider Profile & Tooling Adapter). Quickstart writes
the Q0 lines with `src=asked` — picking a preset *is* answering — plus a
`runs/<id>/PROFILE.md` declaration. Subject form is not in presets (it describes
your subject, not your toolchain): pass `-Form digital|physical|hybrid|human-service`
on the same command (Q0.6, `src=asked`). Override any single answer later by appending a
new `PARAMS.log` line (later lines win for entry locks) and updating PROFILE.md.

Outside-the-repo half (never written into a run): logins, API keys (shell env or
agent tool config), local endpoints you operate, font licenses. The run records
names, models, caps, and fallbacks — never secrets.

## The 8 presets

| Preset | Q0.1 image | Q0.2 video | Q0.3 layout | Q0.4 fonts | Q0.5 cap | Flags that matter + fallback |
|---|---|---|---|---|---|---|
| `lovart` | Lovart-native | same-stack | Figma | Google Fonts | credits cap 400 | reference-input yes; text-in-image partial → finish type in Figma; motion yes; vector no → packaging conceptual-only |
| `gpt` | GPT-image-class | Sora | Figma | Google Fonts | seat-time cap 300 | direction here, render there (handoff in plan); small type re-set in Figma; Sora from approved still only |
| `api` | GPT-image-class | Runway | Figma | Google Fonts | API-$ cap 30 | agent assembles payloads; keys in env, never in run; type finished in layout tool |
| `midjourney` | Midjourney + LLM direction | None storyboard-fallback | Figma | Google Fonts | seat-time cap 300 | MJ renders scene/composition ONLY (placeholder glyph bars where type goes); all type native Figma layers; no exact fonts or 16:9 doc slides from MJ |
| `firefly` | Adobe Firefly | None storyboard-fallback | Illustrator | Adobe Fonts license-confirmed | credits cap 500 | commercially-safe training (enterprise pick); Content Credentials on; type via PS/AI layers |
| `local` | SD-Comfy-local | None storyboard-fallback | Figma | Google Fonts | render-minutes cap 120 | endpoint URL recorded in PROFILE.md image line (URLs aren't secrets); no key; lock prohibitions double as negative prompts |
| `figma` | Figma-embedded | None storyboard-fallback | Figma | Google Fonts | seat-time cap 300 | layout-first: scene zone from embedded generator or flat screenshots, zones/type/chips native; no separate finish step |
| `docs` | None conceptual-only | None storyboard-fallback | None conceptual-only | Google Fonts | seat-time cap 120 | text-only run: written specs + ASCII wireframes; motion as shot-list; zero render spend (this is how the self-run shipped) |

## Q0.2 swap-ins (upgrade motion without changing preset)

Keep your preset; answer Q0.2 once with one of: `Runway` / `Pika-Kling-Sora-Luma` /
`same-stack` (where true) / `None storyboard-fallback`. Append the line, update
PROFILE.md video line + fallbacks, re-issue pending Generation Plans.

## Machine mirror

`hooks/ftb.ps1` embeds this same table (preset → Q0.1–Q0.5 values) for seeding.
If you add a preset here, add its five values there too, or `quickstart -Preset`
will refuse the unknown name and list valid ones.
