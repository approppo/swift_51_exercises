import UIKit

enum NetworkError : Error {
    case invalidURL
    case nilData
}

typealias Players = [[String: String]]

class ViewController: UIViewController, UITableViewDataSource {

    lazy var players = Players()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        download()
    }

    func download() {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        if let url = URL(string: "http://localhost:8888/data.json") {
            // tag::task[]
            let task = session.dataTask(with: url) { [unowned self] data, response, error in
                do {
                    // This code is executed in the background
                    if let data = data, let json = try JSONSerialization.jsonObject(with: data,
                                                                   options: []) as? [String: Players] {
                        DispatchQueue.main.async {
                            
                            if let players = json["players"] {
                                print("json: \(players)")
                                
                                // This code is executed in the main thread
                                self.players = players
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
                catch {
                    print("There was an error!")
                }
            }
            task.resume()
            // end::task[]
        }
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return players.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let player = players[indexPath.row]
        let first = player["first_name"]!
        let last = player["last_name"]!
        cell.textLabel?.text = "\(first) \(last)"
        return cell
    }
}
