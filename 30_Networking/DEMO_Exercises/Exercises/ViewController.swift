import UIKit

typealias Entry = [String : Any]

class ViewController: UIViewController, UITableViewDataSource {
    var data = [Entry]()
    let location = "http://api.geonames.org/findNearbyWikipediaJSON?formatted=true&lat=47&lng=9&username=demo&style=full"

    @IBOutlet weak var tableView: UITableView!

    // tag::load[]
    @IBAction func loadData(_ sender: Any) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let url = URL(string: location)!
        let task = session.dataTask(with: url) { json, response, error in

            do {
                let object = try self.parse(json!)

                DispatchQueue.main.async { [unowned self] in
                    self.data = object
                    self.tableView.reloadData()
                }
            }
            catch GCDExampleError.limitReached {
                print("Limit reached on geonames.org")
            }
            catch {
                print("Could not deserialize JSON")
            }
        }

        task.resume()
    }
    // end::load[]

    // tag::parse[]

    // Our custom Error enum
    enum GCDExampleError: Error {
        case limitReached
    }
    
    func parse(_ data : Data) throws -> [Entry] {
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: [Entry]] else {
            throw GCDExampleError.limitReached
        }

        let geonames = json["geonames"]!
        return geonames
    }
    // end::parse[]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!

        let entry : Entry = data[indexPath.row]
        let title = entry["title"] as! String

        cell.textLabel?.text = title
        return cell
    }
}
