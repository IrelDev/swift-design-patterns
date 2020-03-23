//: [State pattern](@previous)
/*:
 Multicast delegate design pattern
 ============
 
 > The Multicast delegate pattern allows to create oneToMany relations, instead of oneToOne relation that's using in delegate pattern
 
 ## When to use the Multicast delegate pattern?
 Use this pattern if you want to create oneToMany object relationships. For example, we can use this pattern to catch clipboard changes on one device and transfer it to another, as in the example below.
 ## Example below shows how the Multicast delegate pattern works. Don't forget to launch playground to see the results.
 */
class MulticastDelegate<Delegate> {
    private var delegates = [WeakDelegateWrapper]()
    
    func addDelegate(delegate: Delegate) {
        delegates.append(WeakDelegateWrapper(delegate: delegate as AnyObject))
    }
    func removeDelegate(delegate: Delegate) {
        guard let index = delegates.firstIndex(where: {
            $0.delegate === (delegate as AnyObject)
        }) else { return }
        delegates.remove(at: index)
    }
    func invokeDelegates(_ closure: (Delegate) -> ()) {
        for (index, delegate) in delegates.enumerated() {
            if let delegate = delegate.delegate {
                closure(delegate as! Delegate)
            } else {
                delegates.remove(at: index)
            }
        }
    }
}
extension MulticastDelegate {
    private class WeakDelegateWrapper {
        weak var delegate: AnyObject?
        
        init(delegate: AnyObject) {
            self.delegate = delegate
        }
    }
}
extension MulticastDelegate {
    static func += <Delegate: AnyObject> (lhs: MulticastDelegate<Delegate>, rhs: Delegate) {
        lhs.addDelegate(delegate: rhs)
    }
    
    static func -= <Delegate: AnyObject> (lhs: MulticastDelegate<Delegate>, rhs: Delegate) {
        lhs.removeDelegate(delegate: rhs)
    }
}
//: USAGE
protocol DelegateProtocol {
    var clipboard: String? { get }
    
    func copyToClipboard(with text: String)
}
class Macbook: DelegateProtocol {
    var clipboard: String?
    
    func copyToClipboard(with text: String) {
        print("Now macbook clipboard contains '\(text)'")
        clipboard = text
    }
    init(clipboard: String? = nil) {
        self.clipboard = clipboard
    }
}
class Iphone: DelegateProtocol {
    var clipboard: String?
    
    func copyToClipboard(with text: String) {
        print("Now iPhone clipboard contains '\(text)'")
        clipboard = text
    }
    init(clipboard: String? = nil) {
        self.clipboard = clipboard
    }
}
class Ipad: DelegateProtocol {
    var clipboard: String?
    
    func copyToClipboard(with text: String) {
        print("Now iPad clipboard contains '\(text)'")
        clipboard = text
    }
    init(clipboard: String? = nil) {
        self.clipboard = clipboard
    }
}
let multicastDelegate =
    MulticastDelegate<DelegateProtocol>()

let macbook = Macbook()
let iPhone = Iphone()
let iPad = Ipad()

multicastDelegate.addDelegate(delegate: macbook)
multicastDelegate.addDelegate(delegate: iPhone)
multicastDelegate.addDelegate(delegate: iPad)

multicastDelegate.invokeDelegates {
    $0.copyToClipboard(with: "I got a notification!")
}

print()

multicastDelegate.invokeDelegates({
    if let clipboardText = $0.clipboard {
        print(clipboardText)
    }
})

print()

multicastDelegate.removeDelegate(delegate: iPhone)
multicastDelegate.invokeDelegates {
    $0.copyToClipboard(with: "iPhone has gone :(")
}

print("\n\(iPhone.clipboard!)")
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
