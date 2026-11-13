---
name: Botanical Precision
colors:
  surface: '#f9f9ff'
  surface-dim: '#cfdaf2'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f0f3ff'
  surface-container: '#e7eeff'
  surface-container-high: '#dee8ff'
  surface-container-highest: '#d8e3fb'
  on-surface: '#111c2d'
  on-surface-variant: '#3f4941'
  inverse-surface: '#263143'
  inverse-on-surface: '#ecf1ff'
  outline: '#6f7a70'
  outline-variant: '#bec9bf'
  surface-tint: '#056d40'
  primary: '#006037'
  on-primary: '#ffffff'
  primary-container: '#1e7a4c'
  on-primary-container: '#adffc9'
  inverse-primary: '#81d9a2'
  secondary: '#2e6a41'
  on-secondary: '#ffffff'
  secondary-container: '#b1f2be'
  on-secondary-container: '#347047'
  tertiary: '#834100'
  on-tertiary: '#ffffff'
  tertiary-container: '#a75500'
  on-tertiary-container: '#ffe9dc'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#9df5bc'
  primary-fixed-dim: '#81d9a2'
  on-primary-fixed: '#002110'
  on-primary-fixed-variant: '#00522f'
  secondary-fixed: '#b1f2be'
  secondary-fixed-dim: '#96d5a3'
  on-secondary-fixed: '#00210d'
  on-secondary-fixed-variant: '#12512c'
  tertiary-fixed: '#ffdcc5'
  tertiary-fixed-dim: '#ffb783'
  on-tertiary-fixed: '#301400'
  on-tertiary-fixed-variant: '#713700'
  background: '#f9f9ff'
  on-background: '#111c2d'
  surface-variant: '#d8e3fb'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.015em
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 10px
    fontWeight: '600'
    lineHeight: 12px
    letterSpacing: 0.04em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-md: 1.5rem
  gutter-lg: 2rem
  margin: 1rem
  margin-md: 1.5rem
  margin-lg: 3rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system pairs living botanical sciences with reliable hardware telemetry. Built for smart plant care and IoT soil sensor provisioning, the aesthetic balances organic warmth with clean, calibrated technical utility. 

Visual execution blends modern minimalism with tactile feedback: crisp, measured layouts avoid clutter during high-friction hardware pairing flows, while organic tonal containers and soft mint micro-surfaces ground telemetry data in natural warmth. The tone is authoritative, calm, and reassuring—transforming complex sensor diagnostics into effortless green-thumb confidence.

## Colors

The palette grounds the interface in deep botanical tones complemented by calibrated alert accents.

- **Primary (`#1E7A4C`)**: Core actions, active sensor nodes, connection states, and healthy vitality ranges.
- **Secondary (`#14532D`)**: High-contrast structural chrome, deep navigation elements, key headings, and grounding containers.
- **Tertiary (`#E67E22`)**: Warm amber reserve for moisture thresholds, hardware warnings, low-battery telemetry, and pairing timeouts.
- **Neutral (`#1E293B`)**: Slate neutral delivering sharp typographic legibility against light backdrops.

Supporting contextual surfaces rely on soft mint washes (`#F1F8F4` base container, `#E8F5E9` highlight container), bordered by calibrated organic gray-greens (`#D1E7DD`), and anchored across a crisp, anti-fatigue canvas backdrop (`#F6F9F7`). Secondary data and inactive indicators use muted slate-slate gray (`#64748B`).

## Typography

The typography leverages **Plus Jakarta Sans** for headlines and structural anchors, imbuing geometric modernity with approachable humanist curves. Data readouts, technical labels, telemetry streams, and long-form prose switch to **Inter** for ultra-reliable rasterization and micro-legibility at small scale.

All sensor telemetry, numeric values, and step counts utilize tabular lining numerals (`tnum`) in Inter to prevent visual jitter when live metrics stream from hardware sensors.

## Layout & Spacing

This design system uses a fluid responsive grid structured around standard mobile-first parameters:

- **Mobile (< 768px)**: 4 columns, 16px (`1rem`) gutters, 16px margins. Hardware setup flows adhere strictly to a single stacked axis with persistent sticky bottom action bars.
- **Tablet (768px – 1024px)**: 8 columns, 24px (`1.5rem`) gutters, 24px margins. Enables 2-column provisioning patterns (live probe readings alongside setup instructions).
- **Desktop (> 1024px)**: 12 columns, 32px (`2rem`) gutters, max-width constrained container at 1280px with auto-margins. Dashboard view organizes sensor clusters into cards spanning 4 or 6 columns.

Vertical rhythm relies on multiples of `0.25rem` (4px). Sensor detail panels and step-by-step pairing workflows maintain consistent `1.5rem` (`space-lg`) section separation to prevent visual overload during BLE/Wi-Fi connection phases.

## Elevation & Depth

Visual hierarchy uses delicate tonal surfaces layered over the `#F6F9F7` background, bounded by soft botanical borders and tinted ambient shadows:

- **Base Cards & Modules**: Background `#FFFFFF`, border `1px solid #D1E7DD`, shadow `0 2px 8px -2px rgba(20, 83, 45, 0.05)`.
- **Floating Modals & Sensor Readout Sheets**: Background `#FFFFFF`, border `1px solid #D1E7DD`, elevation shadow `0 12px 32px -4px rgba(20, 83, 45, 0.08), 0 4px 12px -2px rgba(20, 83, 45, 0.04)`.
- **Provisioning Overlays & Action Sheets**: Deep scrim `rgba(20, 83, 45, 0.35)` with a backdrop blur of `6px` to bring the active pairing drawer or diagnostic panel into pure focus.
- **Interactive Hover & Drag**: Uplifts via an intensified green-tinted halo: `0 8px 24px -4px rgba(30, 122, 76, 0.12)`.

## Shapes

The roundedness language is calibrated to Level 2:
- Base components (buttons, text fields, chips, small sensor readouts) utilize `0.5rem` (8px).
- Cards, modal containers, and elevated sheets use `1rem` (16px), adhering to the core botanical container style.
- Segmented status badges, telemetry pills, and active step dots use fully pill-shaped radii (`9999px`) to distinguish actionable indicators from structural containers.

## Components

### Buttons
- **Primary**: Background `#1E7A4C`, text `#FFFFFF`, border-radius `0.5rem`, padding `0.75rem 1.5rem`. Hover state transitions to `#14532D`.
- **Secondary / Outlined**: Background `transparent`, border `1.5px solid #1E7A4C`, text `#1E7A4C`. Hover state triggers a wash of `#F1F8F4`.
- **Destructive / Warning**: Background `#FFF3E0`, text `#E67E22`, border `1px solid rgba(230, 126, 34, 0.3)`.

### Cards & Container Panels
- Surface: `#FFFFFF` or `#F1F8F4` for nested data groups.
- Border: `1px solid #D1E7DD`.
- Corner Radius: `1rem` (16px).
- Internal Padding: `1.25rem` to `1.5rem`.
- Sensor Header: Plant avatar/sensor glyph on left, tabular battery & signal telemetry badge aligned to the right.

### Telemetry & IoT Status Badges
- **Online / Synced**: Pill shape, background `#E8F5E9`, text `#14532D`, border `1px solid rgba(30, 122, 76, 0.2)`. Features a 6px pulsing green indicator dot.
- **Searching / Provisioning**: Pill shape, background `#FFF3E0`, text `#E67E22`, accompanied by a subtle spinning hardware radar glyph.
- **Offline / Stale**: Pill shape, background `#F1F5F9`, text `#64748B`, border `1px solid #CBD5E1`.

### Stepper & Provisioning Progress
- Horizontal or vertical chain of 32px circular nodes. Active step features a solid `#1E7A4C` fill with white numeric glyph, surrounded by a `4px` ring in `#E8F5E9`.
- Completed steps display a check icon inside `#14532D`.
- Pending steps feature a crisp border in `#D1E7DD` with slate-gray numerical indicators (`#64748B`). Connecting track lines use `2px solid #D1E7DD` (or solid `#1E7A4C` when completed).

### Input Fields (Wi-Fi SSID, Calibration Offsets, Plant Nicknames)
- Surface `#FFFFFF`, border `1px solid #D1E7DD`, corner radius `0.5rem`, padding `0.75rem 1rem`.
- Focus ring: `2px solid #1E7A4C` with a `2px` offset wash of `#E8F5E9`.
- Placeholder text in `#94A3B8`. Helper microcopy in `#64748B`.

### Checkboxes & Radio Buttons
- 20px boxes and rings with `1.5px solid #D1E7DD`.
- Selected state fills with `#1E7A4C` and displays a crisp white check or center pip, accompanied by a subtle outer bloom in `#E8F5E9`.

### Action Sheets & Diagnostic Drawers
- Anchored to bottom on mobile, elevated with top corners rounded at `1.5rem` (24px).
- Features a top drag affordance (`36px x 4px`, rounded pill in `#CBD5E1`).
- Contains high-density hardware metrics: soil EC (electroconductivity), moisture %, lux level, ambient and probe temperatures.