//: [Multicast delegate pattern](@previous)
/*:
 Mediator design pattern
 ============
 
 > The Mediator pattern allows to encapsulate the interaction of objects between each other.
 > The Mediator pattern is very similar to the multicast delegate pattern but it have a few differences.
 ## Example below shows how the Mediator pattern works. Don't forget to launch playground to see the results.
 */
class Mediator<ObjectType> {
    private var wrappers: [ObjectWrapper] = []
    
    var nonNilObjects: [ObjectType] {
        var objects: [ObjectType] = []
        
        wrappers = wrappers.filter({
            guard let object = $0.object else { return false }
            objects.append(object)
            return true
        })
        return objects
    }
    func addObject(object: ObjectType, isStrongReference: Bool = true) {
        let wrapper: ObjectWrapper
        
        wrapper = isStrongReference ? ObjectWrapper(strongReference: object) : ObjectWrapper(weakReference: object)
        
        wrappers.append(wrapper)
    }
    func removeObject(object: ObjectType) {
        guard let index = wrappers.firstIndex(where: {
            ($0 as AnyObject) === (object as AnyObject)
        }) else { return }
        wrappers.remove(at: index)
    }
    func invokeObjects(_ closure: (ObjectType) -> ()) {
        for (index, object) in wrappers.enumerated() {
            if let object = object.object {
                closure(object)
            } else {
                wrappers.remove(at: index)
            }
        }
    }
    class ObjectWrapper {
        var strongReference: AnyObject? //in case if you want to save an object
        weak var weakReference: AnyObject?
        
        var object: ObjectType? {
            (weakReference ?? strongReference) as? ObjectType
        }
        init(strongReference: ObjectType?) {
            self.strongReference = strongReference as AnyObject
            if self.weakReference != nil { self.weakReference = nil }
        }
        init(weakReference: ObjectType?) {
            self.weakReference = weakReference as AnyObject
            if self.strongReference != nil { self.strongReference = nil }
        }
    }
}
protocol Object: class {
    func recieve(_ object: Object?, sentMessage message: String)
}
protocol MediatorProtocol {
    func addObject(object: Object)
    func sendClipboardContents(message: String, from object: Object)
}
class AppleTech: Object {
    var name: String
    
    var mediator: MediatorProtocol
    
    init(mediator: MediatorProtocol, name: String) {
        self.mediator = mediator
        self.name = name
        mediator.addObject(object: self)
    }
    func sendMessage(message: String) {
        print("\(name) sent message \(message)\n")
        mediator.sendClipboardContents(message: message, from: self)
    }
    func recieve(_ object: Object?, sentMessage message: String) {
        print("\(name) recieved: \(message)")
    }
}
class AppleTechMediator: Mediator<Object>, MediatorProtocol {
    func addObject(object: Object) {
        self.addObject(object: object, isStrongReference: true)
    }
    
    func sendClipboardContents(message: String, from object: Object) {
        invokeObjects({
            $0.recieve(object, sentMessage: message)
        })
    }
}
let mediator = AppleTechMediator()

let iPad = AppleTech(mediator: mediator, name: "iPad")
let iPhone = AppleTech(mediator: mediator, name: "iPhone")
let macBook = AppleTech(mediator: mediator, name: "MacBook")

iPad.sendMessage(message: "Hey! i'm clipboard!")

print()

mediator.invokeObjects({
    $0.recieve(nil, sentMessage: "Initial clipboard state")
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
