//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by Ander Johnson on 12/1/2022.
//

import SwiftUI

struct Palette: Identifiable, Codable {
    var name: String
    var emojis: String
    var id: Int
    
    fileprivate init(name: String, emojis: String, id: Int) {
        self.name = name
        self.emojis = emojis
        self.id = id
    }
}

class PaletteStore: ObservableObject {
    let name: String
    
    @Published var palettes = [Palette]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey: String {
        "PaletterStore:" + name
    }
    
    private func storeInUserDefaults() {
        /*bad code*/
//        UserDefaults.standard.set(palettes.map { [$0.name, $0.emojis, String($0.id)] }, forKey: userDefaultsKey)
        UserDefaults.standard.set(try? JSONEncoder().encode(palettes), forKey: userDefaultsKey)
    }
    
    private func restoreInUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedPalettes = try? JSONDecoder().decode(Array<Palette>.self, from: jsonData) {
            palettes = decodedPalettes
        }
        /*bad code*/
//        if let palettesAsPropertyList = UserDefaults.standard.array(forKey: userDefaultsKey) as? [[String]] {
//            for paletteAsArray in palettesAsPropertyList {
//                if paletteAsArray.count == 3, let id = Int(paletteAsArray[2]), !palettes.contains(where: { $0.id == id }) {
//                    let palette = Palette(name: paletteAsArray[0], emojis: paletteAsArray[1], id: id)
//                    palettes.append(palette)
//                }
//            }
//        }
    }
    
    init(named name:String) {
        self.name = name
        restoreInUserDefaults()
        if palettes.isEmpty {
            print("using built-in palettes")
            insertPalette(named: "Vehicles", emojis: "🚗🚕🚙🚌🚎🏎🚓🚑🚒🚛🚲🛵🏍🛺✈️🚁🚀🛸🛶⛵️🛳")
            insertPalette(named: "Sports", emojis: "⚽️🏀🏈⚾️🥎🎾🏐🏉🥏🎱🪀🏓🏸🏹🎣🥊⛳️🥌")
            insertPalette(named: "Animals", emojis: "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐵🐔🐧🦆🦉🐗🦄🐝🐛🦋🐌🐞🐜🪰🪲🪳🐢🐍🦎🦖🦕🐙🦑🦐🦞🐠🦈🦍🐘🐄🐎🐑🐇🐉")
            insertPalette(named: "Faces", emojis: "😀😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😋🤨🤩🥸😎🥵")
            insertPalette(named: "Weathers", emojis: "☀️🌤⛈🌩🌨❄️🌪☔️")
        } else {
            print("successfully loaded palettes from UserDefaults:\(palettes)")
        }
    }
    
    // MARK: - Intent
    func palatte(at index: Int) -> Palette {
        let safeIndex = min(max(index, 0), palettes.count - 1)
        return palettes[safeIndex]
    }
    
    @discardableResult
    func removePalette(at index: Int) -> Int {
        if palettes.count > 1, palettes.indices.contains(index) {
            palettes.remove(at: index)
        }
        return index % palettes.count
    }
    
    func insertPalette(named name: String, emojis: String? = nil, at index: Int = 0) {
        let unique = (palettes.max(by: { $0.id < $1.id})?.id ?? 0) + 1
        let palette = Palette(name: name, emojis: emojis ?? "", id: unique)
        let safeIndex = min(max(index, 0), palettes.count)
        palettes.insert(palette, at: safeIndex)
    }
    
}
