//
//  DetailView.swift
//  ScrumApp
//
//  Created by Leo Kim on 05/11/2021.
//

import SwiftUI

struct DetailView: View {
    @Binding var scrum: DailyScrum

    @State private var data: DailyScrum.Data = DailyScrum.Data()
    @State private var isPresented = false

    var body: some View {
        List {
            mainInfoSection
            attendeeInfoSection
            historySection

        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(scrum.title)
        .toolbar {
            editButton
        }
        .fullScreenCover(isPresented: $isPresented) {
            NavigationView {
                EditView(scrumData: $data)
                    .navigationTitle(scrum.title)
                    .toolbar {
                        cancelButton

                        doneButton
                    }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(scrum: .constant(DailyScrum.previewData[2]))
                .preferredColorScheme(.dark)
        }
    }
}

extension DetailView {
    private var mainInfoSection: some View {
        Section(header: Text("Meeting Info")) {
            NavigationLink(destination: MeetingView(scrum: $scrum)) {
                Label("Start Meeting", systemImage: "timer")
                    .font(.headline)
                    .foregroundColor(Color.accentColor)
                    .accessibilityLabel(Text("Start meeting"))
            }

            HStack {
                Label("Length", systemImage: "clock")
                    .accessibilityLabel(Text("Meeting length"))

                Spacer()

                Text("\(scrum.lengthInMinutes) minutes")
            }

            HStack {
                Label("Color", systemImage: "paintpalette")

                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(scrum.color)
            }
            .accessibilityElement(children: .ignore)
        }
    }

    private var attendeeInfoSection: some View {
        Section(header: Text("Attendees")) {
            ForEach(scrum.attendees, id: \.self) { attendee in
                Label(attendee, systemImage: "person")
                    .accessibilityLabel("Person")
                    .accessibilityValue(Text(attendee))
            }
        }
    }

    private var historySection: some View {
        Section(header: Text("History")) {
            if scrum.history.isEmpty {
                Label("No meeting yet", systemImage: "calendar.badge.exclamationmark")
            }

            ForEach(scrum.history) { history in
                NavigationLink(destination: HistoryView(history: history)) {
                    HStack {
                        Image(systemName: "calendar")

                        Text(history.date, style: .date)
                    }
                }
            }
        }
    }

    private var editButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Edit") {
                isPresented.toggle()
                data = scrum.data
            }
        }
    }

    private var cancelButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                isPresented = false
            }
        }
    }

    private var doneButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Done") {
                isPresented = false
                scrum.update(from: data)
            }
        }
    }
}
