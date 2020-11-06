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
  @Option(name: .shortAndLong, help: "Directories where plugins are stored.")
  var pluginDirs: [String] = ["/usr/local/lib/mi-casa-plugins"]

  @Option(name: .shortAndLong, help: "Fully qualified path of the cache file.")
  var storageFile: String = "/var/mi-casa/cache.json"

  @Option(name: .shortAndLong, help: "Fully qualified path of the configuration file.")
  var configFile: String = "/etc/mi-casa.conf"

  mutating func run() throws {
    let pluginDirUrls = pluginDirs.map { pluginDir in URL(fileURLWithPath: pluginDir, isDirectory: true) }
    let configFileUrl = URL(fileURLWithPath: configFile, isDirectory: false)
    let storageFileUrl = URL(fileURLWithPath: storageFile, isDirectory: false)

    try Bridge
      .shared
      .initialize(
        configFile: configFileUrl,
        storageFile: storageFileUrl,
        pluginDirs: pluginDirUrls)
    try Bridge.shared.start()
  }
}

MiCasa.main()
