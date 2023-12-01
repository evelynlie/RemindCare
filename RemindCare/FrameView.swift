//
//  FrameView.swift
//  Add Meds
//
//  Created by Evelyn Lie on 21/11/2023.
//

import SwiftUI

struct FrameView: View {
    var image: CGImage?
    private let label = Text("frame")
    
    var body: some View {
        if let image = image {
            Image(image, scale: 1.0, orientation: .up, label: label)
        } else {
            Color.black
        }
    }
}

#Preview {
    FrameView()
}
