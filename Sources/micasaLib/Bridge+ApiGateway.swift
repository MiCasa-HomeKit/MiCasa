//
//  File.swift
//  
//
//  Created by Thomas Bonk on 28.10.20.
//

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
