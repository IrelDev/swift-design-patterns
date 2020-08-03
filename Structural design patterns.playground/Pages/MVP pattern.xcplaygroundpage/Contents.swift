//: [MVC pattern](@previous)

/*:
The MVP design pattern
============

> The MVP design pattern separates objects into three types, specifically Model, View and Presenter.
>
> * Model is intended to store data in structures or classes (usually structures).
> * View is intended to display visual elements, in MVP it's can be even a view controller with only view related stuff.
> * Presenter is intended to coordinate between models and views.
>

## When to use the MVP pattern?
You should use this pattern when you need to separate logic from views & view controllers.

Note that when you are creating a real project, you are able to separate Model, Presenter and View into different files to make it clean.
## Example below shows how the MVP pattern works. Don't forget to open live view and launch playground to see the results and layout.
*/
import Foundation

var str = "Hello, playground"

//: [MVVM pattern](@next)
