//: [Introduction](@previous)

/*:
 Singleton design pattern
 ============
 
 > The Singleton pattern allows a class to have only one instance, which means that every reference to this class refers to the same instance.
 >
 > Singleton pattern has two parts, specifically the Singleton class and the Singleton instance.
 > * Singleton class contains the Singleton instance.
 >*  Singleton instance is the instance of the Singleton class in the Singleton class itself.
 
 ## When to use the Singleton pattern?
 Use this pattern when using more than one instance of a class will cause problems.
 For example, we don't need two or more instances of user settings created, so we use the Singleton pattern, as in the example below.
 
 ## Example below shows how the Singleton pattern works. Don't forget to open live view and launch playground to see the results and layout.
 */
import UIKit
import PlaygroundSupport
//: SINGLETON CLASS
final class Settings{
//: SINGLETON INSTANCE
    static let shared = Settings()
    var backgroundColor: UIColor = .white
    
    public init(){}
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
extension UIColor{
    static var random: UIColor {
        let red: CGFloat = .random(in: 0...1)
        let green: CGFloat = .random(in: 0...1)
        let blue: CGFloat = .random(in: 0...1)
        let alpha: CGFloat = .random(in: 0.5...1)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
PlaygroundPage.current.liveView = ViewController()
//: [Builder pattern](@next)
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
