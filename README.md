# ROUTE+ — live preview

**Discover more without losing your route.**

This is the public, browser-only preview of [ROUTE+](https://github.com/Dhanush7921/ROUTE-PLUS-PRODUCTION) —
route-aware discovery for Indian road trips. You enter a journey, ROUTE+ shows
the waterfalls, temples, forts and viewpoints that sit beside that road, and
tells you what each detour costs in extra kilometres and minutes before you
decide. The main route stays yours; every stop is a choice.

The preview is one self-contained HTML file. No build step, no server, no
tracking, no API keys.

## What works here

- Enter an origin, destination, trip length, traveller type and interests
- Generate a route and browse discoveries by corridor and journey phase
- Open a place and see its detour cost: extra kilometres, extra driving, time there
- Add and remove stops and watch the trip-duration impact recalculate
- The vector route map: solid line for your route, dashed for optional detours

**Route and detour figures in this preview are estimates** from a simplified
offline road network, and the interface says so wherever they appear. They are
not navigation data.

## What needs the deployed server

| Feature | Why |
|---|---|
| Sign-up, sign-in, trips saved to an account | needs the Node.js backend and PostgreSQL |
| On-road companion, traveller feedback, admin dashboard | needs the backend |
| Real road routing and geocoding | needs the backend plus a provider key |
| Live place discovery (OpenStreetMap / Google Places) | needs the backend plus a provider key |

The interactive map is the product's final feature phase and is not built yet.
What you see here is the current ROUTE+ vector renderer.

## Running it locally

Download `index.html` and open it. That is all — it works from `file://`.

## Relationship to the main project

The application source, backend, database layer, deployment configuration and
test suite live in the private production repository. This repository holds only
the compiled public frontend and the workflow that publishes it, so nothing
private is exposed. The preview is regenerated from the production repo with:

```
npm run build        # -> dist/route-plus-standalone.html
```

## Licence

No licence has been granted. All rights reserved by the author.
