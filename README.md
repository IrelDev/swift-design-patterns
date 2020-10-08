# Table of contents
|       Behavioral design patterns         |      Creational design patterns          |      Structural design patterns      |
|------------------------------------------|------------------------------------------|--------------------------------------|
|[Multicast delegate](#multicast-delegate) |[Builder](#builder)                      |[Flyweight](#flyweight)               |
|[State](#state)                           |[Prototype](#prototype)                  |[Composiste](#composite)              |
|[Memento](#memento)                       |[Singleton](#singleton)                  |[Adapter](#adapter)                   |
|[Delegate](#delegate)                     |[Factory](#factory)                      |[Facade](#facade)                     |
|[Strategy](#strategy)                     |                                         |[MVC](#mvc)                           |
|[Observer](#observer)                     |                                         |[MVVM](#mvvm)                         |
|[Iterator](#iterator)                     |                                         |[Decorator](#decorator)               |
|[Mediator](#mediator)
|[Command](#command)
|[Chain of responsibility](#chain-of-responsibility)

# Behavioral design patterns
Behavioral design patterns are about communication between objects.

## Multicast Delegate
The Multicast delegate pattern allows to create oneToMany relations, instead of oneToOne relation that's using in delegate pattern

### When to use the Multicast delegate pattern?
Use this pattern if you want to create oneToMany object relationships. For example, we can use this pattern to catch clipboard changes on one device and transfer it to another, as in the example below.

```swift
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
```

## State
The State pattern allows to change the behavior of an object at runtime.

### When to use the State pattern?
Use this pattern when your object has two and more states that can be changed during its lifetime. This pattern is very useful when you have to rewrite swift-case machines in a better way.

```swift
enum Song: String {
    case godzilla
    case madeByAmerica
    case prayForMe
    case none
}
class AudioSystem {
    private var state: AudioSystemState = TurnedOffState()
    private var isTurnedOn: Bool = false
    
    var isPlaying: Bool {
        get {
            state.isPlaying(audioSystem: self)
        }
    }
    var songName: Song {
        get {
            state.songName(audioSystem: self)
        }
    }
    func turnOff() {
        isTurnedOn = false
        state = TurnedOffState()
    }
    func turnOn() {
        isTurnedOn = true
        state = TurnedOnState()
    }
    func playMusic(with song: Song) {
        if isTurnedOn {
            state = PlayingState(song: song)
        } else {
            print("Cannot play music because AudioSystem is turned off.")
        }
    }
}
extension AudioSystem: CustomStringConvertible {
    var description: String {
        String(describing: "Turned on: \(isTurnedOn), is song playing \(isPlaying), song name is \(songName.rawValue)\n")
    }
}
protocol AudioSystemState: class {
    func isPlaying(audioSystem: AudioSystem) -> Bool
    
    func songName(audioSystem: AudioSystem) -> Song
}
class TurnedOffState: AudioSystemState {
    func isPlaying(audioSystem: AudioSystem) -> Bool { false }
    
    func songName(audioSystem: AudioSystem) -> Song { .none }
}

class TurnedOnState: AudioSystemState {
    func isPlaying(audioSystem: AudioSystem) -> Bool { false }
    func songName(audioSystem: AudioSystem) -> Song { .none }
}
class PlayingState: AudioSystemState {
    var song: Song
    
    init(song: Song) {
        self.song = song
    }
    func isPlaying(audioSystem: AudioSystem) -> Bool {
        guard song != Song.none else {
            return false
        }
        return true
    }
    func songName(audioSystem: AudioSystem) -> Song { song }
}
let audioSystem = AudioSystem()
print(audioSystem)

audioSystem.turnOn()
print(audioSystem)

audioSystem.playMusic(with: .godzilla)
print(audioSystem)

audioSystem.turnOff()
print(audioSystem)

audioSystem.playMusic(with: .madeByAmerica)
```

## Memento
Memento pattern provides the ability to save an object's state or restore an object to its previous state.

### When to use the Memento pattern?
Use this pattern when you want to create an ability to save and restore the state of an object. For example, you can use this pattern when you want to create a text editor, as in the example below.

```swift
import UIKit
import Foundation
import PlaygroundSupport
//: ORIGINATOR
class TextOriginator: Codable {
    var text: String
    init(text: String) {
        self.text = text
    }
}
//: CARETAKER
class TextCareTaker {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let userDefaults = UserDefaults.standard
    
    enum DecodableError: Error {
        case decodeFailed
    }
//: > We don't need to implement memento, because memento is a data that's created every time when textState encodes or decodes.
    func save(textState: TextOriginator, title: String) {
        let memento = try? encoder.encode(textState)
        userDefaults.set(memento, forKey: title)
    }
    func load(title: String) throws -> TextOriginator {
        guard let memento = userDefaults.data(forKey: title),
            let originator = try? decoder.decode(TextOriginator.self, from: memento)
            else {
                throw DecodableError.decodeFailed
        }
        return originator
    }
}
struct TextManager {
    static var states: [String] = []
    static var caretaker = TextCareTaker()
}
class ViewController: UIViewController {
    var textView: UITextView!
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupUI()
    }
//: USAGE
    @objc func performUndoButton() {
        if textView.text == TextManager.states.last {
            TextManager.states.popLast()
        }
        guard !TextManager.states.isEmpty else { return }
        let text = try? TextManager.caretaker.load(title: TextManager.states.popLast()!)
        textView.text = text?.text
        print("Saved states: \(TextManager.states)")
    }
    @objc func performSaveButton() {
        guard TextManager.states.last != textView.text else { return }
        
        let text = TextOriginator(text: textView.text)
        
        TextManager.caretaker.save(textState: text, title: text.text)
        TextManager.states.append(text.text)
        print("Saved states: \(TextManager.states)")
    }
}
//: UI
extension ViewController {
    func setupUI() {
        textView = UITextView(frame: CGRect(x: 0, y: 0, width: view.bounds.width - 20, height: view.bounds.height / 4))
        textView.center = view.center
//        textView.layer.cornerRadius = 10
        
        textView.backgroundColor = .systemPink
        
        let text = TextOriginator(text: "Initial State")
        
        TextManager.caretaker.save(textState: text, title: text.text)
        TextManager.states.append(text.text)
        
        textView.text = text.text
        
        view.addSubview(textView)
        
        let saveButton = setupButton(with: "Save")
        saveButton.addTarget(self, action: #selector(performSaveButton), for: .touchUpInside)
        
        let undoButton = setupButton(with: "Undo")
        undoButton.addTarget(self, action: #selector(performUndoButton), for: .touchUpInside)
        
        let stack = UIStackView()
        
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 20.0
        stack.alignment = .center
        
        stack.addArrangedSubview(saveButton)
        stack.addArrangedSubview(undoButton)

        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
    }
    func setupButton(with title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        
        button.setTitle(title, for: .normal)
        
        return button
    }
}
PlaygroundPage.current.liveView = ViewController()
```

## Delegate
Delegate pattern allows an object to use another object to provide data or perform a task instead of doing it yourself.

### When to use the Delegate pattern?
Use this pattern to break up objects or create reusable components.  Actually, delegation pattern is used in frameworks from Apple, especially in UIKit that will be used in this playground. For example, both UITableViewDelegate and UITableViewDataSource use delegate pattern.

```swift
import UIKit
import PlaygroundSupport
//: DELEGATE PROTOCOL
protocol ColorDelegate: class{
    func changeBackgroundColorWhenTapped(_ viewController: UIViewController, with color: UIColor)
}
class ViewController: UIViewController {
    var table = UITableView()
    //: VC BECOMES DELEGATION OBJECT
    weak var colorDelegate: ColorDelegate?
    
    override func viewDidLoad() {
        setupView()
        setupTableView()
    }
    func setupView() {
        view.backgroundColor = .systemPink
        let titleLabel = UILabel()
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        
        titleLabel.text = "Tap on tableView cell"
        titleLabel.textColor = .gray
    }
    func setupTableView() {
        view.addSubview(table)
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        table.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        table.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}
//: TABLEVIEW DATASOURCE DELEGATE
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let label = UILabel()
        cell.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: cell.topAnchor, constant: 20).isActive = true
        
        label.text = "I'm label on \(indexPath.row) line"
        
        return cell
    }
}
//: TABLEVIEW DELEGATE
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let color: UIColor = view.backgroundColor == .black ? .white: .black
        
        colorDelegate = self
        colorDelegate?.changeBackgroundColorWhenTapped(self, with: color)
    }
}
//: VC BECOMES DELEGATE OBJECT
extension ViewController: ColorDelegate {
    func changeBackgroundColorWhenTapped(_ viewController: UIViewController, with color: UIColor) {
        viewController.view.backgroundColor = color
    }
}
PlaygroundPage.current.liveView = ViewController()
```

## Strategy
Strategy pattern defines a family of interchangeable objects and allows you to set or select these objects at runtime.

### When to use the Strategy pattern?
Use this pattern when you need to implement two or more ways to do one thing or use this like an alternative to if/else & switch blocks. For example, you can use this pattern when you want to implement two types of quicksort, as in example below.

```swift
import UIKit
import PlaygroundSupport
//: STRATEGY PROTOCOL
protocol QuicksortStrategy{
    func quicksorted<Element>(_ array: inout [Element], lowestIndex: Int, highestIndex: Int) where Element: Comparable
    
    func partition<Element>(_ array: inout [Element], lowestIndex: Int, highestIndex: Int) -> Int where Element: Comparable
}
//: STRATEGIES
struct HoareQuicksortStrategy: QuicksortStrategy{
    func quicksorted<Element>(_ array: inout [Element], lowestIndex: Int, highestIndex: Int) where Element: Comparable {
        if lowestIndex < highestIndex {
            let pivotPoint = partition(&array, lowestIndex: lowestIndex, highestIndex: highestIndex)
            quicksorted(&array, lowestIndex: lowestIndex, highestIndex: pivotPoint)
            quicksorted(&array, lowestIndex: pivotPoint + 1, highestIndex: highestIndex)
        }
    }
    func partition<Element>(_ array: inout [Element], lowestIndex: Int, highestIndex: Int) -> Int where Element: Comparable {
        let pivotPoint = array[lowestIndex]
        var startIndex = lowestIndex - 1
        var endIndex = highestIndex + 1
        
        while true {
            repeat { endIndex -= 1 } while array[endIndex] > pivotPoint
            repeat { startIndex += 1 } while array[startIndex] < pivotPoint
            
            if startIndex < endIndex {
                array.swapAt(startIndex, endIndex)
            } else {
                return endIndex
            }
        }
    }
}
struct LomutoQuicksortStrategy: QuicksortStrategy{
    func quicksorted<Element>(_ array: inout [Element], lowestIndex: Int, highestIndex: Int) where Element: Comparable {
        if lowestIndex < highestIndex {
            let pivotPoint = partition(&array, lowestIndex: lowestIndex, highestIndex: highestIndex)
            quicksorted(&array, lowestIndex: lowestIndex, highestIndex: pivotPoint - 1)
            quicksorted(&array, lowestIndex: pivotPoint + 1, highestIndex: highestIndex)
        }
    }
    func partition<Element>(_ array: inout [Element], lowestIndex: Int, highestIndex: Int) -> Int where Element: Comparable {
        let pivotPoint = array[highestIndex]
        
        var startIndex = lowestIndex
        
        for index in lowestIndex..<highestIndex {
            if array[index] <= pivotPoint {
                array.swapAt(startIndex, index)
                startIndex += 1
            }
        }
        array.swapAt(startIndex, highestIndex)
        return startIndex
    }
}
//: OBJECT USING A STRATEGY
class ViewController: UIViewController {
    var quicksortStrategy: QuicksortStrategy!
    
    var resultLabel: UILabel!
    override func viewDidLoad() {
        setupView()
    }
//: STRATEGY USAGE
    @objc func hoareExecution() {
        quicksorted(with: HoareQuicksortStrategy())
    }
    @objc func lomutoExecution() {
        quicksorted(with: LomutoQuicksortStrategy())
    }
    func quicksorted(with strategy: QuicksortStrategy) {
        var array = (0...3).map({_ in Int.random(in: 0...10)})
        
        quicksortStrategy = strategy
        quicksortStrategy?.quicksorted(&array, lowestIndex: 0, highestIndex: 3)
        
        resultLabel.text = "Quicksorted array: \(array)"
    }
}
//: UI
extension ViewController {
    func setupView() {
        view.backgroundColor = .white
        
        createStack(with: createHoareButton(), and: createLomutoButton())
        
        setupResultLabel()
    }
    func createHoareButton() -> UIButton {
        let executeWithHoareButton = setupButton(with: "Execute with Hoare")
        
        executeWithHoareButton.addTarget(self, action: #selector(hoareExecution), for: .touchUpInside)
        return executeWithHoareButton
    }
    func createLomutoButton() -> UIButton {
        let executeWithLomutoButton = setupButton(with: "Execute with Lomuto")
        
        executeWithLomutoButton.addTarget(self, action: #selector(lomutoExecution), for: .touchUpInside)
        return executeWithLomutoButton
    }
    func setupButton(with title: String) -> UIButton {
          let button = UIButton()
          button.backgroundColor = .systemPink
          button.clipsToBounds = true
          button.layer.cornerRadius = 10
          
          button.setTitle(title, for: .normal)
          
          return button
      }
    func createStack(with first: UIButton, and second: UIButton) {
        let stack = UIStackView()
        
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 20.0
        
        stack.addArrangedSubview(first)
        stack.addArrangedSubview(second)
        stack.alignment = .center
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    func setupResultLabel() {
        resultLabel = UILabel()
        resultLabel.text = "Waiting for result..."
        view.addSubview(resultLabel)
        
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
    }
}
PlaygroundPage.current.liveView = ViewController()
```

## Observer
The Observer pattern allows one object to observe changes on another object, usually in an event-based relationship model.

### When to use the Observer pattern?
Use this pattern when you want one object to catch changes of another object. For example, you can use this pattern when you want to receive updates on your mom's birthday, as in the example below.

```swift
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
```

## Iterator
The Iterator pattern allows to iterate through a collection.

### When to use the Iterator pattern?
Use this pattern when you want to iterate through a custom type using standart tools like for _ in, forEach and etc. For example, you can use this pattern when you want to iterate over a Stack data structure, as in the example below.

```swift
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
```

## Mediator
The Mediator pattern allows to encapsulate the interaction of objects between each other. The Mediator pattern is very similar to the multicast delegate pattern but it have a few differences.

```swift
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
```

## Command
The Command pattern allows you to turn "commands" into objects that allow you to pass them as arguments. In addition, these commands can be canceled or queued.

```swift
class Receiver {
    var audioSystemIsTurnedOn = false
    var musicIsPlaying = false
}
class AbstractAudioCommand {
    public let receiver: Receiver
    init(receiver: Receiver) {
        self.receiver = receiver
    }
    func execute() { }
}
class TurnOnCommand: AbstractAudioCommand {
    override func execute() {
        guard !receiver.audioSystemIsTurnedOn else {
            print("Audio system is already on")
            return
        }
        print("Got command... Audio System is turned on")
        receiver.audioSystemIsTurnedOn = true
    }
}
class TurnOffCommand: AbstractAudioCommand {
    override func execute() {
        guard receiver.audioSystemIsTurnedOn else {
            print("Audio system is already off")
            return
        }
        if receiver.musicIsPlaying {
            print("Music is turning off..")
            receiver.musicIsPlaying = false
        }
        print("Got command... Audio System is turned off")
        receiver.audioSystemIsTurnedOn = false
    }
}
class PlayMusicCommand: AbstractAudioCommand {
    override func execute() {
        guard receiver.audioSystemIsTurnedOn else {
            print("Audio system is turned off, music cannot be played")
            return
        }
        print("Got command... Audio System is playing music")
        receiver.musicIsPlaying = true
    }
}
class StopMusicCommand: AbstractAudioCommand {
    override func execute() {
        guard receiver.audioSystemIsTurnedOn else {
            print("Audio system is turned off, music cannot be played")
            return
        }
        guard !receiver.musicIsPlaying else {
            print("Audio System is already playing music")
            return
        }
        print("Got command... Audio System is not playing music now")
    }
}
class Invoker {
    var listOfCommands: [AbstractAudioCommand]
    let receiver: Receiver
    
    init(receiver: Receiver, listOfCommands: [AbstractAudioCommand] = []) {
        self.receiver = receiver
        self.listOfCommands = listOfCommands
    }
    func addCommand(command: AbstractAudioCommand) {
        listOfCommands.append(command)
    }
    func removeCommandAtIndex(index: Int) -> Bool {
        guard listOfCommands.indices.contains(index) else {
            return false
        }
        listOfCommands.remove(at: index)
        return true
    }
    func performListOfCommands() {
        listOfCommands.forEach({
            $0.execute()
        })
    }
}
let audioSystem = Receiver()
let invoker = Invoker(receiver: audioSystem)

invoker.addCommand(command: TurnOnCommand(receiver: audioSystem))
invoker.addCommand(command: PlayMusicCommand(receiver: audioSystem))
invoker.addCommand(command: TurnOffCommand(receiver: audioSystem))

invoker.performListOfCommands()
```

## Chain of responsibility
The Chain of responsibility pattern allows to pass a request through a chain of handlers until one of them can process the request.

```swift
enum Direction {
    case LA
    case NYC
    case VANCOUVER
    case DUBAI
}
struct Request {
    var direction: Direction
    var name: String
    var age: Int
    var id: Int
}
protocol Handler: class {
    var nextHandler: Handler? { get set }
    func handleRequest(request: Request) -> Bool?
    func next(handler: Handler) -> Handler
}
extension Handler {
    func next(handler: Handler) -> Handler {
        nextHandler = handler
        return handler
    }
    func handleRequest(request: Request) -> Bool? {
        nextHandler?.handleRequest(request: request)
    }
}
class LAHandler: Handler {
    var nextHandler: Handler?
    func handleRequest(request: Request) -> Bool? {
        guard request.direction == .LA else {
            return nextHandler?.handleRequest(request: request)
        }
        print("request number \(request.id) was approved in LA department")
        return true
    }
}
class NYCHandler: Handler {
    var nextHandler: Handler?
    
    func handleRequest(request: Request) -> Bool? {
        guard request.direction == .NYC else {
            return nextHandler?.handleRequest(request: request)
        }
        print("request number \(request.id) was approved in NYC department")
        return true
    }
}
class VANCOUVERHandler: Handler {
    var nextHandler: Handler?
    
    func handleRequest(request: Request) -> Bool? {
        guard request.direction == .VANCOUVER else {
            return nextHandler?.handleRequest(request: request)
        }
        print("request number \(request.id) was approved in VANCOUVER department")
        return true
    }
}
class Client {
    var handler: Handler

    var requests: [Request]
    
    init(handler: Handler, requests: [Request] = []) {
        self.handler = handler
        self.requests = requests
    }
    func requestApprover() {
        requests.forEach({
            print("Checking request with id \($0.id)")
            guard (handler.handleRequest(request: $0)) != nil else {
                print("Cannot approve the request.")
                print("Request declined. \n")
                return
            }
            print("Request approved. \n")
        })
    }
    func addRequest(request: Request) {
        requests.append(request)
    }
}
//: USAGE
let requestOne = Request(direction: .NYC, name: "Anna", age: 15, id: 0)
let requestTwo = Request(direction: .LA, name: "Joghn", age: 26, id: 1)
let requestThree = Request(direction: .VANCOUVER, name: "Anthony", age: 53, id: 2)
let requesstFour = Request(direction: .DUBAI, name: "Khalib", age: 46, id: 3)

let laHandler = LAHandler()
let nycHandler = NYCHandler()
let vancouverHandler = VANCOUVERHandler()

laHandler.next(handler: nycHandler).next(handler: vancouverHandler) //protocol default implementation

let requests = [requestOne, requestTwo, requestThree, requesstFour]
let client = Client(handler: laHandler, requests: requests)

client.requestApprover()
```

# Creational design patterns
Creational design patterns are about creating new objects or groups of objects.

## Builder
The Builder pattern allows creating complex objects step by step without creating a massive initializer or creating multiple subclasses of an object.

### When to use the Builder pattern?
Use this pattern when you want to create a complex object step-by-step For example, we can use this pattern to create a car, as in the example below.

```swift
import PlaygroundSupport
import UIKit

enum Material: String {
    case iron
    case platinum
    case gold
    case chrome
}
enum Complectation: String {
    case econom
    case standart
    case business
    case pro
}
enum AdditionalComponents: String {
    case audioSystem
    case seatHeating
}
//: PRODUCT
struct Car {
    let material: Material
    let doorsAmount: Int
    let complectation: Complectation
    let additionalComponents: [AdditionalComponents]
    let carLength: Double
    
    init(material: Material, doorsAmount: Int,
         complectation: Complectation,
         additionalComponents: [AdditionalComponents]) {
        
        self.doorsAmount = doorsAmount
        self.complectation = complectation
        self.material = material
        self.additionalComponents = additionalComponents
        
        self.carLength = Double(doorsAmount / 2) * 0.45
    }
}
extension Car: CustomStringConvertible {
    public var description: String {
        String("The car made with \(material.rawValue), it has \(doorsAmount) doors, it comes with \(complectation.rawValue) complectation, it has \(additionalComponents.count) additionalComponents and it has \(carLength) length in meters.\n")
    }
}
//: BUILDER
class CarBuilder {
    private var material = Material.iron
    private var doorsAmount = 2
    private var complectation = Complectation.standart
    
    private var additionalComponents = [AdditionalComponents]()
    
    func setMaterial(material: Material) {
        self.material = material
    }
    func increaseDoorsAmountOnTwo(for times: Int = 1) {
        for _ in 0..<times {
            doorsAmount += 2
        }
    }
    func decreaseDoorsAmountOnTwo(for times: Int = 1) {
        guard doorsAmount - 2 * times >= 2 else {
            print("Doors amount cannot be less than two")
            return
        }
        for _ in 0..<times {
            doorsAmount -= 2
            print(doorsAmount)
        }
    }
    func setComplectation(complectation: Complectation) {
        self.complectation = complectation
    }
    func addComponent(component: AdditionalComponents) {
        guard additionalComponents.contains(where: {
            $0 == component
        }) == false else { return }
        additionalComponents.append(component)
    }
    func removeComponent(component: AdditionalComponents) {
        guard let index = additionalComponents.firstIndex(where: {
            $0 == component
        }) else { return }
        additionalComponents.remove(at: index)
    }
    func removeAllComponents() {
        additionalComponents.removeAll()
    }
    func buildProduct() -> Car {
        Car(material: material, doorsAmount: doorsAmount, complectation: complectation, additionalComponents: additionalComponents)
    }
}
//: DIRECTOR
class Director {
    static func createEconomClassCar() -> Car {
        let builder = CarBuilder()
        builder.setComplectation(complectation: .econom)
        
        return builder.buildProduct()
    }
    static func createUltraSuperProClassCar() -> Car {
        let builder = CarBuilder()
        
        builder.increaseDoorsAmountOnTwo(for: 10)
        builder.setMaterial(material: .platinum)
        builder.setComplectation(complectation: .pro)
        
        builder.addComponent(component: .audioSystem)
        builder.addComponent(component: .seatHeating)
        
        return builder.buildProduct()
    }
    static func createStandartClassCar() -> Car {
        let builder = CarBuilder()
        
        builder.increaseDoorsAmountOnTwo()
        builder.addComponent(component: .audioSystem)
        
        return builder.buildProduct()
    }
}
struct Human {
    var car: Car?
    init() { }
}
//: USAGE
class ViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupUI()
    }
    @objc func performEconomCarCreationProcess() {
        var human = Human()
        human.car = Director.createEconomClassCar()
        
        guard let car = human.car else { return }
        print(car)
    }
    @objc func performStandartCarCreationProcess() {
        var human = Human()
        human.car = Director.createStandartClassCar()
        
        guard let car = human.car else { return }
        print(car)
    }
    @objc func performProCarCreationProcess() {
        var human = Human()
        human.car = Director.createUltraSuperProClassCar()
        
        guard let car = human.car else { return }
        print(car)
    }
    @objc func performNilCarCreationProcces() {
        let human = Human()
        
        guard human.car != nil else { print("That human has no car :( \n"); return }
    }
}
//: UI
extension ViewController {
    func setupUI() {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 20.0
        stack.alignment = .center
        
        let economButton = createButtonWith(title: "Econom")
        economButton.addTarget(self, action: #selector(performEconomCarCreationProcess), for: .touchUpInside)
        
        let standartButton: UIButton = createButtonWith(title: "Standart")
        standartButton.addTarget(self, action: #selector(performStandartCarCreationProcess), for: .touchUpInside)
        
        let proButton: UIButton = createButtonWith(title: "PRO")
        proButton.addTarget(self, action: #selector(performProCarCreationProcess), for: .touchUpInside)
        
        let nilCarButton: UIButton = createButtonWith(title: "Nil")
        nilCarButton.addTarget(self, action: #selector(performNilCarCreationProcces), for: .touchUpInside)
        
        stack.addArrangedSubview(economButton)
        stack.addArrangedSubview(standartButton)
        stack.addArrangedSubview(proButton)
        stack.addArrangedSubview(nilCarButton)
        
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
    }
    func createButtonWith(title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        
        button.setTitle(title, for: .normal)
        
        return button
    }
}
PlaygroundPage.current.liveView = ViewController()
```

## Prototype
The Prototype pattern allows to simply copy & clone objects.

### When to use the Prototype pattern?
Use this pattern when you want to create an object with ability to copy itself. Swift foundation library has a default implementation of NSCopying protocol but we can write our own implementation. For example, we can use this pattern to copy a recipe, as in the example below.

```swift
import Foundation

class Recipe: NSCopying {
    var name: String
    private var ingredients: [String]
    
    init(name: String,
         ingredients: [String]) {
        self.name = name
        self.ingredients = ingredients
    }
    func addIngredient(ingredient: String) {
        guard ingredients.contains(where: {
            $0 == ingredient
        }) == false else { return }
        ingredients.append(ingredient)
    }
    func removeIngredient(ingredient: String) {
        guard let index = ingredients.firstIndex(where: {
            $0 == ingredient
        }) else { return }
        ingredients.remove(at: index)
    }
    
    //: NSCopying
    func copy(with zone: NSZone? = nil) -> Any {
        Recipe.init(name: name, ingredients: ingredients)
    }
}
extension Recipe: CustomStringConvertible {
    var description: String {
        String(describing: "Ingridients in \(name) recipe: \(ingredients)")
    }
}
//: FOUNDATION EXAMPLE
let eggsAndBaconRecipe = Recipe(name: "Eggs with bacon", ingredients: ["Eggs", "Bacon"])
print(eggsAndBaconRecipe)

let eggsAndBaconInAvocado = eggsAndBaconRecipe.copy() as! Recipe
print(eggsAndBaconInAvocado)

eggsAndBaconInAvocado.name = "Eggs with bacon in avocado"
eggsAndBaconInAvocado.addIngredient(ingredient: "Avocado")

print(eggsAndBaconInAvocado)
```

## Singleton
The Singleton pattern allows a class to have only one instance, which means that every reference to this class refers to the same instance.

### When to use the Singleton pattern?
Use this pattern when using more than one instance of a class will cause problems. For example, we don't need two or more instances of user settings created, so we use the Singleton pattern, as in the example below.

```swift
import UIKit
import PlaygroundSupport
//: SINGLETON CLASS
final class Settings {
//: SINGLETON INSTANCE
    static let shared = Settings()
    var backgroundColor: UIColor = .white
    
    public init() {}
}
class ViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupRandomBackgroundColorButton()
    }
//: SINGLETON USAGE
    @objc func setColorInSettings() {
        Settings.shared.backgroundColor = .random
        setBackgroundColorFromSettings()
    }
    func setBackgroundColorFromSettings() {
        view.backgroundColor = Settings.shared.backgroundColor
    }
}
//: UI
extension ViewController {
    func setupRandomBackgroundColorButton() {
           let button = UIButton(frame: CGRect.zero)
           
           button.backgroundColor = .systemPink
           button.clipsToBounds = true
           button.layer.cornerRadius = 10
           button.tintColor = .white
           button.setTitle("Set randomBackgroundColor", for: .normal)
           button.addTarget(self, action: #selector(setColorInSettings), for: .touchUpInside)
           
           view.addSubview(button)
           
           button.translatesAutoresizingMaskIntoConstraints = false
           button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       }
}
extension UIColor {
    static var random: UIColor {
        let red: CGFloat = .random(in: 0...1)
        let green: CGFloat = .random(in: 0...1)
        let blue: CGFloat = .random(in: 0...1)
        let alpha: CGFloat = .random(in: 0.5...1)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
PlaygroundPage.current.liveView = ViewController()
```

## Factory
The Factory pattern allows to simply create objects using only one step and it allows to change a type of a object at runtime. The Factory pattern is used to replace object initializers, hiding an object creation process.

### When to use the Factory pattern?
Use this pattern when you want to create a simple object using only one step and it's useful when we have a lot of different objects as in example below.

```swift
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
```

# Structural design patterns
Structural design patterns are responsible for building easy-to-maintain hierarchies to form larger structures.

## Flyweight
The Flyweight pattern allows an object to represents itself as a unique instance but it's not. That allows to use less memory.

### When to use the Flyweight pattern?
Use this pattern when you'd use singleton pattern but you need multiple instances with different configurations.

```swift
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
```

## Composite
The Composite pattern allows you to represent a group of objects as a single tree-structured object.

### When to use the Composite pattern?
Using this pattern makes sense if you want to create an object that should be structured as a tree.

```swift
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
```

## Adapter
The Adapter pattern allows one type to work with other incompatible type.

### When to use the Adapter pattern?
Use this pattern when you want to change the interface of an object but can't change it. You can choose this pattern to implement your own interface for third-party libraries and platforms.

```swift
//: LEGACY OBJECT
struct USAPowerSocket {
    func makeConnectionWithTwoFlatPlugs() -> String {
        return "Connection Established"
    }
}

protocol USAPowerAdapter {
    var adaptee: USAPowerSocket { get set }
    func makeConnection() -> String
}
struct EUAdapter: USAPowerAdapter {
    var adaptee: USAPowerSocket
    
    func makeConnection() -> String {
        return adaptee.makeConnectionWithTwoFlatPlugs() + " through EU Adapter"
    }
}
let usaPowerSocket = USAPowerSocket()
print(usaPowerSocket.makeConnectionWithTwoFlatPlugs())

let adapter = EUAdapter(adaptee: usaPowerSocket)
print(adapter.makeConnection())
```

## Facade
The Facade pattern allows to simply interact with complex systems.

### When to use the Facade pattern?
Use this pattern when you have a complex system with multiple components and you want to implement an easier way to perform an action.

```swift
enum Direction: Int {
    case LA
    case NYC
}
class Airplane {
    let seats: Int
    var tickets: [Ticket]
    var id: Int
    var cost: Int
    
    init(seats: Int, id: Int, tickets: [Ticket], cost: Int) {
        self.seats = seats
        self.id = id
        self.cost = cost
        guard tickets.count <= seats else {
            self.tickets = []
            return
        }
        self.tickets = tickets
    }
}
struct Customer: Hashable {
    var name: String
    let id: Int
}
struct Ticket {
    var customer: Customer
    var seat: Int
}
extension Ticket: CustomStringConvertible {
    var description: String {
        String(describing: "seat number \(seat) belongs to customer \(customer.name) with id \(customer.id)")
    }
}
struct AirplaneStorage {
    var airplanes: [Airplane]
}
struct Facade {
    let storage: AirplaneStorage
    func buyTicket(on direction: Direction, for customer: Customer) {
        
        guard let index = storage.airplanes.firstIndex(where: {
            $0.id == direction.rawValue
        }) else { return }
        let airplane = storage.airplanes[index]
        
        let seat = airplane.tickets.count
        guard seat <= airplane.seats else {
            print("All seats were purchased")
            return
        }
        
        let ticket = Ticket(customer: customer, seat: seat)
        airplane.tickets.append(ticket)
        print("Ticket was succesefully bought! \n\(ticket)\n")
    }
}
var airplaneToLA = Airplane(seats: 43, id: 0, tickets: [], cost: 150)
var airpaneToNYC = Airplane(seats: 56, id: 1, tickets: [], cost: 340)

var storage = AirplaneStorage(airplanes: [airplaneToLA, airpaneToNYC])

let customerOne = Customer(name: "Alex", id: 0)
let customerrTwo = Customer(name: "Kate", id: 1)

var facade = Facade(storage: storage)

facade.buyTicket(on: .LA, for: customerOne)
facade.buyTicket(on: .LA, for: customerrTwo)
```
## Decorator
The decorator pattern is a design pattern that allows behavior to be added to an individual object, dynamically, without affecting the behavior of other objects from the same class.
 Example below shows how the Decorator pattern works. Don't forget to launch playground to see the results.
```swift
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
```

## MVC
The MVC design pattern separates objects into three types, specifically Model, View and Controller.

### When to use the MVC pattern
This pattern is more of a starting point for creating swift & objc applications, but in the future you will probably use additional patterns besides MVC even in single project. Actually, MVC is not the best choice, because it is massive and developers mostly call it MassiveViewController.

```swift
import UIKit
import PlaygroundSupport
//: MODEL
public struct NewspaperPublication: Decodable {
    var publicationAuthor: String
    var publicationTitle: String
    var publicationDescription: String?
    var publishedAt: Date
}
extension NewspaperPublication: CustomStringConvertible {
    public var description: String {
        String(describing: "Author: \(publicationAuthor)\nTitle: \(publicationTitle)\nDescription: \(publicationDescription!)\nPublished at: \(publishedAt)")
    }
}
//: VIEW
public class NewspaperPublicationView: UIView {
    public var authorLabel: UILabel!
    public var titleLabel: UILabel!
    public var descriptionLabel: UILabel!
    public var publishedAtLabel: UILabel!
}
//: CONTROLLER
public class NewspaperViewController: UIViewController {
    public var publication: NewspaperPublication?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromJSON()
    }
    private func updateViewFromJSON() {
        publication = dataFromJSON()
        print(publication!)
        
        view.backgroundColor = .white
        
        let newspaperPublicationView = NewspaperPublicationView()
        
        newspaperPublicationView.titleLabel = UILabel()
        view.addSubview(newspaperPublicationView.titleLabel)
        
        newspaperPublicationView.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        newspaperPublicationView.titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newspaperPublicationView.titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        newspaperPublicationView.titleLabel.text = publication?.publicationTitle
        
        newspaperPublicationView.authorLabel = UILabel()
        view.addSubview(newspaperPublicationView.authorLabel)
        
        newspaperPublicationView.authorLabel.translatesAutoresizingMaskIntoConstraints = false
        newspaperPublicationView.authorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newspaperPublicationView.authorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        newspaperPublicationView.authorLabel.text = publication?.publicationAuthor
        
        
        newspaperPublicationView.descriptionLabel = UILabel()
        view.addSubview(newspaperPublicationView.descriptionLabel)
        
        newspaperPublicationView.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        newspaperPublicationView.descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newspaperPublicationView.descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        newspaperPublicationView.descriptionLabel.text = publication?.publicationDescription
        
        let dateFormatter: DateFormatter = {
            let dt = DateFormatter()
            dt.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dt
        }()
        
        newspaperPublicationView.publishedAtLabel = UILabel()
        view.addSubview(newspaperPublicationView.publishedAtLabel)
        
        newspaperPublicationView.publishedAtLabel.translatesAutoresizingMaskIntoConstraints = false
        newspaperPublicationView.publishedAtLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newspaperPublicationView.publishedAtLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150).isActive = true
        newspaperPublicationView.publishedAtLabel.text = dateFormatter.string(from: publication!.publishedAt)
    }
    private func dataFromJSON() -> NewspaperPublication {
        let jsonAnswer = """
          {
            "publicationAuthor": "Kirill Pustovalov",
            "publicationTitle": "What's MVC?",
            "publicationDescription": "Model View Controller design pattern",
            "publishedAt": "2020-01-19T11:57:35Z"
          }
        """
        let data = jsonAnswer.data(using: .utf8)
        
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decodedData = try! decoder.decode(NewspaperPublication.self, from: data!)
        return decodedData
    }
}
PlaygroundPage.current.liveView = NewspaperViewController()
```

## MVVM
The MVVM design pattern separates objects into three types, specifically Model, View and ViewModel.

### When to use the MVVM pattern?
You should use this pattern when you need to convert your model to the view model. For example, i'll use this pattern to display human data as shown below.

Note that when you are creating a real project, you are able to separate Model, ViewModel and View into different files to make it clean.

```swift
import UIKit
import PlaygroundSupport

enum Sex: String {
    case male
    case female
}
//: MODEL
struct HumanModel {
    let sex: Sex
    
    let name: String
    let lastName: String
    
    init(name: String, lastName: String, sex: Sex) {
        self.name = name
        self.lastName = lastName
        self.sex = sex
    }
}
extension HumanModel: CustomStringConvertible {
    public var description: String {
        String(describing: "Human has \(sex.rawValue) sex, his(her) name is \(name) and the last name is \(lastName)")
    }
}
//: VIEWMODEL
struct ViewModel {
    private let human: HumanModel
    
    init (human: HumanModel) {
        self.human = human
    }
    var sex: String {
        human.sex.rawValue
    }
    var name: String {
        human.name
    }
    var lastName: String {
        human.lastName
    }
}
//: VIEW
class View: UIView {
    let nameLabel: UILabel
    let lastNameLabel: UILabel
    let sexLabel: UILabel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        nameLabel = UILabel()
        lastNameLabel = UILabel()
        sexLabel = UILabel()
        
        let labelStack = UIStackView(frame: frame)
        
        labelStack.axis = .vertical
        labelStack.distribution = .fillEqually
        labelStack.alignment = .center
        labelStack.spacing = 10
        
        labelStack.addArrangedSubview(nameLabel)
         labelStack.addArrangedSubview(lastNameLabel)
         labelStack.addArrangedSubview(sexLabel)
        super.init(frame: frame)
        addSubview(labelStack)
        backgroundColor = .white
    }
}
//: USAGE
let human = HumanModel(name: "Kirill", lastName: "Pustovalov", sex: .male)
let viewModel = ViewModel(human: human)

let frame = CGRect(x: 0, y: 0, width: 600, height: 600)
let view = View(frame: frame)

view.nameLabel.text = viewModel.name
view.lastNameLabel.text = viewModel.lastName
view.sexLabel.text = viewModel.sex

//: VC USAGE
class ViewController: UIViewController {
    override func viewDidLoad() {
        let human = HumanModel(name: "Kirill", lastName: "Pustovalov", sex: .male)
        let viewModel = ViewModel(human: human)
        
        let frame = CGRect(x: 0, y: 0, width: 600, height: 600)
        
        let customView = View(frame: frame)
        view.addSubview(customView)
        
        customView.nameLabel.text = viewModel.name
        customView.lastNameLabel.text = viewModel.lastName
        customView.sexLabel.text = viewModel.sex
    }
}
PlaygroundPage.current.liveView = view // .liveView = ViewController(), same result.
```
