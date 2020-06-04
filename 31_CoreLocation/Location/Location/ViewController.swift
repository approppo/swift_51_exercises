import UIKit
import CoreLocation

// tag::init[]
class ViewController: UIViewController, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    let formatter = NumberFormatter()

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        manager.delegate = self
        manager.requestWhenInUseAuthorization()

        formatter.maximumFractionDigits = 2
    }
    // end::init[]

    // tag::startstop[]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        manager.stopUpdatingHeading()
        manager.stopUpdatingLocation()
    }
    // end::startstop[]

    // tag::delegate[]
    func locationManager(_ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let lat = formatter.string(for: location.coordinate.latitude)!
        let lon = formatter.string(for: location.coordinate.longitude)!
        let alt = formatter.string(for: location.altitude)!
        latitudeLabel.text = "Latitude: \(lat)º"
        longitudeLabel.text = "Longitude: \(lon)º"
        altitudeLabel.text = "Altitude: \(alt)m"
    }
    // end::delegate[]

    func locationManager(_ manager: CLLocationManager,
        didUpdateHeading newHeading: CLHeading) {
        let angle = formatter.string(for: newHeading.magneticHeading)!
        headingLabel.text = "Heading: \(angle)º"
    }
}
