# Nourish — Autonomous Food Rescue Dispatcher

Connecting surplus food with the people who need it — powered by Jac and Jaseci.

Nourish is a full-stack autonomous system that reduces food waste by automatically coordinating surplus food from businesses with shelters and volunteer drivers. It uses Jac’s graph-native programming model to represent and solve real-world logistics as a live, traversable ecosystem.

---

## Problem

Every day, large amounts of edible food are wasted due to overstock or expiry, while shelters struggle with limited resources.

The core issue is coordination, not supply:
- Businesses don’t know who needs food
- Shelters don’t know what is available
- Volunteers are not efficiently assigned

This creates waste and inefficiency in systems that should be connected.

---

## Solution

Nourish solves this using an autonomous multi-agent system built on a live graph.

It automatically:
- Collects surplus food from businesses
- Matches it with shelters based on demand and capacity
- Assigns volunteers for pickup and delivery
- Dispatches everything without human intervention

---

## AI Agents (Jac Walkers)

Nourish uses three autonomous walkers:

### Supply Manager
- Processes incoming food donations
- Validates expiry and quantity
- Creates DonationNode

### Demand Tracker
- Monitors shelter capacity and needs
- Aggregates real-time demand data

### Autonomous Dispatcher
- Matches donations to shelters
- Assigns available volunteers
- Sends dispatch notifications
- Prevents duplicate processing using graph state

---

## Architecture (Graph-Based)

The entire system is modeled as a live spatial graph.

Business → Donation → Shelter  
                    ↓  
                Volunteer  

Nodes:
- BusinessNode
- ShelterNode
- DonationNode
- VolunteerNode

Edges:
- Offers
- AllocatedTo
- AssignedVolunteer

Jac walkers traverse and modify this graph in real time.

---

## Tech Stack

- Jac / Jaseci — backend, AI agents, graph logic
- Jac Walkers — autonomous decision-making agents
- Jac Frontend (.cl.jac) — UI system
- REST API (Jac) — backend services
- Graph-based architecture — core system design

---

## Features

- Real-time donation feed
- Shelter request management
- Autonomous dispatch system
- AI agent monitoring dashboard
- Interactive map visualization
- Analytics and alerts system

---

## API Overview

- add_donation() — submit surplus food
- get_donations() — fetch all donations
- get_shelters() — shelter capacity data
- run_dispatch() — trigger autonomous cycle
- get_dashboard() — system overview
- reset_ecosystem() — reset simulation

---

## Getting Started

### Install dependencies
```bash
jac install

Run backend simulation
jac run services/nourish.jac
Start full-stack app
jac start --dev main.jac

Then open:
http://localhost:8001

Project Structure
nourish/
├── main.jac
├── jac.toml
├── index.cl.jac
├── services/
│   ├── nourish.jac
│   ├── nourish_api.jac
├── pages/
├── components/
└── data/
Why Jac?

Jac is ideal for this project because:

The system is naturally a graph
Walkers act as autonomous AI agents
State is persistent and traversable
Backend, frontend, and logic are unified in one language
Perfect for real-world coordination systems
Future Improvements
LLM-based semantic matching using by llm()
Real SMS/email notifications (Twilio, SendGrid)
Live GPS volunteer tracking
Database integration (PostgreSQL / Supabase)
Mobile application
Multi-city scaling
License


Built using Jac, a graph-native programming language for autonomous systems.
