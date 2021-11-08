//
//  ScrumApp.swift
//  ScrumApp
//
//  Created by Leo Kim on 05/11/2021.
//

import SwiftUI

@main
struct ScrumAppApp: App {
    @StateObject var dataController: DataController


    init() {
        let dataController = DataController()

        _dataController = StateObject(wrappedValue: dataController)
    }

    var body: some Scene {
        WindowGroup {
            ScrumsListView(scrums: $dataController.scrums) {
                dataController.save()
            }
            .environmentObject(dataController)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save)
            .onAppear {
                dataController.load()
            }
        }
    }
    func save(_ note: Notification) {
        dataController.save()
    }
}
