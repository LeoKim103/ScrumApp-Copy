//
//  ScrumTimer.swift
//  ScrumApp
//
//  Created by Leo Kim on 08/11/2021.
// swiftlint:disable identifier_name

import Foundation

/// Keeps time for a daily scrum meeting. Keep track of the total meeting time for each speaker
/// and the name of the current speaker
class ScrumTimer: ObservableObject {
    /// the name of the meeting attendee who is speaking
    @Published var activeSpeaker = ""
    /// the number of seconds since the beginning of the meeting
    @Published var secondsElapsed = 0
    /// the number of seconds until all attendees have had a turn to speak
    @Published var secondsRemaining = 0
    /// All meeting attendees, listed in the order they will speak.
    var speakers = [Speaker]()
    /// the scrum meeting length
    var lengthInMinutes: Int
    /// A closure that is executed when a new attendee begins speaking
    var speakerChangedAction: (() -> Void)?

    private var timer: Timer?
    private var timerStopped = false
    private var frequency: TimeInterval { 1.0 / 60.0 }
    private var lengthInSeconds: Int { lengthInMinutes * 60}
    private var secondsPerSpeaker: Int { (lengthInMinutes * 60) / speakers.count }
    private var secondsElapsedForSpeaker: Int = 0
    private var speakerIndex: Int = 0
    private var speakerText: String {
        return "Speaker \(speakerIndex + 1): " + speakers[speakerIndex].name
    }
    private var startDate: Date?

    /**
     Initialise a new timer.
     Initialising a timer with no argument creates a ScrumTimer with no attendees and zero length.
     Use `startScrum()` to start the timer
     - Parameters:
        - lengthInMinutes: The meeting length.
        - attendees: The name of each attendees.
     */
    init(lengthInMinutes: Int = 0, attendees: [String] = []) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.isEmpty ?
        [Speaker(name: "Player 1", isCompleted: false)] : attendees.map { Speaker(name: $0, isCompleted: false)}

        secondsRemaining = lengthInMinutes
        activeSpeaker = speakerText
    }
    /// Start the timer
    func startScrum() {
        changeToSpeaker(at: 0)
    }
    /// Stop the timer
    func stopScrum() {
        timer?.invalidate()
        timer = nil
        timerStopped = true
    }

    func skipSpeaker() {
        changeToSpeaker(at: speakerIndex + 1)
    }

    private func changeToSpeaker(at index: Int) {
        if index > 0 {
            let previousSpeakerIndex = index - 1
            speakers[previousSpeakerIndex].isCompleted = true
        }

        secondsElapsedForSpeaker = 0
        guard index < speakers.count else { return }
        speakerIndex = index
        activeSpeaker = speakerText

        secondsElapsed = index * secondsPerSpeaker
        secondsRemaining = lengthInSeconds - secondsElapsed
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] _ in
            if let self = self,
               let startDate = self.startDate {
                let secondsElapsed = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
                self.update(secondsElapsed: Int(secondsElapsed))
            }
        }
    }

    private func update(secondsElapsed: Int) {
        secondsElapsedForSpeaker = secondsElapsed
        self.secondsElapsed = secondsPerSpeaker * speakerIndex + secondsElapsedForSpeaker
        guard secondsElapsed <= secondsPerSpeaker else { return }
        secondsRemaining = max(lengthInSeconds - self.secondsElapsed, 0)

        guard !timerStopped else { return }

        if secondsElapsedForSpeaker >= secondsPerSpeaker {
            changeToSpeaker(at: speakerIndex + 1)
            speakerChangedAction?()
        }
    }
    /**
     Reset the timer with a new meeting length and new attendees

     - Parameters:
        - lengthInMinutes: The meeting length
        - attendees: The name of each attendee
     */
    func reset(lengthInMinutes: Int, attendees: [String]) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.isEmpty ?
        [Speaker(name: "Player 1", isCompleted: false)] : attendees.map({ Speaker(name: $0, isCompleted: false)})

        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }

    struct Speaker: Identifiable {
        let name: String
        var isCompleted: Bool
        let id = UUID()
    }
}

extension DailyScrum {

    /// A new `ScrumTimer` using the meeting length and attendees in the `DailyScrum`.
    var timer: ScrumTimer {
        ScrumTimer(lengthInMinutes: lengthInMinutes, attendees: attendees)
    }
}
