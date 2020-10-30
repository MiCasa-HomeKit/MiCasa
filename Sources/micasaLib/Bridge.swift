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
import MiCasaPlugin
import AnyCodable


public final class Bridge {    

    // MARK: - Public Class Properties

    public private(set) static var shared: Bridge = { Bridge() }()


    // MARK: - Public Properties

    public let logger = Logger(label: "mi-casa.bridge")

    public private(set) var accessoryMap: [Accessory:MiCasaPlugin] = [:]
    public private(set) var plugins: [MiCasaPlugin]!
    public private(set) var loggers: [MiCasaPlugin:Logger] = [:]


    // MARK: - Private Properties

    private  var keepRunning = true
    private  var configuration: Configuration!
    private  var pluginManager: PluginManager<MiCasaPlugin>!
    internal var bridge: Device!
    private  var bridgeDelegate: BridgeDelegate!
    private  var server: Server! = nil
    

    // MARK: - Initialization

    private init() {
        // Empty by design
    }

    public func initialize(
        configFile configFileUrl: URL,
        storageFile storageFileUrl: URL,
        pluginDirs pluginDirUrls: [URL]) throws {
        
        configuration = try Configuration.load(from: configFileUrl)
        pluginManager = try PluginManager(withUrls: pluginDirUrls)
        bridge =
            Device(
                bridgeInfo:
                    Service.Info(
                        name: configuration.bridge.name,
                        serialNumber: configuration.bridge.serialNumber,
                        manufacturer: "MiCasa Development Team",
                        model: "MiCasa Bridge",
                        firmwareRevision: "0.0.1"),
                setupCode: Device.SetupCode(stringLiteral: configuration.bridge.setupCode),
                storage: FileStorage(filename: storageFileUrl.path),
                accessories: [])
        bridgeDelegate = BridgeDelegate(bridge: bridge)
        bridge.delegate = bridgeDelegate

        let pluginBuilders = pluginBuildersFor(plugins: configuration.plugins)

        plugins = build(plugins: configuration.plugins, with: pluginBuilders)
        createLoggers(for: plugins)
        bridge
            .addAccessories(
                initializeAccessories(from: plugins))

        plugins.forEach { plugin in plugin.start() }
    }

    private func initializeAccessories(from plugins: [MiCasaPlugin]) -> [Accessory] {
        let pluginAccessories =
            plugins
                .map { plugin in
                    (plugin: plugin, accessories: plugin.accessories())
                }

        pluginAccessories
            .forEach { pluginAccessory in
                pluginAccessory
                    .accessories
                    .forEach { accessory in
                        accessoryMap[accessory] = pluginAccessory.plugin
                    }
            }

        return
            pluginAccessories
                .map { pluginAccessory in
                    pluginAccessory.accessories
                }
                .flatMap { $0 }
    }

    private func pluginBuildersFor(plugins: [PluginConfiguration]) -> [MiCasaPluginBuilder<MiCasaPlugin>] {
        return
            plugins
                .map { pluginConfiguration in
                    pluginConfiguration.plugin
                }
                .map { pluginName in
                    pluginManager.pluginBuilder(forPlugin: pluginName)
                }
                .filter { pluginBuilder in
                    pluginBuilder != nil
                }
                .map { pluginBuilder in
                    pluginBuilder!
                }
    }

    private func build(
        plugins: [PluginConfiguration],
        with builders: [MiCasaPluginBuilder<MiCasaPlugin>]) -> [MiCasaPlugin] {

        return
            builders
                .map { builder in
                    let config = configuration(for: builder.pluginName, from: plugins)
                    let jsonData = try? JSONEncoder().encode(config)

                    return builder.build(apiGateway: self, configuration: jsonData!)
                }
    }

    private func configuration(for pluginName: String, from configurations: [PluginConfiguration]) -> [String:AnyCodable] {
        return
            configurations
                .first { pluginConf in
                    pluginConf.plugin == pluginName
                }
                .map { pluginConf in
                    pluginConf.configuration
                }!
    }

    private func createLoggers(for plugins: [MiCasaPlugin]) {
        plugins
            .forEach { plugin in
                loggers[plugin] = Logger(label: String(describing: plugin.self))
            }
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

extension Accessory: Hashable {

    // MARK: - Equatable

    public static func == (lhs: Accessory, rhs: Accessory) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    public var hashValue: Int {
        return self.serialNumber.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.serialNumber)
    }
}
