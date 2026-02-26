# Northgard – 3v3 Team Conquest Mod

A mod that turns Northgard into a 3v3 team battle with class progression, jungle camps, boss fights and wave combat. Written in Haxe using the Northgard scripting API.

---

## What it does

Two teams of three fight over a shared map. Every few months minions spawn and march toward the enemy base. The more War-Camps you build, the stronger your wave. Your team gains Military XP together and levels up as a unit, unlocking better heroes and passive bonuses along the way.

Your class is locked in by your first Lore pick: **Defender**, **Fighter** or **Miner**. Each has four upgrade tiers. On top of that, jungle camps periodically spawn neutral enemies across the map and every 12 months a random boss shows up that drops team-wide rewards when killed.

---

## How it's built

Player positions, attack paths, unit types, bonuses and level-up messages are all defined upfront as arrays. This keeps the actual logic clean. Upgrading a player or sending a wave is just an index lookup, not a wall of if-statements.

Attack routes are calculated dynamically each wave based on who owns what, so the path always reflects the current state of the map rather than a hardcoded route.

---

## Challenges

| Problem | Fix |
|---|---|
| Random crashes in multiplayer | Marked all critical functions with `@sync` so every client runs them at the same time |
| Too many functions executing at once | Spread everything across different ticks using `mod` checks inside a single update loop |
| Wave arrays filling up with dead units | Added a cleanup pass every cycle and capped arrays at 20 units |
| Functions blocking each other | Used `@split` blocks so independent tasks run in parallel |
