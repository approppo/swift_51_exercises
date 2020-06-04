import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    // tag::permission[]
    var granted = false
    let center = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()

        center.requestAuthorization(options: [.alert, .sound, .badge],
                                    completionHandler: { (granted,error) in
                                        self.granted = granted
        })
        // end::permission[]


        // tag::actions[]
        let spamAction = UNNotificationAction(identifier: "flagAsSpam",
                                              title: "Flag as SPAM",
                                              options: [])
        let readAction = UNNotificationAction(identifier: "markAsRead",
                                              title: "Mark as Read",
                                              options: [])
        let category = UNNotificationCategory(identifier: "mailCategory",
                                              actions: [spamAction, readAction],
                                              intentIdentifiers: [],
                                              options: [])
        center.setNotificationCategories([category])
        // end::actions[]

        center.delegate = self
    }

    // tag::trigger1[]
    @IBAction func triggerNotification(_ sender: Any) {
        if granted {
            let content = UNMutableNotificationContent()
            content.title = "Learning iOS Local Notifications"
            content.subtitle = "Remember!"
            content.body = "Learning iOS will always be useful for you!"
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "mailCategory"
            // end::trigger1[]

            // tag::images[]
            if let path = Bundle.main.path(forResource: "landscape",
                                           ofType: "jpg") {
                let url = URL(fileURLWithPath: path)

                do {
                    let attachment = try UNNotificationAttachment(identifier: "landscape",
                                                                  url: url,
                                                                  options: nil)
                    content.attachments = [attachment]
                } catch {
                    print("The attachment was not loaded.")
                }
            }
            // end::images[]

            // tag::trigger2[]

            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: 10.0,
                repeats: false)

            let request = UNNotificationRequest(
                identifier: "simple.notification",
                content: content,
                trigger: trigger)

            center.removeAllPendingNotificationRequests()
            center.add(request, withCompletionHandler: nil)
        }
        // end::trigger2[]
    }

    // tag::delegate[]
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler
                                   completionHandler: @escaping () -> Void) {

        if response.actionIdentifier == "flagAsSpam" {
            // Do something here…
        }
    }
    // end::delegate[]
}
