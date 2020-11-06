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
import AnyCodable

public struct BridgeConfiguration: Codable {
  public var name: String
  public var serialNumber: String
  public var setupCode: String
}

public struct PluginConfiguration: Codable {
  public var plugin: String
  public var configuration: [String: AnyCodable]
}

public struct Configuration: Codable {
  public var bridge: BridgeConfiguration
  public var plugins: [PluginConfiguration]

  public static func load(from url: URL) throws -> Configuration {
    let configJson = try Data(contentsOf: url)

    return try load(from: configJson)
  }

  public static func load(from data: Data) throws -> Configuration {
    let decoder = JSONDecoder()

    return try decoder.decode(Configuration.self, from: data)
  }
}
