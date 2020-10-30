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
import MiCasaPlugin

/**
 * Errors that can occur when loading a plugin.
 */
public enum PluginManagerError: Error {
    /**
     * An error occured while opening the plugin.
     *
     * Parameters:
     * - path: The path of the plugin
     * - error: The error description
     */
    case errorWhileOpeningPlugin(path: String, error: String)

    /**
     * An unknown error occured while opening the plugin.
     *
     * Parameters:
     * - path: The path of the plugin
     */
    case unknownErrorWhileOpeningPlugin(path: String)

    /**
     * The function that should return the plugin builder instance
     * hasn't been found in the plugin.
     *
     * Parameters:
     * - symbol: Name of the function
     * - path: The path of the plugin
     */
    case symbolNotFound(symbol: String, path: String)
}


private typealias InitFunction = @convention(c) () -> UnsafeMutableRawPointer

let PluginExtension = "mcplugin"

class PluginManager<PluginType> where PluginType: MiCasaPlugin {

    // MARK: - Private Properties

    private var plugins: [MiCasaPluginBuilder<PluginType>] = []


    // MARK: - Initialization

    init(withUrls urls: [URL]) throws {
        plugins = try loadPlugins(atUrls: urls)
    }


    // MARK: - Plugin Manager API

    func pluginBuilder(forPlugin name: String) -> MiCasaPluginBuilder<PluginType>? {
        return
            plugins.first { pluginBuilder in
                pluginBuilder.pluginName == name
            }
    }

    func loadPlugin(atPath path: String) throws -> MiCasaPluginBuilder<PluginType> {
        guard let openRes = dlopen(path, RTLD_NOW|RTLD_LOCAL) else {
            if let err = dlerror() {
                throw PluginManagerError.errorWhileOpeningPlugin(path: path, error: String(format: "%s", err))
            } else {
                throw PluginManagerError.unknownErrorWhileOpeningPlugin(path: path)
            }
        }

        defer {
            dlclose(openRes)
        }

        let symbolName = "createPluginBuilder"

        guard let sym = dlsym(openRes, symbolName) else {
            throw PluginManagerError.symbolNotFound(symbol: symbolName, path: path)
        }

        let createPlugin = unsafeBitCast(sym, to: InitFunction.self)
        let pluginBuilderPointer = createPlugin()
        let builder = Unmanaged<MiCasaPluginBuilder<PluginType>>.fromOpaque(pluginBuilderPointer).takeRetainedValue()

        return builder
    }

    func loadPlugins(atPath path: String) throws -> [MiCasaPluginBuilder<PluginType>] {
        let fm = FileManager.default
        let items = try fm.contentsOfDirectory(atPath: path)

        return try items
            .filter { item in item.hasSuffix(PluginExtension) }
            .map { item in path + "/" + item }
            .map { item in return try loadPlugin(atPath: item) }
    }

    func loadPlugins(atPaths paths: [String]) throws -> [MiCasaPluginBuilder<PluginType>] {
        return
            try paths
                .map { path in try loadPlugins(atPath: path) }
                .flatMap { $0 }
    }

    func loadPlugins(atUrls urls: [URL]) throws -> [MiCasaPluginBuilder<PluginType>] {
        return try loadPlugins(atPaths: urls.map { url in url.path })
    }
}
