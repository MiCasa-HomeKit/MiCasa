/*
 Copyright 2020 MiCasa Development Team

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation
import HAP

class BridgeDelegate: DeviceDelegate {

    // MARK: - Private Properties

    private var bridge: Device


    // MARK: - Initialization

    init(bridge: Device) {
        self.bridge = bridge
    }


    // MARK: - DeviceDelegate

    func didRequestIdentificationOf(_ accessory: Accessory) {
        Bridge
            .shared
            .logger
            .info("Requested identification of accessory \(String(describing: accessory.info.name.value ?? ""))")

        Bridge.shared.accessoryMap[accessory]?.identify(accessory: accessory)
    }

    func characteristic<T>(
        _ characteristic: GenericCharacteristic<T>,
        ofService service: Service,
        ofAccessory accessory: Accessory,
        didChangeValue newValue: T?) {

        Bridge
            .shared
            .logger
            .info("Characteristic \(characteristic) in service \(service.type) of accessory \(accessory.info.name.value ?? "") did change: \(String(describing: newValue))")

        Bridge
            .shared
            .accessoryMap[accessory]?
            .characteristic(
                characteristic,
                ofService: service,
                ofAccessory: accessory,
                didChangeValue: newValue)
    }

    func characteristicListenerDidSubscribe(
        _ accessory: Accessory,
        service: Service,
        characteristic: AnyCharacteristic) {

        Bridge
            .shared
            .logger
            .info("Characteristic \(characteristic) in service \(service.type) of accessory \(accessory.info.name.value ?? "") got a subscriber")
    }

    func characteristicListenerDidUnsubscribe(
        _ accessory: Accessory,
        service: Service,
        characteristic: AnyCharacteristic) {

        Bridge
            .shared
            .logger
            .info("Characteristic \(characteristic) in service \(service.type) of accessory \(accessory.info.name.value ?? "") lost a subscriber")
    }

    func didChangePairingState(from: PairingState, to: PairingState) {
        if to == .notPaired {
            logPairingInstructions()
        }
    }

    func logPairingInstructions() {
        if bridge.isPaired {
            Bridge
                .shared
                .logger
                .warning("The device is paired, either unpair using your iPhone or remove the configuration file `cache.json`.")
        } else {
            Bridge
                .shared
                .logger
                .info("Scan the following QR code using your iPhone to pair this device:")
            Bridge
                .shared
                .logger
                .info(.init(stringLiteral: bridge.setupQRCode.asText))
        }
    }
}
