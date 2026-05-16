# Project: Nourish — Autonomous Food Rescue Dispatcher
## Status: DONE

## Plan
1. [x] Inspect workspace (existing fullstack template)
2. [x] Write graph model (nodes + edges) in services/nourish.jac
3. [x] Write supply_manager walker (Supply Agent)
4. [x] Write demand_tracker walker (Demand Agent)
5. [x] Write autonomous_dispatcher walker (Logistics Agent)
6. [x] Write entry point bootstrapping mock ecosystem
7. [x] Run and validate — all 3 agents execute correctly

## Files
- services/nourish.jac — complete backend: all nodes, edges, walkers, entry point
- services/nourish_model.jac — standalone model file (superseded by nourish.jac)
- services/supply_agent.jac — standalone supply agent (superseded by nourish.jac)

## Issues & Fixes
- `import:py datetime` is invalid Jac — use `import from datetime { datetime }`
- `disengage` is only valid in walker abilities, not node-side entries — use `return`
- `can foo(args)` in walkers must be `def foo(args)` for non-entry methods
- `here` is typed Unknown in walker entries — use node-side entries (`with WalkerType entry`) where `self` is properly typed
- Persistent graph (MongoDB): `[root -->]` accumulates across runs — use HubNode as session anchor
- Two `with Root entry` abilities in same walker both fire simultaneously — avoid; use single entry per node type
- `++>` creates duplicate edges if called multiple times — use HubNode isolation to avoid cross-run contamination

## Learnings
- Node-side entries (`can X with WalkerType entry`) give properly typed `self` (the node) and `visitor` (the walker)
- Walker-side entries give `self` (walker) and `here` (Unknown type — type checker limitation)
- `jac_run` uses persistent MongoDB — each run adds to the graph; use a fresh HubNode per session
- Spawn walkers on specific nodes (`biz1 spawn walker(...)`) not root to avoid visiting all nodes
- Use `[hub -->][?:NodeType]` for session-isolated discovery instead of `[root -->]`
- `def` for regular methods in walkers, `can` only for node-entry abilities

## Last Action
All 3 agents running correctly:
- Supply Agent: creates DonationNodes, rejects expired food
- Demand Tracker: scans and updates ShelterNodes
- Autonomous Dispatcher: matches donations to shelters, recruits volunteers, sends mock notifications
Result: 2 dispatched, 0 skipped — clean execution.
