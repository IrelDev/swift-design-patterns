//: [Observer pattern](@previous)
/*:
 Iterator design pattern
 ============
 
 > The Iterator pattern allows to iterate through a collection.
 
 ## When to use the Iterator pattern?
 Use this pattern when you want to iterate through a custom type using standart tools like for _ in, forEach and etc.
 For example, you can use this pattern when you want to iterate over a Stack data structure, as in the example below.
 
 ## Example below shows how the Iterator pattern works. Don't forget to launch playground to see the results.
 */
struct Stack<Element: Comparable> {
    private var elements = [Element]()
    
    init(elements: [Element]) {
        self.elements = elements
    }
}
extension Stack: CustomStringConvertible {
    public var description: String {
        """
        StackTop
        \(elements.map { "\($0)" }.reversed().joined(separator: "\n"))
        StackBot\n
        """
    }
}
extension Stack {
    public var isEmpty: Bool {
        elements.isEmpty
    }
    public mutating func push(_ element: Element) {
        elements.append(element)
    }
    @discardableResult
    public mutating func pop() -> Element? {
        elements.popLast()
    }
    public func lastElement() -> Element? {
        elements.last
    }
}
//: ITERATOR
extension Stack: IteratorProtocol {
    mutating func next() -> Element? {
        elements.popLast()
    }
}
extension Stack: Sequence {
    func makeIterator() -> Stack<Element> {
        Stack(elements: elements)
    }
}
//: USAGE
var collectionOne = Stack<Int>(elements: [5, 2, 3, 1, 5, 4])
var collectionTwo = Stack<String>(elements: ["Swift", "Ruby", "C", "NASM"])
var collectionThree = Stack<Double>(elements: [2.2, 2.5, 2.7])

for element in collectionOne {
    print("Element: \(element)")
}

for element in collectionTwo {
    print(element.uppercased())
}

while !collectionThree.isEmpty {
    guard let next = collectionThree.next() else {
        break
    }
    print(next)
}
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
