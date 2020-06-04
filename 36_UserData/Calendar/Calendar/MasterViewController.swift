import UIKit
import EventKit
import EventKitUI

class MasterViewController: UITableViewController {

    var events = [EKEvent]()
    let store = EKEventStore()

    // tag::access[]
    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = true

        requestAccess { success in
            let now = Date()
            let nextYear = now.addingTimeInterval(60 * 60 * 24 * 365)
            let predicate = self.store.predicateForEvents(withStart: now,
                                                          end: nextYear,
                                                          calendars: nil)
            self.events = self.store.events(matching: predicate)
            self.tableView.reloadData()
        }
    }
    // end::access[]

    // tag::request[]
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = EKEventStore.authorizationStatus(for: .event)

        switch authorizationStatus {
        case .authorized:
            completionHandler(true)

        case .denied, .notDetermined:
            store.requestAccess(to: .event) { access, error in
                if access {
                    DispatchQueue.main.async {
                        completionHandler(access)
                    }
                }
                else {
                    if authorizationStatus == .denied {
                        DispatchQueue.main.async {
                            let message = "Please allow the app to access your calendar."
                            print(message)
                        }
                    }
                }
            }

        default:
            completionHandler(false)
        }
    }
    // end::request[]

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let event = events[indexPath.row]
        cell.textLabel!.text = event.title
        return cell
    }

    // tag::display[]
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        let controller = EKEventViewController()
        controller.event = event
        navigationController?.pushViewController(controller, animated: true)
    }
    // end::display[]
}
