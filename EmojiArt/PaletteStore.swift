//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by Ander Johnson on 12/1/2022.
//

import SwiftUI

struct Palette: Identifiable, Codable, Hashable {
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
            insertPalette(named: "Vehicles", emojis: "πππππππππππ²π΅ππΊβοΈπππΈπΆβ΅οΈπ³")
            insertPalette(named: "Sports", emojis: "β½οΈππβΎοΈπ₯πΎπππ₯π±πͺππΈπΉπ£π₯β³οΈπ₯")
            insertPalette(named: "Animals", emojis: "πΆπ±π­πΉπ°π¦π»πΌπ»ββοΈπ¨π―π¦π?π·πΈπ΅ππ§π¦π¦ππ¦πππ¦ππππͺ°πͺ²πͺ³π’ππ¦π¦π¦ππ¦π¦π¦π π¦π¦ππππππ")
            insertPalette(named: "Faces", emojis: "ππππ€£π₯²βΊοΈππππππππ₯°ππππ€¨π€©π₯Έππ₯΅")
            insertPalette(named: "Weathers", emojis: "βοΈπ€βπ©π¨βοΈπͺβοΈ")
            insertPalette(named: "Flags", emojis: "π³οΈβππ¦π«π¦πΏπ¦π©π¦π½π¦πΊπ¦π΄πͺπ¬π¦π·π³οΈββ§οΈπΊπ³π¦πͺπ¦π?π²π΄π΅πΎπ΅πΈπ§π§π¦π¬π?πͺπ¦πΌπ¦π±π©πΏπ΄π²πͺπͺπ¦πΉπ΅π¬π§π­π§π¬π΅πͺπ§π΄π§π?π©πͺπ©π°π¬πΆπ°π΅π?π΄π§πΏπ§πΌπ§πΉπ§π«π§π¦π΅π±π΅π·π?πΈπͺπ¨πͺπ·π¬π«πΉπ«π»π¦π΅π­π«π―π¨π¬π¬π²π«π°π¨π»π«π?π¨π©π¨π΄π¨π·π¬π©π¬π±π¬πΊπ¬π΅π¨πΊπ¬π¬π¬πͺπ¬πΎπ°πΏπ­πΉπ°π·π³π±π§πΆπΈπ½π²πͺπ­π³π°π?π¨π¦π¬πΌπ¬π³π°π¬π©π―π°πΎπΆπ¦π¨π²π±π§π±πΉπ±π·π±πΎπ·π΄π·πΌπ·πͺπ²π±πΎπΉπ²πΎ")
            insertPalette(named: "Magic", emojis: "πβ?οΈβοΈβͺοΈπβ―οΈππ―β‘οΈβΈοΈβ¦οΈπββοΈβοΈβοΈβοΈβοΈβοΈβοΈβοΈβοΈβοΈβοΈβοΈπβοΈπβ’οΈβ£οΈπΈποΈπΆπ³π΄πΊπ·οΈβ΄οΈππγοΈγοΈπ΄π±οΈπ°οΈπ²ππβ¨οΈπ’ππ―")
        } else {
            print("successfully loaded palettes from UserDefaults:\(palettes)")
        }
    }
    
    // MARK: - Intent
    func palette(at index: Int) -> Palette {
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
