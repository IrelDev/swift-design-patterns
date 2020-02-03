//: [Strategy pattern](@previous)
/*:
 Memento design pattern
 ============
 
 > Memento pattern provides the ability to save an object's state or restore an object to its previous state.
 >
 > Memento pattern has three parts, specifically originator, memento and caretaker.
 > * Originator is an object that will be saved or restored.
 > * Memento represents the state of an object.
 > * Caretaker requests a memento object from the originator then configures memento and returns memento to the originator.
 
 ## When to use Memento?
 Use this pattern when you want to create an ability to save and restore the state of an object.
 For example, you can use this pattern when you want to create a text editor, as in the example below.
 > Memento pattern can be implemented in many ways and I use userDefaults to easily do save and load operations, as it should be in iOS development.
 > If you don't want to use userDefaults you still have an ability to save and restore mementos from any data structure.
 
 ## Example below shows how Memento works. Don't forget to open live view and launch playground to see results and layout.
 */
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
//: [Observer pattern](@next)
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

