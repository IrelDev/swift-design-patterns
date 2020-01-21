//: [Introduction](@previous)

/*:
 Delegation design pattern
 ============
 
 > Delegation pattern allows an object to use another object to provide data or perform a task instead of doing it yourself.
 >
 > Delegation design pattern has three parts, specifically Delegation Object, Delegate Protocol and Delegate object.
 >
 > * Delegation Object is an object that has a delegate.
 > * Delegate Protocol defines methods and computed properties that will be used in types that conforms to this protocol.
 > * Delegate object is an object that conforms to delegate protocol.
 >
 > Note that any protocol can be used as the delegate.
 
 ## When to use Delegation?
 Use this pattern to break up objects or create generic, reusable components.  Actually, delegation pattern is common in frameworks from Apple, especially in UIKit that will be used in this playground. For example, both UITableViewDelegate and UITableViewDataSource follow a delegation pattern.
 
 Why Apple use two delegates to provide tableView?
 * Apple frameworks use DataSource named objects to make a group of delegate methods that provide data. If you want to display UITableViewCells, your custom class must be conformed to the UITableViewDataSource Protocol.
 * Apple frameworks use Delegate named objects to make a group of delegate methods that receive data or events. If you want to know when row is selected, your custom class must be conformed to the UITableViewDelegate Protocol.
 
 ## Example below shows how Delegation works. Don't forget to open live view and launch playground to see results and layout.
 */
import UIKit
import PlaygroundSupport
//: DELEGATE PROTOCOL
protocol ColorDelegate: class{
    func changeBackgroundColorWhenTapped(_ tableView: UITableView, with color: UIColor)
}
class ViewController: UIViewController{
    var table = UITableView()
    //: VC BECOMES DELEGATION OBJECT
    weak var colorDelegate: ColorDelegate?
    
    override func viewDidLoad(){
        setupTableView()
    }
    func setupTableView(){
        view.addSubview(table)
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
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
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: cell.center.y / 2))
        label.frame = cell.frame
        label.text = "I'm label on \(indexPath.row) line"
        
        cell.addSubview(label)
        return cell
    }
}
//: TABLEVIEW DELEGATE
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let color: UIColor = table.backgroundColor == .black ? .white: .black
        colorDelegate = self
        colorDelegate?.changeBackgroundColorWhenTapped(table, with: color)
    }
}
//: VC BECOMES DELEGATE OBJECT
extension ViewController: ColorDelegate{
    func changeBackgroundColorWhenTapped(_ tableView: UITableView, with color: UIColor) {
        tableView.backgroundColor = color
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
