//: [Introduction](@previous)

/*:
 MVC design pattern
 ============
 
 > MVC design pattern separates objects into three types, specifically Model, View and Controller.
 >
 > * Model is intended to store data in structures or classes (usually structures).
 > * View is intended to display visual elements.
 > * Controller is intended to coordinate between models and views.
 
 ## When to use MVC?
 This pattern is more of a starting point for creating swift & objc applications, but in the future you will probably use additional patterns besides MVC even in single project.
 ## The example below shows how MVC works. Don't forget to open live view and launch playground to see results and layout.
 */
import UIKit
import PlaygroundSupport
//: MODEL
public struct NewspaperPublication: Decodable{
    var publicationAuthor: String
    var publicationTitle: String
    var publicationDescription: String?
    var publishedAt: Date
}
extension NewspaperPublication: CustomStringConvertible{
    public var description: String{
        String(describing: "Author: \(publicationAuthor)\nTitle: \(publicationTitle)\nDescription: \(publicationDescription!)\nPublished at: \(publishedAt)")
    }
}
//: VIEW
public class NewspaperPublicationView: UIView{
    public var authorLabel: UILabel!
    public var titleLabel: UILabel!
    public var descriptionLabel: UILabel!
    public var publishedAtLabel: UILabel!
}
//: CONTROLLER
public class NewspaperViewController: UIViewController{
    public var publication: NewspaperPublication?
    
    public override func viewDidLoad(){
        super.viewDidLoad()
        updateViewFromJSON()
    }
    private func updateViewFromJSON(){
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
    private func dataFromJSON() -> NewspaperPublication{
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
//: [NextDesignPattern](@next)
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
