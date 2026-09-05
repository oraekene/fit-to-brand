# Provider registry — thin select-list for Q0.1/Q0.2 (+models Q0.1m/Q0.2m)

Live registry (spec: `bridge/PROVIDERS-SPEC.md`). One row per provider; hooks
parse this table (split `|` rows) — it is the single source, there is no mirror
file. Columns: `id | aliases | baseURL | probe | keyEnv | images | video |
defaults | notes`. `keyEnv` names the env var (values never appear anywhere).
`manual` is the keyless preset path (`bridge/PROFILES.md`), not an endpoint.

| id | aliases | baseURL | probe | keyEnv | images | video | defaults | notes |
|---|---|---|---|---|---|---|---|---|
| openrouter | or | https://openrouter.ai/api/v1 | /models | OPENROUTER_API_KEY | openai-images | bespoke:via-model | chat auto free; image :free image models | tests on `:free` models only while key has no credit; keys at openrouter.ai/keys; verified 2026-09-05: auth + free text gen `provider-live` at cost 0; 0 free image models exist (images need credit); free shared pool 429s transient, retry |
| openai | oa | https://api.openai.com/v1 | /models | OPENAI_API_KEY | openai-images | bespoke:sora | chat gpt-4o-mini; image gpt-image-1 | NO free tier: auth-check only, every generation is spend; keys at platform.openai.com/api-keys |
| google-ai-studio | gai | https://generativelanguage.googleapis.com/v1beta/openai/ | /models | GOOGLE_AI_STUDIO_KEY | verify-at-build | verify-at-build | chat gemini-flash-latest | free-tier text testable (verified 2026-09-05: `provider-live` via gemini-flash-latest); 2.5-flash-lite retired for new users (404); image output exists (gemini-2.5-flash-image) but free-tier quota is 0 — needs billing, all $0 attempts 429; keys at aistudio.google.com/apikey |
| ollama | local | http://localhost:11434/v1 | /api/tags | none | none | none | chat per local pull | keyless, spend-safe; image/video stay manual (see PROFILES.md `local` preset) |
| fal | — | https://queue.fal.run | none | FAL_KEY | bespoke:fal | bespoke:fal | image per queue model | image/video-only lane (no chat, no probe); keys at fal.ai dashboard |
| custom | manual-api | (user-configured) | /models | (user-named) | verify-at-build | verify-at-build | (user-set) | escape hatch: empty baseURL, no fixed key |
| manual | web | — | — | — | manual | manual | — | current preset behavior via PROFILES.md presets; no keys, no probes |
