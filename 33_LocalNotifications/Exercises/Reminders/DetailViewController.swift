//
//  DetailViewController.swift
//  Reminders
//
//  Created by Adrian Kosmaczewski on 07.04.17.
//  Copyright © 2017 Adrian Kosmaczewski. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    let center = UNUserNotificationCenter.current()
    var granted = false
    
    var managedObjectContext: NSManagedObjectContext? = nil
    let formatter = DateFormatter()
    
    var eventItem: Event? {
        didSet {
            configureView()
        }
    }
    
    @IBAction func dateSelected(_ sender: Any) {
        if let event = eventItem {
            event.dueDate = datePicker.date
            configureNotification()
            configureView()
            save()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eventItem?.title = textField.text
        textField.resignFirstResponder()
        save()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        center.requestAuthorization(options: [.alert,.sound,.badge],
                                    completionHandler: { (granted,error) in
                                        self.granted = granted
        })
        
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        configureView()
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let event = eventItem,
            let label = detailDescriptionLabel,
            let field = textField {
            if let date = event.dueDate {
                let str = formatter.string(from: date as Date)
                label.text = "Notification will fire at \(str)"
            }
            else {
                label.text = "(no due date for notification)"
            }
            
            if let title = event.title {
                field.text = title
            }
            else {
                field.text = ""
            }
        }
    }
    
    func save() {
        do {
            try managedObjectContext?.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func extractComponents(from date: Date) -> DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        let dateParts = calendar.dateComponents(in: .current, from: date)
        let components = DateComponents(calendar: calendar,
                                        timeZone: .current,
                                        month: dateParts.month,
                                        day: dateParts.day,
                                        hour: dateParts.hour,
                                        minute: dateParts.minute)
        return components
    }
    
    func configureNotification() {
        if granted,
            let event = eventItem,
            let title = event.title,
            let date = event.dueDate {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = "This notification was set from the Reminders app!"
            content.categoryIdentifier = "message"
            content.sound = UNNotificationSound.default
            
            let components = extractComponents(from: date as Date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components,
                                                        repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "reminder.notification",
                content: content,
                trigger: trigger)
            
            center.removeAllPendingNotificationRequests()
            center.add(request, withCompletionHandler: nil)
        }
    }
}
