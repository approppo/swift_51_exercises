import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.mapType = .satellite
        
        // tag::pins[]
        let cities = [
            "Zurich": [47.366667, 8.55, 346185],
            "Geneva": [46.195602, 6.148113, 181492],
            "Basel": [47.558395, 7.573271, 164474],
            "Bern": [46.916667, 7.466667, 123018],
            "Lausanne": [46.533333, 6.666667, 118015],
            "Winterthur": [47.500035, 8.7251, 91368],
            "Luzern": [47.083333, 8.266667, 57269],
            "Biel": [47.141666, 7.257589, 49675],
            "Thun": [46.751176, 7.621663, 41539],
            "La Chaux-de-Fonds": [47.104417, 6.828892, 36971],
            "Köniz": [46.923391, 7.408688, 35961],
            "Schaffhausen": [47.697316, 8.634929, 34445],
            "Fribourg": [46.79572, 7.154748, 33806],
            "Chur": [46.856753, 9.526918, 32874],
            "Neuchatel": [46.993089, 6.93005, 31216],
            "Vernier": [46.217693, 6.08511, 29767],
            "Uster": [47.351997, 8.713687, 29583],
            "Sion": [46.229076, 7.359417, 28246],
            "Emmen": [47.081101, 8.30477, 27290],
            "Lugano": [46.006182, 8.951142, 26327],
            "Kriens": [47.035366, 8.276307, 26117],
        ]

        for (name, data) in cities {
            let lat = data[0]
            let lon = data[1]

            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            pin.title = name
            mapView.addAnnotation(pin)
        }
        // end::pins[]
    }
}
