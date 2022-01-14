//
//  PaletteManager.swift
//  EmojiArt
//
//  Created by Ander Johnson on 14/1/2022.
//

import SwiftUI

struct PaletteManager: View {
    @EnvironmentObject var store: PaletteStore
    
    var body: some View {
        List {
            ForEach(store.palettes) { palette in
                VStack(alignment: .leading) {
                    Text(palette.name)
                    Text(palette.emojis)
                }
            }
        }
    }
}

struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager()
            .previewDevice("iPhone 13")
            .environmentObject(PaletteStore(named: "Preview"))
    }
}
