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
import Logging
import HAP

public final class Bridge {

    // MARK: - Private Properties

    public private(set) static var shared: Bridge = { Bridge() }()

    private let logger = Logger(label: "mi-casa.bridge")
    private var keepRunning = true
    private var configuration: Configuration!
    private var bridge: Device!
    private var server: Server! = nil
    

    // MARK: - Initialization

    private init() {
        // Empty by design
    }

    public func initialize(configFile configFileUrl: URL, pluginDir pluginDirUrl: URL) throws {
        configuration = try Configuration.load(from: configFileUrl)
        bridge =
            Device(
                bridgeInfo:
                    Service.Info(name: configuration.bridge.name, serialNumber: configuration.bridge.serialNumber),
                setupCode: Device.SetupCode(stringLiteral: configuration.bridge.setupCode),
                storage: FileStorage(filename: "a.json"),
                accessories: [])
    }


    // MARK: - API

    public func stop() {
        DispatchQueue.main.async {
            self.logger.info("Shutting MiCasa Bridge down...")
            self.keepRunning = false
        }
    }

    public func start() throws {
        logger.info("Starting MiCasa Bridge")

        signal(SIGINT) { _ in
            Bridge.shared.stop()
        }
        signal(SIGTERM) { _ in
            Bridge.shared.stop()
        }

        server = try Server(device: bridge, listenPort: 8000)

        withExtendedLifetime([]) {
            while keepRunning {
                RunLoop.current.run(mode: .default, before: Date.distantFuture)
            }
        }
    }
}
