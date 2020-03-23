//: [Iterator pattern](@previous)
/*:
 State design pattern
 ============
 
 > The State pattern allows to change the behavior of an object at runtime.
 
 ## When to use the State pattern?
Use this pattern when your object has two and more states that can be changed during its lifetime. This pattern is very useful when you have to rewrite swift-case machines in a better way.
 ## Example below shows how the State pattern works. Don't forget to launch playground to see the results.
 */
enum Song: String {
    case godzilla
    case madeByAmerica
    case prayForMe
    case none
}
class AudioSystem {
    private var state: AudioSystemState = TurnedOffState()
    private var isTurnedOn: Bool = false
    
    var isPlaying: Bool {
        get {
            state.isPlaying(audioSystem: self)
        }
    }
    var songName: Song {
        get {
            state.songName(audioSystem: self)
        }
    }
    func turnOff() {
        isTurnedOn = false
        state = TurnedOffState()
    }
    func turnOn() {
        isTurnedOn = true
        state = TurnedOnState()
    }
    func playMusic(with song: Song) {
        if isTurnedOn {
            state = PlayingState(song: song)
        } else {
            print("Cannot play music because AudioSystem is turned off.")
        }
    }
}
extension AudioSystem: CustomStringConvertible {
    var description: String {
        String(describing: "Turned on: \(isTurnedOn), is song playing \(isPlaying), song name is \(songName.rawValue)\n")
    }
}
protocol AudioSystemState: class {
    func isPlaying(audioSystem: AudioSystem) -> Bool
    
    func songName(audioSystem: AudioSystem) -> Song
}
class TurnedOffState: AudioSystemState {
    func isPlaying(audioSystem: AudioSystem) -> Bool { false }
    
    func songName(audioSystem: AudioSystem) -> Song { .none }
}

class TurnedOnState: AudioSystemState {
    func isPlaying(audioSystem: AudioSystem) -> Bool { false }
    func songName(audioSystem: AudioSystem) -> Song { .none }
}
class PlayingState: AudioSystemState {
    var song: Song
    
    init(song: Song) {
        self.song = song
    }
    func isPlaying(audioSystem: AudioSystem) -> Bool {
        guard song != Song.none else {
            return false
        }
        return true
    }
    func songName(audioSystem: AudioSystem) -> Song { song }
}
let audioSystem = AudioSystem()
print(audioSystem)

audioSystem.turnOn()
print(audioSystem)

audioSystem.playMusic(with: .godzilla)
print(audioSystem)

audioSystem.turnOff()
print(audioSystem)

audioSystem.playMusic(with: .madeByAmerica)
//: [Multicast delegate pattern](@next)
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
