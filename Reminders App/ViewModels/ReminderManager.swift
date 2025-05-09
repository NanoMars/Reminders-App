//
//  ReminderManager.swift
//  Reminders App
//
//  Created by Armand Packham-McGuiness on 4/5/2025.
//

import Foundation
import SwiftUI
import Combine

class ReminderManager: ObservableObject {
    @Published var reminders: [Reminder] = []
    @Environment(\.colorScheme) var colorScheme
    
    private var cancellables = Set<AnyCancellable>()
    
    let saveKey = "reminders"
    
    init() {
        loadReminders()
    }
    
    func addReminder(reminder: Reminder) {
        reminders.append(reminder)
        saveReminders()
    }
    
    func removeReminder(id: UUID) {
        reminders.removeAll { $0.id == id}
        saveReminders()
    }
    
    private func saveReminders() {
        if let encoded = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadReminders() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Reminder].self, from: data) {
            reminders = decoded
        }
    }
    
    func markComplete(id: UUID) {
        if let index = reminders.firstIndex(where: {$0.id == id}) {
            reminders[index].complete = true
            reminders = reminders
            saveReminders()
        }
    }
    func editReminder(id: UUID, newReminder: Reminder) {
        if let index = reminders.firstIndex(where: {$0.id == id}) {
            reminders[index] = newReminder
            reminders = reminders
            saveReminders()
        }
    }
}


