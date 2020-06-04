import UIKit

enum NetworkError : Error {
    case invalidURL
    case nilData
}

// tag::players[]
struct PlayerContainer: Codable {
    let players: [Player]
}
// end::players[]

// tag::player[]
struct Player: Codable {
    let firstName: String
    let lastName: String

    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
// end::player[]

class ViewController: UIViewController, UITableViewDataSource {

    var playerArray: [Player] = []
    lazy var playerContainer = PlayerContainer(players: playerArray)

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
            // tag::task_codable[]
            let task = session.dataTask(with: url) { [unowned self] data, response, error in
                do {
                    if let data = data {
                        // This code is executed in the background
                        let decoder = JSONDecoder()
                        self.playerContainer = try decoder.decode(PlayerContainer.self, from: data)
                        
                        DispatchQueue.main.async {
                            // This code is executed in the main thread
                            self.tableView.reloadData()
                        }
                    }
                }
                catch {
                    print("There was an error!")
                }
            }
            task.resume()
            // end::task_codable[]
        }
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return playerContainer.players.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let player = playerContainer.players[indexPath.row]
        cell.textLabel?.text = "\(player.firstName) \(player.lastName)"
        return cell
    }
}
