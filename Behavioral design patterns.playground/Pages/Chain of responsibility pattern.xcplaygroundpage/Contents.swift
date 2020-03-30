//: [Command pattern](@previous)
/*:
 Chain of responsibility pattern
 ============
 
 > The Chain of responsibility pattern allows to pass a request through a chain of handlers until one of them can process the request.
 ## Example below shows how the Chain of responsibility pattern works. Don't forget to launch playground to see the results.
 */
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
