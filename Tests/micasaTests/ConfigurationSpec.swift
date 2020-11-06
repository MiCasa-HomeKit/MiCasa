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
import Quick
import Nimble

@testable import micasaLib

final class ConfigurationSpec: QuickSpec {

    override func spec() {

        describe("Loading simple configuration") {

            var config: micasaLib.Configuration!
            var configFileUrl: URL!

            it("Get config file url") {
                let path = Bundle.module.path(forResource: "simple", ofType: "conf")

                configFileUrl = URL(fileURLWithPath: path!)
            }

            it("Read configuration file") {
                config = try! micasaLib.Configuration.load(from: configFileUrl!)
            }

            it("The configuration was read correctly") {
                expect(config.bridge.name).to(equal("MiCasa"))
                expect(config.bridge.serialNumber).to(equal("db168945-a3c9-4bbb-9b54-96776ffc4f54"))
                expect(config.bridge.setupCode).to(equal("421-68-945"))
                expect(config.plugins.count).to(equal(0))
            }
        }

        describe("Loading complex configuration") {

            var config: micasaLib.Configuration!
            var configFileUrl: URL!

            it("Get config file url") {
                let path = Bundle.module.path(forResource: "complex", ofType: "conf")

                configFileUrl = URL(fileURLWithPath: path!)
            }

            it("Read configuration file") {
                config = try! micasaLib.Configuration.load(from: configFileUrl!)
            }

            it("The configuration was read correctly") {
                expect(config.bridge.name).to(equal("MiCasa"))
                expect(config.bridge.serialNumber).to(equal("db168945-a3c9-4bbb-9b54-96776ffc4f54"))
                expect(config.bridge.setupCode).to(equal("421-68-945"))
                expect(config.plugins.count).to(equal(1))

                expect(config.plugins[0].plugin).to(equal("mi-casa-http-switch"))
                expect(config.plugins[0].configuration["port"]).to(equal(18080))
                expect((config.plugins[0].configuration["accessories"]!.value as! [Any]).count).to(equal(2))

                let accessories = config.plugins[0].configuration["accessories"]!.value as! [[String:Any]]

                expect((accessories[0]["name"] as! String)).to(equal("Terrarium: Licht"))
                expect((accessories[0]["id"] as! String)).to(equal("terrarium-licht"))
                expect((accessories[0]["serialNumber"] as! String)).to(equal("cb00362f-046f-4571-ae0b-f2b42ff95691"))

                expect((accessories[1]["name"] as! String)).to(equal("Küche: LED-Stripe"))
                expect((accessories[1]["id"] as! String)).to(equal("kitchen-led-stripe"))
                expect((accessories[1]["serialNumber"] as! String)).to(equal("4642d96f-433e-4dda-b724-a839f6c77205"))
            }
        }

    }
}
