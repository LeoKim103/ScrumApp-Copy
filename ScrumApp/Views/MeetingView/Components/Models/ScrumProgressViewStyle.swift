//
//  ScrumProgressViewStyle.swift
//  ScrumApp
//
//  Created by Leo Kim on 08/11/2021.
//

import SwiftUI

struct ScrumProgressViewStyle: ProgressViewStyle {
    var scrumColor: Color

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .fill(scrumColor.accessibleFontColor)
                .frame(height: 20)

            ProgressView(configuration)
                .frame(height: 12)
                .padding(.horizontal)
        }
    }
}


