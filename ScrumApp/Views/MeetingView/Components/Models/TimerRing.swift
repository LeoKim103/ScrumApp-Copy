//
//  TimerRing.swift
//  ScrumApp
//
//  Created by Leo Kim on 08/11/2021.
//

import Foundation
import SwiftUI

struct TimerRing: Shape {
    let speakerIndex: Int
    let totalSpeakers: Int

    private var degreesPerSpeaker: Double {
        360 / Double(totalSpeakers)
    }

    private var startAngle: Angle {
        Angle(degrees: degreesPerSpeaker * Double(speakerIndex) + 1)
    }

    private var endAngle: Angle {
        Angle(degrees: startAngle.degrees + degreesPerSpeaker - 1.0)
    }

    func path(in rect: CGRect) -> Path {
        let diameter = min(rect.size.width, rect.size.height) - 24.0
        let radius = diameter / 2
        let center = CGPoint(x: rect.origin.x + rect.size.width / 2.0,
                             y: rect.origin.y + rect.size.height / 2.0)
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
    }
}
