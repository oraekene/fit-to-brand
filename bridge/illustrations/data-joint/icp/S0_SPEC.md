project SunJar SHS-200 | run-mode single | overlay O-GTM | line-cap 300 | K-rank 50 | K-fit 10 | model illustrator | temp 0 | date 2026-09-04 | spec-sha sunjar001 | naming: required | N 6

# 1. Problem Statement
Off-grid households and roadside shops burn kerosene and queue at phone-charging kiosks for light and power after dark.

# 2. Solution
SunJar SHS-200: 200W panel plus battery hub with 4 lamp points, 2 USB ports, and a PAYG companion app showing battery state and balance.

# 3. User Stories
1. As a mother I want smokeless bedroom light so children read after dark.
2. As a stall trader I want one extra trading hour under light customers trust.
3. As a youth I want a full phone by morning without kiosk queues.
4. As a field agent I want arrears visibility so I schedule installs before recoveries.

# 4. Implementation Decisions
Hub firmware meters each lamp point; app syncs over Bluetooth; PAYG unlock codes via mobile money.

# 5. Testing Decisions
Acceptance: 5 pilot homes run 4 lamp points plus 2 phones nightly for 14 days with zero kerosene lighting.

# 6. Out-of-Scope
Grid-tied installs; refrigeration and cooling loads; mains-wired appliances; device financing beyond PAYG unlock; school wiring beyond plug-in lamp points.

# 7. Further Notes
Risk: pack confusion with LuminaHome SHS-200 on dealer shelves. Bootstrap: agents first, then households, then shops.
