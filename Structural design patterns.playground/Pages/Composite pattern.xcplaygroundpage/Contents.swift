//: [Flyweight pattern](@previous)
/*:
 Composite design pattern
 ============
 
 > The Composite pattern allows you to represent a group of objects as a single tree-structured object.
 ## When to use the Composite pattern?
 
 Using this pattern makes sense if you want to create an object that should be structured as a tree.
 
 ## Example below shows how the Composite pattern works. Don't forget to launch playground to see the results.
 */
import Foundation

protocol Component {
    var name: String { get set }
    
    func description()
}
struct Worker: Component {
    var name: String
    
    func description() {
        print("Worker with name \(name)")
    }
}
class Department: Component {
    var name: String
    var components: [Component]
    
    func description() {
        print("\nDepartment name: \(name)")
        components.forEach({
            print($0.name)
        })
    }
    func addComponent(component: Component) -> Bool {
        if components.contains(where: {
            $0.name == component.name
        }) { return false } else {
            components.append(component)
            return true
        }
    }
    func removeComponent(component: Component) -> Bool {
        guard let index = components.firstIndex(where: {
            $0.name == component.name
        }) else { return false}
        components.remove(at: index)
        return true
    }
    
    init(name: String, components: [Worker] = []) {
        self.name = name
        self.components = components
    }
}
let john = Worker(name: "John Worker")
let mary = Worker(name: "Mary Worker")

let security = Department(name: "Security Department")
security.addComponent(component: john)
security.description()

let securityWithGun = Department(name: "Gun Security Department")
securityWithGun.addComponent(component: mary)
securityWithGun.description()

security.addComponent(component: securityWithGun)
security.description()
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

