//: [MVVM pattern](@previous)
/*:
 Adapter design pattern
 ============
 
 > The Adapter pattern allows one type to work with other incompatible type.
 >
 > The Adapter pattern has two parts, specifically  legacy object and adapter.
 > * Legacy object is an object that implements some logic.
 > * Adapter calls to a legacy object and converts its interface or result.
 
 ## When to use the Adapter pattern?
 Use this pattern when you want to change the interface of an object but can't change it. You can choose this pattern to implement your own interface for third-party libraries and platforms.
 
 ## Example below shows how the Adapter pattern works. Don't forget to launch playground to see the results.
 */
enum Service: String {
    case haircut
    case massage
}
//: LEGACY OBJECT
struct LegacyObject {
    func payForService(service: Service) -> Double {
        switch service {
        case .haircut:
            return 10
        case .massage:
            return 16
        }
    }
}
protocol AdapterProtocol {
    var adaptee: LegacyObject { get }
    
    @discardableResult
    func payForService(service: Service) -> Double
}
//: ADAPTER
struct DollarAdapter: AdapterProtocol {
    internal let adaptee: LegacyObject
    
    init(adaptee: LegacyObject) {
        self.adaptee = adaptee
    }
    
    func payForService(service: Service) -> Double {
        1.10 * adaptee.payForService(service: service)
    }
}
//: ADAPTER
struct RubleAdapter: AdapterProtocol {
    internal let adaptee: LegacyObject
    
    init(adaptee: LegacyObject) {
        self.adaptee = adaptee
    }
    
    func payForService(service: Service) -> Double {
        65 * adaptee.payForService(service: service)
    }
}
enum NewСurrency: String {
    case Dollars
    case Rubles
}
struct Person {
    private var adapter: AdapterProtocol
    private var preferredCurrency: NewСurrency
    private let legacyObject = LegacyObject()
    
    init(preferredCurrency: NewСurrency) {
        self.preferredCurrency = preferredCurrency
        
        switch preferredCurrency {
        case .Dollars:
            adapter = DollarAdapter(adaptee: legacyObject)
        case .Rubles:
            adapter = RubleAdapter(adaptee: legacyObject)
        }
    }
    func useService(service: Service) {
        print("Person paid \(adapter.payForService(service: service)) \(preferredCurrency.rawValue) for the \(service.rawValue)")
    }
}
//: ADAPTER USAGE
let person = Person(preferredCurrency: .Dollars)
person.useService(service: .haircut)

let secondPerson = Person(preferredCurrency: .Rubles)
secondPerson.useService(service: .massage)

//: LEGACY USAGE
let legacyPaymentSystem = LegacyObject().payForService(service: .haircut)
print("Person paid \(legacyPaymentSystem) Euros for haircut")
//: [Facade pattern](@next)
/*:
 MIT License
 
 Copyright (c) 2020 Kirill Pustovalov
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */



