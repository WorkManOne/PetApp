import Foundation
import UserNotifications
import UIKit

class NotificationManager {
    static let shared = NotificationManager()

    @Published var isPermissionGranted: Bool = false

    private init() {
        checkAuthorizationStatus()
    }

    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isPermissionGranted = settings.authorizationStatus == .authorized
            }
        }
    }

    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isPermissionGranted = granted
                completion(granted)
            }
        }
    }

    func scheduleNotification(for event: EventModel) {
        guard isPermissionGranted else { return }
        guard event.date > Date() else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Time to procedures!"
        content.body = "\(event.procedure.name) for \(UserService().pets.first(where: { $0.id == event.petId })?.name ?? "your pet")"
        content.sound = .default
        content.userInfo = [
            "eventId": event.id.uuidString,
            "petId": event.petId?.uuidString ?? "",
            "procedureName": event.procedure.name
        ]

        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: event.date
        )

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let identifier = "event_\(event.id.uuidString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func rescheduleNotification(for event: EventModel) {
        removeNotification(for: event.id)
        scheduleNotification(for: event)
    }

    func removeNotification(for eventId: UUID) {
        let identifier = "event_\(eventId.uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func openAppSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}
