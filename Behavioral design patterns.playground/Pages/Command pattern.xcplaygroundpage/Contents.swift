//: [Mediator pattern](@previous)
/*:
 Command design pattern
 ============
 
 > The Command pattern allows you to turn "commands" into objects that allow you to pass them as arguments. In addition, these commands can be canceled or queued.
 
 ## Example below shows how the Command pattern works. Don't forget to launch playground to see the results.
 */
class Receiver {
    var audioSystemIsTurnedOn = false
    var musicIsPlaying = false
}
class AbstractAudioCommand {
    public let receiver: Receiver
    init(receiver: Receiver) {
        self.receiver = receiver
    }
    func execute() { }
}
class TurnOnCommand: AbstractAudioCommand {
    override func execute() {
        guard !receiver.audioSystemIsTurnedOn else {
            print("Audio system is already on")
            return
        }
        print("Got command... Audio System is turned on")
        receiver.audioSystemIsTurnedOn = true
    }
}
class TurnOffCommand: AbstractAudioCommand {
    override func execute() {
        guard receiver.audioSystemIsTurnedOn else {
            print("Audio system is already off")
            return
        }
        if receiver.musicIsPlaying {
            print("Music is turning off..")
            receiver.musicIsPlaying = false
        }
        print("Got command... Audio System is turned off")
        receiver.audioSystemIsTurnedOn = false
    }
}
class PlayMusicCommand: AbstractAudioCommand {
    override func execute() {
        guard receiver.audioSystemIsTurnedOn else {
            print("Audio system is turned off, music cannot be played")
            return
        }
        print("Got command... Audio System is playing music")
        receiver.musicIsPlaying = true
    }
}
class StopMusicCommand: AbstractAudioCommand {
    override func execute() {
        guard receiver.audioSystemIsTurnedOn else {
            print("Audio system is turned off, music cannot be played")
            return
        }
        guard !receiver.musicIsPlaying else {
            print("Audio System is already playing music")
            return
        }
        print("Got command... Audio System is not playing music now")
    }
}
class Invoker {
    var listOfCommands: [AbstractAudioCommand]
    let receiver: Receiver
    
    init(receiver: Receiver, listOfCommands: [AbstractAudioCommand] = []) {
        self.receiver = receiver
        self.listOfCommands = listOfCommands
    }
    func addCommand(command: AbstractAudioCommand) {
        listOfCommands.append(command)
    }
    func removeCommandAtIndex(index: Int) -> Bool {
        guard listOfCommands.indices.contains(index) else {
            return false
        }
        listOfCommands.remove(at: index)
        return true
    }
    func performListOfCommands() {
        listOfCommands.forEach({
            $0.execute()
        })
    }
}
let audioSystem = Receiver()
let invoker = Invoker(receiver: audioSystem)

invoker.addCommand(command: TurnOnCommand(receiver: audioSystem))
invoker.addCommand(command: PlayMusicCommand(receiver: audioSystem))
invoker.addCommand(command: TurnOffCommand(receiver: audioSystem))

invoker.performListOfCommands()
//: [Chain of responsibility pattern](@next)
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
