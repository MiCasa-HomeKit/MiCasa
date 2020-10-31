<p align="center">
  <img src="https://raw.githubusercontent.com/MiCasa-HomeKit/MiCasaAssets/main/micasa-header.png"/>
</p>

MiCasa is a bridge that adds HomeKit support for Non-HomeKit accessories. MiCasa accessories are developped in Swift as dynamic 
libraries.

## Status
MiCasa is currently in a Proof of Concept (PoC) state. I wanted to proof, that it's possible to externalize accessories to plugins. The plugins are linked as dynamic libraries. The use case for this PoC is the following:
- provide a plugin for switches
- the switches can be toggled using Apple's Home App
- the switches can be toggled using a REST service, either one by one or all of them at once
- the status of the switches can be requested using a REST service, either one by one or all of them at once

