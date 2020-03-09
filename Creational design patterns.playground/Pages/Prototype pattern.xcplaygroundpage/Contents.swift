//: [Factory](@previous)
/*:
 Prototype design pattern
 ============
 
 > The Prototype pattern allows to simply copy & clone objects.
 
 ## When to use the Prototype pattern?
 Use this pattern when you want to create an object with ability to copy itself.
 Swift foundation library has a default implementation of NSCopying protocol but we can write our own implementation.
 For example, we can use this pattern to copy a recipe, as in the example below.
 
 ## Example below shows how the Prototype pattern works. Don't forget to open live view and launch playground to see the results.
 */
//: FOUNDATION IMPLEMENTATION
import Foundation

class Recipe: NSCopying {
    var name: String
    private var ingredients: [String]
    
    init(name: String,
         ingredients: [String]) {
        self.name = name
        self.ingredients = ingredients
    }
    func addIngredient(ingredient: String) {
        guard ingredients.contains(where: {
            $0 == ingredient
        }) == false else { return }
        ingredients.append(ingredient)
    }
    func removeIngredient(ingredient: String) {
        guard let index = ingredients.firstIndex(where: {
            $0 == ingredient
        }) else { return }
        ingredients.remove(at: index)
    }
    
    //: NSCopying
    func copy(with zone: NSZone? = nil) -> Any {
        Recipe.init(name: name, ingredients: ingredients)
    }
}
extension Recipe: CustomStringConvertible {
    var description: String {
        String(describing: "Ingridients in \(name) recipe: \(ingredients)")
    }
}
//: FOUNDATION EXAMPLE
let eggsAndBaconRecipe = Recipe(name: "Eggs with bacon", ingredients: ["Eggs", "Bacon"])
print(eggsAndBaconRecipe)

let eggsAndBaconInAvocado = eggsAndBaconRecipe.copy() as! Recipe
print(eggsAndBaconInAvocado)

eggsAndBaconInAvocado.name = "Eggs with bacon in avocado"
eggsAndBaconInAvocado.addIngredient(ingredient: "Avocado")

print(eggsAndBaconInAvocado)
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

