//
//  CustomSegmentedPicker.swift
//  RemindCare
//
//  Created by Evelyn Lie on 22/11/2023.
//

import SwiftUI

struct CustomSegmentedPicker: View {
    @Binding var meal: Int

    var options: [String]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(Color.customGrey.opacity(0.2))
                    Rectangle()
                        .fill(Color.customBlue)
                        .cornerRadius(7)
                        .padding(2)
                        .opacity(meal == index ? 1 : 0.01)
                        .onTapGesture {
                            withAnimation(.interactiveSpring()) {
                                meal = index
                            }
                        }
                }
                .overlay(
                    Text(options[index])
                        .font(.callout)
                        .fontWeight(meal == index ? .semibold : .medium)

                )
            }
        }
        .frame(height: 35)
        .cornerRadius(7)
    }
}
