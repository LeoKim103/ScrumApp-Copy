//
//  MeetingHeaderVIew.swift
//  ScrumApp
//
//  Created by Leo Kim on 08/11/2021.
//

import SwiftUI

struct MeetingHeaderView: View {
    let secondElapsed: Int
    let secondRemaining: Int
    let scrumColor: Color

    private var progress: Double {
        guard secondRemaining > 0 else { return 1 }
        let totalSeconds = Double(secondElapsed + secondRemaining)
        return Double(secondElapsed) / totalSeconds
    }

    private var minutesRemaining: Int {
        secondRemaining / 60
    }

    private var minutesRemainingMetric: String {
        minutesRemaining == 1 ? "minute" : "minutes"
    }

    var body: some View {
        VStack {
            ProgressView(value: progress)
                .progressViewStyle(ScrumProgressViewStyle(scrumColor: scrumColor))

            HStack {
                VStack(alignment: .leading) {
                    Text("Seconds Elapsed")
                        .font(.caption)

                    Label("\(secondElapsed)", systemImage: "hourglass.bottomhalf.fill")
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("Seconds Remaining")
                        .font(.caption)

                    Label("\(secondRemaining)", systemImage: "hourglass.tophalf.fill")
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Time remaining"))
        .accessibilityValue(Text("\(minutesRemaining) \(minutesRemainingMetric)"))
        .padding([.top, .horizontal])
    }


}

struct MeetingHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingHeaderView(secondElapsed: 60, secondRemaining: 180, scrumColor: DailyScrum.previewData[0].color)
            .previewLayout(.sizeThatFits)
    }
}
