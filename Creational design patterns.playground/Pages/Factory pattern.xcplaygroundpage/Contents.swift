//: [Builder pattern](@previous)

/*:
 Factory design pattern
 ============
 
 > The Factory pattern allows to simply create objects using only one step and it allows to change a type of a object at runtime.
 >
 > The Factory pattern has two parts, specifically factory and its products.
 > * Factory creates products.
 >*  Product is an object that will be created by the factory.
 
 ## When to use the Factory pattern?
 Use this pattern when you want to create a simple object using only one step and it's useful when we have a lot of different objects as in example below.
 >* Note that this pattern is similar to the Builder pattern but builder pattern is using when you cannot create an object in one step.
 
 ## Example below shows how the Factory pattern works. Don't forget to open live view and launch playground to see the results and layout.
 */
import UIKit

enum Cities {
    case LosAngeles
    case NewYork
}
protocol DistrictProtocol {
    var name: String { get set }
    var code: Int { get set }
}
extension DistrictProtocol where Self: CustomStringConvertible {
    internal var description: String {
        String(describing: "District name: \(name), district code: \(code)")
    }
}
struct WestHollywood: DistrictProtocol {
    var name: String = "West Hollywood"
    
    var code: Int = 144
}
struct BeverlyHills: DistrictProtocol {
    var name: String = "Beverly Hills"
    
    var code: Int = 15
}
struct Manhattan: DistrictProtocol {
    var name: String = "Manhattan"
    
    var code: Int = 4
}
struct Brooklyn: DistrictProtocol {
    var name: String = "Brooklyn"
    
    var code: Int = 5
}
//: FACTORY
class DistrictFactory {
    func districts(of city: Cities) -> [DistrictProtocol]? {
        switch city {
        case .LosAngeles:
            return [WestHollywood(), BeverlyHills()]
        case .NewYork:
            return [Manhattan(), Brooklyn()]
        }
    }
}
//: USAGE
var factory = DistrictFactory()
factory.districts(of: .NewYork)?.forEach({
    print($0)
})
factory.districts(of: .LosAngeles)?.forEach({
    print($0)
})
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
