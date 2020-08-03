//: [MVP pattern](@previous)

/*:
 The MVVM design pattern
 ============
 
 > The MVVM design pattern separates objects into three types, specifically Model, View and ViewModel.
 >
 > * Model is intended to store data in structures or classes (usually structures).
 > * View is intended to display visual elements.
 > * ViewModel is intended to convert the contents of the model to values that can be displayed on the view.
 >
 
 ## When to use the MVVM pattern?
 You should use this pattern when you need to convert your model to the view model. For example, i'll use this pattern to display human data as shown below.
 
 Note that when you are creating a real project, you are able to separate Model, ViewModel and View into different files to make it clean.
 ## Example below shows how the MVVM pattern works. Don't forget to open live view and launch playground to see the results and layout.
 */
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

