//
//  ScrumsListView.swift
//  ScrumApp
//
//  Created by Leo Kim on 05/11/2021.
//

import SwiftUI

struct ScrumsListView: View {
    @Environment(\.scenePhase) private var scenePhase

    @Binding var scrums: [DailyScrum]

    @State private var isPresented = false
    @State private var newScrumData = DailyScrum.Data()

    let saveAction: () -> Void

    var body: some View {
        NavigationView {
            List {
                ForEach(scrums) { scrum in
                    NavigationLink(destination: DetailView(scrum: binding(for: scrum) )) {
                        CardView(scrum: scrum)
                    }
                    .listRowBackground(scrum.color)
                }
                .onDelete { indices in
                    scrums.remove(atOffsets: indices)
                }
            }
            .navigationTitle("Daily Scrums")
            .toolbar {
                addScrumButton
            }
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    EditView(scrumData: $newScrumData)
                        .toolbar {
                            dismissButton
                            createScrumButton
                        }
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct ScrumsListView_Previews: PreviewProvider {
    static var previews: some View {
        ScrumsListView(scrums: .constant(DailyScrum.previewData), saveAction: {})
            .preferredColorScheme(.dark)
    }
}

extension ScrumsListView {
    private var addScrumButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                isPresented.toggle()
                newScrumData.title = ""
                newScrumData.attendees = []
                newScrumData.lengthInMinutes = 5
                newScrumData.color = .random
            } label: {
                Image(systemName: "plus")
            }
        }
    }

    private var dismissButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Dismiss") {
                isPresented = false
            }
        }
    }

    private var createScrumButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Add") {
                let newScrum = DailyScrum(
                    title: newScrumData.title,
                    attendees: newScrumData.attendees,
                    lengthInMinutes: Int(newScrumData.lengthInMinutes),
                    color: newScrumData.color
                )

                scrums.append(newScrum)
                isPresented = false
            }
        }
    }

    private func binding(for scrum: DailyScrum) -> Binding<DailyScrum> {
        guard let scrumIndex = scrums.firstIndex(where: { $0.id == scrum.id }) else {
            fatalError("Can't find scrum in data array")
        }
        return $scrums[scrumIndex]
    }
}
