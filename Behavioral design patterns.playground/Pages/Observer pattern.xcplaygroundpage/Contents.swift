//: [Memento pattern](@previous)
/*:
 Observer design pattern
 ============
 
 > The Observer pattern allows one object to observe changes on another object, usually in an event-based relationship model.
 >
 > The Observer pattern has two parts, specifically the subscriber and the publisher.
 > * Publisher is the observable object that sends updates.
 > * Subscriber is the observer object that receives updates.
 
 ## When to use the Observer pattern?
 Use this pattern when you want one object to catch changes of another object.
 For example, you can use this pattern when you want to receive updates on your mom's birthday, as in the example below.
 > The Observer pattern can be implemented with @Published variable & combine framework that was added in Swift 5.1
 
 ## Example below shows how the Observer pattern works. Don't forget to open live view and launch playground to see the results and layout.
 */
import UIKit
import PlaygroundSupport

protocol PublisherProtocol {
    var subscribers: [Subscriber] { get set }
    
    func addSubscriber(_ subscriber: Subscriber)
    func removeSubscriber(_ subscriber: Subscriber)
    func notifyAllSubscribers(_ subscribers: [Subscriber])
    func notifyConcreteSubscriber(_ subscriber: Subscriber)
}
protocol SubscriberProtocol {
    var name: String { get set }
    
    func ageChanged(_ age: Int)
}

class Publisher: PublisherProtocol {
    var subscribers: [Subscriber] = []
    
    var age: Int {
        didSet {
            notifyAllSubscribers(subscribers)
        }
    }
    func ageIncreased(on years: Int = 1) {
        age += years
    }
    init(age: Int) {
        self.age = age
    }
    func addSubscriber(_ subscriber: Subscriber) {
        guard subscribers.contains(where: {
            $0 == subscriber
        }) == false else { return }
        subscribers.append(subscriber)
    }
    func removeSubscriber(_ subscriber: Subscriber) {
        guard let index = subscribers.firstIndex(where: {
            $0 == subscriber
        }) else { return }
        subscribers.remove(at: index)
    }
    func notifyAllSubscribers(_ subscribers: [Subscriber]) {
        subscribers.forEach({
            notifyConcreteSubscriber($0)
        })
    }
    func notifyConcreteSubscriber(_ subscriber: Subscriber) {
        subscriber.ageChanged(age)
    }
}
class Subscriber: SubscriberProtocol {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    static func == (lhs: Subscriber, rhs: Subscriber) -> Bool {
        lhs.name == rhs.name
    }
    func ageChanged(_ age: Int) {
        print("(Observer) \(name)'s mother's age is \(age) now")
    }
}
struct Family {
    static var mother = Publisher(age: 25)
    static var father = Subscriber(name: "Anthony")
}
class ViewController: UIViewController {
    var observerLabel: UILabel!
//: USAGE
    override func viewDidLoad() {
        setupUI()
        
        Family.mother.addSubscriber(Family.father)
        
    }
    @objc func increaseAge() {
        Family.mother.ageIncreased()
        observerLabel.text = "Mom's age is \(Family.mother.age)"
    }
}
//: UI
extension ViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        setupLabel()
        
        let button = setupButton(with: "Increase mother's age")
        
        button.addTarget(self, action: #selector(increaseAge), for: .touchUpInside)
        
        view.addSubview(button)
    }
    func setupLabel() {
        observerLabel = UILabel()
        observerLabel.text = "Press the button..."
        view.addSubview(observerLabel)
        
        observerLabel.translatesAutoresizingMaskIntoConstraints = false
        observerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        observerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
    }
    func setupButton(with title: String) -> UIButton {
        let button = UIButton(frame: CGRect(x: view.center.x - 100, y: view.center.y, width: 200, height: 50))
        button.backgroundColor = .systemPink
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        
        button.setTitle(title, for: .normal)
        
        return button
    }
}
PlaygroundPage.current.liveView = ViewController()

//:  implementation with @Published variable & combine framework that was added in Swift 5.1
import Combine
print("@Published variable based implementation\n")

public class Mother {
    @Published var age: Int
    
    init(age: Int) {
        self.age = age
    }
}
var mother = Mother(age: 55)
let publisher = mother.$age

var fatherSubscriber = publisher.sink() {
    print("(Combine framework) mother's age is \($0) now\n")
}
mother.age += 1 //56

fatherSubscriber.cancel() //Subscriber cannot get updates now

mother.age += 1
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


