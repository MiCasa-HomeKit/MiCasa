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
import MiCasaPlugin

extension Bridge: ApiGateway {
  // MARK: - ApiGateway

  public var accessories: [Accessory] {
    return bridge.accessories
  }

  public func info(plugin: MiCasaPlugin, message: String) {
    Bridge.shared.loggers[plugin]?.info(.init(stringLiteral: message))
  }

  public func warning(plugin: MiCasaPlugin, message: String) {
    Bridge.shared.loggers[plugin]?.warning(.init(stringLiteral: message))
  }

  public func error(plugin: MiCasaPlugin, message: String) {
    Bridge.shared.loggers[plugin]?.error(.init(stringLiteral: message))
  }

  public func critical(plugin: MiCasaPlugin, message: String) {
    Bridge.shared.loggers[plugin]?.critical(.init(stringLiteral: message))
  }

  public func debug(plugin: MiCasaPlugin, message: String) {
    Bridge.shared.loggers[plugin]?.debug(.init(stringLiteral: message))
  }

  public func trace(plugin: MiCasaPlugin, message: String) {
    Bridge.shared.loggers[plugin]?.trace(.init(stringLiteral: message))
  }
}
