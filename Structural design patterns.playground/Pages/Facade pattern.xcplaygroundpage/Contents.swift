//: [MVVM pattern](@previous)
/*:
 Facade design pattern
 ============
 
 > The Facade pattern allows to simply interact with complex systems.
 ## When to use the Facade pattern?
 
 Use this pattern when you have a complex system with multiple components and you want to implement an easier way to perform an action.
 
 ## Example below shows how the Facade pattern works. Don't forget to launch playground to see the results.
 */
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
