# AegisRelief — Mission-Critical Disaster Command & Emergency Aid Hub

[![PWA Ready](https://img.shields.io/badge/PWA-Ready-10B981.svg)](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps)
[![Supabase Realtime](https://img.shields.io/badge/Supabase-Realtime%20Sync-3ECF8E.svg)](https://supabase.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A state-of-the-art, mission-critical Disaster Relief Web Application designed for crisis responders, civil defense coordinators, frontline rescue teams, volunteers, and affected citizens.

---

## 🌟 Core Features

- **🗺️ Live Interactive Incident & Safe Evacuation Map**: Dark tactical Leaflet maps with pulsing radar pins, hazard radius zones, and automatic safe evacuation route solver avoiding active danger perimeters.
- **🚨 One-Tap SOS Distress Dispatch**:
  - Triage urgency calculator (0–100) factoring in infants, elderly, trauma, rising water, and power loss.
  - Zero-internet offline high-contrast canvas QR code and 2G SMS text dispatch protocol (`AEGIS#SOS-ID#COORDS#TYPE#COUNT`).
  - Screen strobe flashlight signaling & Morse code audio beacon (`··· ——— ···`).
- **🎙️ Voice-Activated Hands-Free SOS**: Web Speech API integration that parses spoken emergency descriptions and auto-configures dispatch with audible speech synthesis confirmation.
- **🏠 Shelters & Strategic Supply Logistics Matrix**: Real-time capacity occupancy gauges, medical bay/generator tags, and live resource depot stock levels with resupply pledge actions.
- **🔍 Family Reunification & "I Am Safe" Registry**: Searchable database of displaced persons and 1-click safety status broadcast.
- **🤝 Volunteer Squads & Aid Fund**: Multi-role volunteer recruitment and disaster relief crowdfund tracker.
- **📋 72-Hour Offline Go-Bag & First Aid Guides**: Persistent emergency checklist and step-by-step survival protocols (Flash Flood, Tourniquet/First Aid, Water Sterilization, Earthquake).
- **⚡ Live Supabase Real-Time Cloud Sync**: Full PostgreSQL integration with live WebSocket channel broadcasts across multiple devices.
- **📱 Progressive Web App (PWA)**: Complete offline caching via `sw.js` and `manifest.json` for resilience during total network blackouts.

---

## 🚀 Quick Start

### 1. Run Locally
Launch the included lightweight server:
```powershell
powershell -ExecutionPolicy Bypass -File .\server.ps1
