//
//  MeetingTimerView.swift
//  ScrumApp
//
//  Created by Leo Kim on 08/11/2021.
//

import SwiftUI

struct MeetingTimerView: View {
    let speakers: [ScrumTimer.Speaker]
    var scrumColor: Color

    private var currentSpeaker: String {
        speakers.first(where: { !$0.isCompleted })?.name ?? "Someone"
    }

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(lineWidth: 24, antialiased: true)

            VStack {
                Text(currentSpeaker)
                    .font(.title)

                Text("is speaking")

                Image(systemName: "mic")
                    .font(.title)
                    .padding(.top)
            }
            .accessibilityElement(children: .combine)
            .foregroundColor(scrumColor.accessibleFontColor)

            ForEach(speakers) { speaker in
                if speaker.isCompleted,
                   let index = speakers.firstIndex(where: { $0.id == speaker.id }) {
                    TimerRing(speakerIndex: index, totalSpeakers: speakers.count)
                        .rotation(Angle(degrees: -90))
                        .stroke(scrumColor, lineWidth: 12)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct MeetingTimerView_Previews: PreviewProvider {
    static var speakers =
        [
            ScrumTimer.Speaker(name: "Leo", isCompleted: true),
            ScrumTimer.Speaker(name: "Ogura", isCompleted: false)
        ]
    static var previews: some View {
        MeetingTimerView(speakers: speakers, scrumColor: Color.red)
    }
}
