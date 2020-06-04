import UIKit
import Contacts
import ContactsUI

class MasterViewController: UITableViewController {

    var store = CNContactStore()
    var contacts = [CNContact]()

    // tag::access[]
    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = true

        requestAccess { accessGranted in

            var message = ""
            do {
                let keys = [CNContactViewController.descriptorForRequiredKeys()]

                // Filter contacts
                // let predicate = CNContact.predicateForContacts(matchingName: "")
                // self.contacts = try self.contactsStore.unifiedContacts(matching: predicate,
                //                                                       keysToFetch: keys as [CNKeyDescriptor])

                // Retrieve all contacts
                let request = CNContactFetchRequest(keysToFetch:keys as [CNKeyDescriptor])
                try self.store.enumerateContacts(with: request) { contact, pointer in
                    self.contacts.append(contact)
                }

                self.tableView.reloadData()
            }
            catch {
                message = "Unable to fetch contacts."
            }
            print(message)
        }
    }
    // end::access[]

    // tag::request[]
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)

        switch authorizationStatus {
        case .authorized:
            completionHandler(true)

        case .denied, .notDetermined:
            store.requestAccess(for: .contacts) { access, accessError in
                if access {
                    DispatchQueue.main.async {
                        completionHandler(access)
                    }
                }
                else {
                    if authorizationStatus == .denied {
                        DispatchQueue.main.async {
                            let message = "Please allow the app to access your contacts."
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
        return contacts.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let contact = contacts[indexPath.row]
        cell.textLabel!.text = "\(contact.givenName) \(contact.familyName)"
        return cell
    }

    // tag::display[]
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        let controller = CNContactViewController(for: contact)
        navigationController?.pushViewController(controller, animated: true)
    }
    // end::display[]
}
