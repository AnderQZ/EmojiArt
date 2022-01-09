//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Ander Johnson on 9/1/2022.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocument()
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}