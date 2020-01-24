//: [Delegation pattern](@previous)
/*:
 Strategy design pattern
 ============
 
 > Strategy pattern defines a family of interchangeable objects and allows you to set or select these objects at runtime.
 >
 > Strategy pattern has three parts, specifically Object using a strategy, Strategy Protocol, and the Strategies
 > * Object using a strategy can be any object that needs interchangeable behavior.
 > * Strategy Protocol defines methods and computed properties that will be used in types that conforms to this protocol.
 > * Strategies are objects that conform to the strategy protocol.
 
 ## When to use Strategy?
 Use this pattern when you need to implement two or more ways to do one thing or use this like an alternative to if/else & switch blocks.
 For example, you can use this pattern when you want to implement two types of quicksort, as in example below.
 
 ## Example below shows how Strategy works. Don't forget to open live view and launch playground to see results and layout.
 */
import Foundation
import UIKit
import PlaygroundSupport
//: STRATEGY PROTOCOL
protocol QuicksortStrategy{
    func quicksorted<Element>(_ array: inout [Element], lowestIndex: Int, highestIndex: Int) where Element: Comparable
    
    func partition<Element>(_ array: inout [Element], lowestIndex: Int, highestIndex: Int) -> Int where Element: Comparable
}
//: STRATEGIES
struct HoareQuicksortStrategy: QuicksortStrategy{
    func quicksorted<Element>(_ array: inout [Element], lowestIndex: Int, highestIndex: Int) where Element: Comparable{
        if lowestIndex < highestIndex{
            let pivotPoint = partition(&array, lowestIndex: lowestIndex, highestIndex: highestIndex)
            quicksorted(&array, lowestIndex: lowestIndex, highestIndex: pivotPoint)
            quicksorted(&array, lowestIndex: pivotPoint + 1, highestIndex: highestIndex)
        }
    }
    func partition<Element>(_ array: inout [Element], lowestIndex: Int, highestIndex: Int) -> Int where Element : Comparable{
        let pivotPoint = array[lowestIndex]
        var startIndex = lowestIndex - 1
        var endIndex = highestIndex + 1
        
        while true {
            repeat {endIndex -= 1} while array[endIndex] > pivotPoint
            repeat {startIndex += 1} while array[startIndex] < pivotPoint
            
            if startIndex < endIndex{
                array.swapAt(startIndex, endIndex)}
            else{
                return endIndex
            }
        }
    }
}
struct LomutoQuicksortStrategy: QuicksortStrategy{
    func quicksorted<Element>(_ array: inout [Element], lowestIndex: Int, highestIndex: Int) where Element: Comparable{
        if lowestIndex < highestIndex{
            let pivotPoint = partition(&array, lowestIndex: lowestIndex, highestIndex: highestIndex)
            quicksorted(&array, lowestIndex: lowestIndex, highestIndex: pivotPoint - 1)
            quicksorted(&array, lowestIndex: pivotPoint + 1, highestIndex: highestIndex)
        }
    }
    func partition<Element>(_ array: inout [Element], lowestIndex: Int, highestIndex: Int) -> Int where Element: Comparable {
        let pivotPoint = array[highestIndex]
        
        var startIndex = lowestIndex
        
        for index in lowestIndex..<highestIndex {
            if array[index] <= pivotPoint{
                array.swapAt(startIndex, index)
                startIndex += 1
            }
        }
        array.swapAt(startIndex, highestIndex)
        return startIndex
    }
}
//: OBJECT USING A STRATEGY
class ViewController: UIViewController{
    var quicksortStrategy: QuicksortStrategy?
    
    var resultLabel: UILabel!
    override func viewDidLoad() {
        setupView()
    }
    func setupView(){
        view.backgroundColor = .white
        
        createStack(with: createHoareButton(), and: createLomutoButton())
        
        setupResultLabel()
        
    }
    func createHoareButton() -> UIButton{
        let executeWithHoareButton = UIButton()
        
        executeWithHoareButton.backgroundColor = .systemPink
        executeWithHoareButton.clipsToBounds = true
        executeWithHoareButton.layer.cornerRadius = 10
        executeWithHoareButton.tintColor = .white
        executeWithHoareButton.setTitle("Execute with Hoare", for: .normal)
        
        executeWithHoareButton.addTarget(self, action: #selector(hoareExecution), for: .touchUpInside)
        return executeWithHoareButton
    }
    func createLomutoButton() -> UIButton{
        let executeWithLomutoButton = UIButton()
        
        executeWithLomutoButton.backgroundColor = .systemPink
        executeWithLomutoButton.clipsToBounds = true
        executeWithLomutoButton.layer.cornerRadius = 10
        executeWithLomutoButton.tintColor = .white
        executeWithLomutoButton.setTitle("Execute with lomuto", for: .normal)
        
        executeWithLomutoButton.addTarget(self, action: #selector(lomutoExecution), for: .touchUpInside)
        return executeWithLomutoButton
    }
//: STRATEGY USAGE
    @objc func hoareExecution(){
        var hoareArray = (0...3).map({_ in Int.random(in: 0...10)})
        quicksortStrategy = HoareQuicksortStrategy()
        quicksortStrategy?.quicksorted(&hoareArray, lowestIndex: 0, highestIndex: 3)
        resultLabel.text = "Hoare quicksorted array: \(hoareArray)"
    }
    @objc func lomutoExecution(){
        var lomutoArray = (0...3).map({_ in Int.random(in: 0...10)})
        quicksortStrategy = LomutoQuicksortStrategy()
        quicksortStrategy?.quicksorted(&lomutoArray, lowestIndex: 0, highestIndex: 3)
        resultLabel.text = "Lomuto quicksorted array: \(lomutoArray)"
    }
    func createStack(with first: UIButton, and second: UIButton){
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
    func setupResultLabel(){
        resultLabel = UILabel()
        resultLabel.text = "Waiting for result..."
        view.addSubview(resultLabel)
        
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
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
