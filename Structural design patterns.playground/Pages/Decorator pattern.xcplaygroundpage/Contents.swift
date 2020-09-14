//: [Composite pattern](@previous)
/*:
 Decorator design pattern
 ============
 
 > The decorator pattern is a design pattern that allows behavior to be added to an individual object, dynamically, without affecting the behavior of other objects from the same class.
 
 ## Example below shows how the Decorator pattern works. Don't forget to launch playground to see the results.
 */
protocol Tesla {
    var name: String { get }
    var price: Double { get }
}

class ModelS: Tesla {
    var name: String {
        return "Model S"
    }
    
    var price: Double {
        return 94000.00
    }
}

class Model3: Tesla {
    var name: String {
        return "Model 3"
    }
    
    var price: Double {
        return 75500.00
    }
    
}

class TeslaDecorator: Tesla {
    var name: String {
        return carInstance.name
    }
    
    var price: Double {
        return carInstance.price
    }
    
    let carInstance: Tesla
    
    init(car: Tesla) {
        self.carInstance = car
    }
}

 class WheelUpgrades: TeslaDecorator {
    override var price: Double {
       return carInstance.price + 3000
    }
    
    override var name: String {
        return carInstance.name + " " + "17 in rims"
    }
    
    required override init(car: Tesla) {
        super.init(car: car)
    }
}

var model3: Tesla = Model3()
print(model3.price) // 75500.0
print(model3.name) // Model 3
model3 = WheelUpgrades(car: model3)
print(model3.price) // 78500.0
print(model3.name) // Model 3 17 in Rims
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

