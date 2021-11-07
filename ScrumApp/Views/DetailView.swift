//
//  DetailView.swift
//  ScrumApp
//
//  Created by Leo Kim on 05/11/2021.
//

import SwiftUI

struct DetailView: View {
    @Binding var scrum: DailyScrum

    @State private var isPresented = false

    var body: some View {
        List {
            Section(header: Text("Meeting Info")) {
                Label("Start Meeting", systemImage: "timer")
                    .font(.headline)
                    .foregroundColor(Color.accentColor)
                    .accessibilityLabel(Text("Start meeting"))

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

            Section(header: Text("Attendees")) {
                ForEach(scrum.attendees, id: \.self) { attendee in
                    Label(attendee, systemImage: "person")
                        .accessibilityLabel("Person")
                        .accessibilityValue(Text(attendee))
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(scrum.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    isPresented.toggle()
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
