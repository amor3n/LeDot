# GPD Duo — Full Spec Sheet

## Processor
- AMD Ryzen AI 9 HX 370 + Radeon 890M (RDNA 3.5, 16 CUs, 1024 stream processors)

## Memory
- LPDDR5x @ 7500MT/s
- 32gb

## Storage
- 2x M.2 NVMe slots, PCIe 4.0 x4 each
- Supports 2280 single-sided SSDs
- Expandable up to 16TB total (8TB + 8TB)

## Displays
- 2x 13.3" AMOLED, 2880x1800 @ 60Hz
- Up to 500 nits peak brightness (400 nits typical)
- 255 PPI
- 10-point touch, 4096 levels of stylus pressure sensitivity
- 100% Adobe RGB, 133% sRGB coverage, factory-calibrated Delta E < 1
- Secondary screen: 360° hinge, foldable behind primary, supports USB-C video input (DP Alt Mode, video only — no audio/data)

## Battery
- 80Wh lithium polymer
- Fast charge to 50% in 29 minutes
- 100W PD fast charging support
- Claimed up to 30.2 hrs (150 nits, silent mode, network off)
- Typical real-world use: 6-8 hrs

## Ports
- **Right side:** Power button w/ integrated fingerprint sensor, 2x USB 3.2 Gen 1 Type-A
- **Left side:** USB4 Type-C (40Gbps, video + charging), USB 3.2 Gen 2 Type-C (10Gbps, video + power), full-size SDXC 4.0 card reader, 3.5mm audio jack
- **Back:** 2.5Gbps Ethernet, OCuLink (PCIe 4.0 x4, 63Gbps effective bandwidth — eGPU support e.g. GPD G1), HDMI

## Physical
- Dimensions: 11.69 x 8.25 x 0.94 in (29.7 x 20.97 x 2.38 cm)
- Weight: 2.2kg (4.85 lbs)

## Input
- Full QWERTY chiclet keyboard, island-style, white backlighting
- Precision touchpad (PTP mode) w/ left/right click vibration feedback

## Design
- Tri-fold, dual-hinge design
- 360° hinge on upper display
- Fully extended: ~18" combined vertical display area
- Folds down to roughly A4 paper size

## eGPU Support
- OCuLink port, direct PCIe connection, 63Gbps effective bandwidth
- Compatible with GPD G1 eGPU dock

---
*Note: kernel params in `power.nix` (`amd_pstate=active`) indicate this unit is running the HX 370 configuration.*