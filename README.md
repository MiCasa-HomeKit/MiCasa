<p align="center">
  <img src="https://raw.githubusercontent.com/MiCasa-HomeKit/MiCasaAssets/main/micasa-header.png"/>
</p>

## Goal
The goal of MiCasa is the provisioning of a HomeKit Bridge, such that devices not supported by HomeKit can also be integrated with the same.
Homebridge is another project that has exactly the same goal. The advantage of Homebridge is its maturity as well as the vast number of available
plugins. Its disadvantage: It's developed using Node.js. Running Homebridge on a Raspberry Pi 1 Model B with 512MB of RAM is a performance hog; it
requires about 15-20 minutes to launch Homebridge with all the plugins (in my case six plugins).

MiCasa is developed in Go which is compiled to native code and hence should run a lot faster. The disadvantage as of now is the fact, that
there are no device plugins available. But I hope that this is going to change.

## Status
MiCasa is currently in a Proof of Concept (PoC) state. I wanted to proof, that it's possible to externalize accessories to plugins. The plugins are linked as dynamic libraries. The use case for this PoC is the following:
- provide a plugin for switches
- the switches can be toggled using Apple's Home App
- the switches can be toggled using a REST service, either one by one or all of them at once
- the status of the switches can be requested using a REST service, either one by one or all of them at once

### Building and Installing the PoC
#### Prerquisites
##### macOS
Go 1.16 must be installed.

##### Linux
Go 1.16 must be installed.

#### Install MiCasa
- Clone the [GitHub Repository](https://github.com/MiCasa-HomeKit/MiCasa/tree/proof-of-concept):
  ```bash
  git clone --branch proof-of-concept https://github.com/MiCasa-HomeKit/MiCasa.git
  ```
- cd into the MiCasa directory:
  ```bash
  cd MiCasa
  ```
- Build and install:
  - macOS **TODO**
  - Linux **TODO**
  
#### Install MiCasaHttpSwitch
- Clone the [GitHub Repository](https://github.com/MiCasa-HomeKit/MiCasaHttpSwitch/tree/proof-of-concept):
  ```bash
  git clone --branch proof-of-concept https://github.com/MiCasa-HomeKit/MiCasaHttpSwitch.git
  ```
- cd into the MiCasaHttpSwitch directory:
  ```bash
  cd MiCasaHttpSwitch
  ```
- Build and install:
  - macOS **TODO**
  - Linux **TODO**

#### Launch MiCasa
**TODO**

Now you can add MiCasa to your home; the setup code is `421-68-945`.

You can control the switch also by accessing the following endpoints:
- Turn all switches on (HTTP method: POST):
  ```
  http://<YOUR-IP-ADDRESS>:18080/switches/on
  ```
- Turn all switches off (HTTP method: POST):
  ```
  http://<YOUR-IP-ADDRESS>:18080/switches/off
  ```
- Turn one specific switch on (HTTP method: POST):
  ```
  http://<YOUR-IP-ADDRESS>:18080/switches/terrarium-light/on
  ```
- Turn one specific switch off (HTTP method: POST):
  ```
  http://<YOUR-IP-ADDRESS>:18080/switches/terrarium-light/off
  ```
- Get switch status  (HTTP method: GET):
  ```
  http://<YOUR-IP-ADDRESS>:18080/switches/status
  ```

## Nest Steps
- [ ] Setup CI/CD pipeline
- [ ] Finalize first version of a stable Plugin API including documentation
- [ ] Create test cases for the Plugin API
- [ ] Implement proper error handling in MiCasa
- [ ] Create test cases for MiCasa
- [ ] Create concept for installing plugins without the need for logging in to the system
- [ ] Develop plugin that provides a web-based UI
- [ ] Develop device plugins :-)
