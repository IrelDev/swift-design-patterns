//: [Facade pattern](@previous)
/*:
 Flyweight design pattern
 ============
 
 > The Flyweight pattern allows an object to represents itself as a unique instance but it's not. That allows to use less memory.
 ## When to use the Flyweight pattern?
 > The Flyweight pattern is a variation on the Singleton pattern.
 
 Use this pattern when you'd use singleton pattern but you need multiple instances with different configurations.
 
 ## Example below shows how the Flyweight pattern works. Don't forget to launch playground to see the results.
 */
import UIKit

enum ObjectDraftType: String {
    case typeOne
    case typeTwo
    case typeThree
    case typeFour
}
class ObjectDraft {
    var objectDraftColor: UIColor
    var objectDraftType: ObjectDraftType
    
    init(objectColor: UIColor, objectDraftType: ObjectDraftType) {
        self.objectDraftColor = objectColor
        self.objectDraftType = objectDraftType
    }
}
extension ObjectDraft: CustomStringConvertible {
    var description: String {
        String(describing: "MemoryAddress: \(Unmanaged<ObjectDraft>.passRetained(self).toOpaque()), color: \(objectDraftColor), objectType: \(objectDraftType.rawValue)")
    }
}

class ObjectDraftFactory {
    static private var drafts: [ObjectDraftType: ObjectDraft] = [:] {
        didSet {
            print("Amount of sprites has changed to \(drafts.count)")
        }
    }
    static func createObjectDraft(with type: ObjectDraftType) -> ObjectDraft {
        if let objectDraft = drafts[type] {
            return objectDraft
        } else {
            var newDraft: ObjectDraft
            switch type {
            case .typeOne:
                newDraft = ObjectDraft(objectColor: .black, objectDraftType: type)
            case .typeTwo:
                newDraft = ObjectDraft(objectColor: .red, objectDraftType: type)
            case .typeThree:
                newDraft = ObjectDraft(objectColor: .blue, objectDraftType: type)
            case .typeFour:
                newDraft = ObjectDraft(objectColor: .clear, objectDraftType: type)
            }
            drafts[type] = newDraft
            return newDraft
        }
    }
}
class Object {
    var id: Int
    var draft: ObjectDraft
    init(id: Int, draft: ObjectDraft) {
        self.id = id
        self.draft = draft
    }
}
extension Object: CustomStringConvertible {
    var description: String {
        String(describing: "Object id: \(id), draft: \(draft.description)")
    }
}
let types: [ObjectDraftType] = [.typeOne, .typeTwo, .typeThree, .typeFour]

for id in 0..<1000 {
    let type = types[Int(arc4random_uniform(UInt32(types.count)))]
    let draft = ObjectDraftFactory.createObjectDraft(with: type)
    let object = Object(id: id, draft: draft)
    print(object)
}
//: [Composite pattern](@next)
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
