//
//  HistoryView .swift
//  ScrumApp
//
//  Created by Leo Kim on 08/11/2021.
//

import SwiftUI

struct HistoryView: View {
    let history: History

    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    Divider()
                        .padding(.bottom)

                    Text("Attendees")
                        .font(.headline)

                    Text(history.attendeeString)

                    Spacer(minLength: 20)

                    Text("Duration")
                        .font(.headline)

                    Text("\(history.lengthInMinutes) minutes")
            }
            .navigationTitle(Text(history.date, style: .date))
            .padding()
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(history: History(attendees: ["Leo", "Jean", "Clair"], lengthInMinutes: 10))
    }
}

extension History {
    var attendeeString: String {
        ListFormatter.localizedString(byJoining: attendees)
    }
}
