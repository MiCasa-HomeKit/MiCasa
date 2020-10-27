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
import ArgumentParser
import micasaLib

struct MiCasa: ParsableCommand {
    @Option(name: .shortAndLong, help: "Directory where plugins are stored.")
    var pluginDir: String = "/usr/local/lib/mi-casa-plugins"

    @Option(name: .shortAndLong, help: "Fully qualified path of the configuration file.")
    var configFile: String = "/etc/mi-casa.conf"

    mutating func run() throws {
        let pluginDirUrl = URL(fileURLWithPath: pluginDir, isDirectory: true)
        let configFileUrl = URL(fileURLWithPath: configFile, isDirectory: false)
        let bridge = try Bridge(configFile: configFileUrl, pluginDir: pluginDirUrl)

        bridge.start()
    }
}

MiCasa.main()
