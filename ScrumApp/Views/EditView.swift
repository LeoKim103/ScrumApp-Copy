//
//  EditView.swift
//  ScrumApp
//
//  Created by Leo Kim on 05/11/2021.
//

import SwiftUI

struct EditView: View {
    @Binding var scrumData: DailyScrum.Data
    @State private var newAttendee = ""

    var body: some View {
        List {
            editGeneralInfoSection
            editAttendeeSection

        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(scrumData: .constant(DailyScrum.previewData[0].data))
            .preferredColorScheme(.dark)
    }
}

extension EditView {
    private var editGeneralInfoSection: some View {
        Section(header: Text("Meeting Info")) {
            TextField("Title", text: $scrumData.title)

            HStack {
                Slider(value: $scrumData.lengthInMinutes, in: 5...30, step: 1.0) {
                    Text("Length")
                }
                .accessibilityValue(Text("\(Int(scrumData.lengthInMinutes)) minutes"))

                Spacer()

                Text("\(Int(scrumData.lengthInMinutes)) minutes")
                    .accessibilityHidden(true)
            }

            ColorPicker("Color", selection: $scrumData.color)
                .accessibilityLabel(Text("Color picker"))
        }
    }

    private var editAttendeeSection: some View {
        Section(header: Text("Attendees")) {
            ForEach(scrumData.attendees, id: \.self) { attendee in
                Text(attendee)
            }
            .onDelete { indices in
                scrumData.attendees.remove(atOffsets: indices)
            }

            HStack {
                TextField("New Attendee", text: $newAttendee)

                Button {
                    withAnimation {
                        scrumData.attendees.append(newAttendee)
                        newAttendee = ""
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .accessibilityLabel(Text("Add attendee"))
                }
                .disabled(newAttendee.isEmpty)
            }
        }
    }
}
