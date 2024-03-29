//
//  CardView.swift
//  ScrumApp
//
//  Created by Leo Kim on 05/11/2021.
//

import SwiftUI

struct CardView: View {
    let scrum: DailyScrum

    var body: some View {
        VStack(alignment: .leading) {
            Text(scrum.title)
                .font(.headline)

            Spacer()

            HStack {
                Label("\(scrum.attendees.count)", systemImage: "person.3")
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("Attendees"))
                    .accessibilityValue(Text("\(scrum.attendees.count)"))

                Spacer()

                Label("\(scrum.lengthInMinutes)", systemImage: "clock")
                    .padding(.trailing)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("Meeting length"))
                    .accessibilityValue(Text("\(scrum.lengthInMinutes) minutes"))
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(scrum.color.accessibleFontColor)
        .background(scrum.color)
        .frame(height: 80)
        .frame(maxWidth: .infinity)
    }
}

struct CardView_Previews: PreviewProvider {
    static var scrumTest1 = DailyScrum.previewData[0]
    static var scrumTest2 = DailyScrum.previewData[1]

    static var previews: some View {
        Group {
            CardView(scrum: scrumTest1)
                .previewLayout(.sizeThatFits)

            CardView(scrum: scrumTest2)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
