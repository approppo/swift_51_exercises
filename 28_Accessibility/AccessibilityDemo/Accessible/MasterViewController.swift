import UIKit

class MasterViewController: UITableViewController {

    var customers = loadJSON()
    
    override func viewDidLoad() {
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showForm" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let customer = customers[indexPath.row]
                let controller = segue.destination as! FormViewController
                controller.customer = customer
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Customers"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let customer = customers[indexPath.row]
        cell.textLabel?.text = customer.name
        let completeAddress = "\(customer.address) – \(customer.zip) \(customer.city)"
        cell.detailTextLabel?.text = completeAddress
        cell.accessibilityLabel = customer.name
        return cell
    }
}

