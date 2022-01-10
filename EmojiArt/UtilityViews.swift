//
//  UtilityViews.swift
//  EmojiArt
//
//  Created by Ander Johnson on 9/1/2022.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        if uiImage != nil {
            Image(uiImage: uiImage!)
        }
    }
}
