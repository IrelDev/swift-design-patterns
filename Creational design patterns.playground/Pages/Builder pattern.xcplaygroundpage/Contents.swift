//: [Singleton pattern](@previous)

/*:
 Builder design pattern
 ============
 
 > The Builder pattern allows creating complex objects step by step without creating a massive initializer or creating multiple subclasses of an object.
 >
 > Builder pattern has three parts, specifically the builder, the product and the director.
 > * Director class contains methods that specify the order of the builder's steps.
 > * Builder gets step-by-step orders from director and handles the creation of the product.
 >*  Product is an object that will be created by builders.
 
 ## When to use the Builder pattern?
 Use this pattern when you want to create a complex object step-by-step
 For example, we can use this pattern to create a car, as in the example below.
 
 ## Example below shows how the Builder pattern works. Don't forget to open live view and launch playground to see the results and layout.
 */
import UIKit
import PlaygroundSupport

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
    func decreaseDoorsAmountOnTwo() {
        guard doorsAmount >= 4 else {
            print("Doors amount cannot be less than two")
            return
        }
        doorsAmount -= 2
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
    func createEconomClassCar() -> Car {
        let builder = CarBuilder()
        builder.setComplectation(complectation: .econom)
        
        return builder.buildProduct()
    }
    func createUltraSuperProClassCar() -> Car {
        let builder = CarBuilder()
        
        builder.increaseDoorsAmountOnTwo(for: 10)
        builder.setMaterial(material: .platinum)
        builder.setComplectation(complectation: .pro)
        
        builder.addComponent(component: .audioSystem)
        builder.addComponent(component: .seatHeating)
        
        return builder.buildProduct()
    }
    func createStandartClassCar() -> Car {
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
        human.car = Director().createEconomClassCar()
        
        guard let car = human.car else { return }
        print(car)
    }
    @objc func performStandartCarCreationProcess() {
        var human = Human()
        human.car = Director().createStandartClassCar()
        
        guard let car = human.car else { return }
        print(car)
    }
    @objc func performProCarCreationProcess() {
        var human = Human()
        human.car = Director().createUltraSuperProClassCar()
        
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
