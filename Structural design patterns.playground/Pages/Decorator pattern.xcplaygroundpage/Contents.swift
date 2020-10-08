//: [Composite pattern](@previous)
/*:
 Decorator design pattern
 ============
 
 > The decorator pattern is a design pattern that allows behavior to be added to an individual object, dynamically, without affecting the behavior of other objects from the same class.
 
 ## Example below shows how the Decorator pattern works. Don't forget to launch playground to see the results.
 */
enum Service: String {
    case haircut
    case massage
}
struct ObjectToBeDecorated {
    func payForService(service: Service) -> Double {
        switch service {
        case .haircut:
            return 10
        case .massage:
            return 16
        }
    }
}
protocol DecoratorProtocol {
    var objectToBeDecorated: ObjectToBeDecorated { get }
    
    @discardableResult
    func payForService(service: Service) -> Double
}
//: DECORATOR
struct EuroDecorator: DecoratorProtocol {
    internal let objectToBeDecorated: ObjectToBeDecorated
    
    func payForService(service: Service) -> Double {
        1.10 * objectToBeDecorated.payForService(service: service)
    }
}
//: DECORATOR
struct RubleDecorator: DecoratorProtocol {
    internal let objectToBeDecorated: ObjectToBeDecorated
    
    func payForService(service: Service) -> Double {
        65 * objectToBeDecorated.payForService(service: service)
    }
}
enum NewСurrency: String {
    case Dollars
    case Rubles
}
struct Person {
    private var decorator: DecoratorProtocol
    private var preferredCurrency: NewСurrency
    private let objectToBeDecorated = ObjectToBeDecorated()
    
    init(preferredCurrency: NewСurrency) {
        self.preferredCurrency = preferredCurrency
        
        switch preferredCurrency {
        case .Dollars:
            decorator = EuroDecorator(objectToBeDecorated: objectToBeDecorated)
        case .Rubles:
            decorator = RubleDecorator(objectToBeDecorated: objectToBeDecorated)
        }
    }
    func useService(service: Service) {
        print("Person paid \(decorator.payForService(service: service)) \(preferredCurrency.rawValue) for the \(service.rawValue)")
    }
}
//: DECORATOR USAGE
let person = Person(preferredCurrency: .Dollars)
person.useService(service: .haircut)

let secondPerson = Person(preferredCurrency: .Rubles)
secondPerson.useService(service: .massage)

//: STANDART OBJECT USAGE
let standartPaymentSystem = ObjectToBeDecorated().payForService(service: .haircut)
print("Person paid \(standartPaymentSystem) Euros for haircut")
//: [Next design pattern](@next)
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

