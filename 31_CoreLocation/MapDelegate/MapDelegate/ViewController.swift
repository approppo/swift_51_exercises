import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let formatter = NumberFormatter()
    let identifier = "SwissCity"
    let manager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        manager.delegate = self
        manager.requestWhenInUseAuthorization()

        formatter.maximumFractionDigits = 0
        formatter.maximumSignificantDigits = 3
        formatter.groupingSeparator = "'"
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true

        let cities : [String : (Double, Double, Int)] = [
            "Zurich": (47.366667, 8.55, 346185),
            "Geneva": (46.195602, 6.148113, 181492),
            "Basel": (47.558395, 7.573271, 164474),
            "Bern": (46.916667, 7.466667, 123018),
            "Lausanne": (46.533333, 6.666667, 118015),
            "Winterthur": (47.500035, 8.7251, 91368),
            "Luzern": (47.083333, 8.266667, 57269),
            "Biel": (47.141666, 7.257589, 49675),
            "Thun": (46.751176, 7.621663, 41539),
            "La Chaux-de-Fonds": (47.104417, 6.828892, 36971),
            "Köniz": (46.923391, 7.408688, 35961),
            "Schaffhausen": (47.697316, 8.634929, 34445),
            "Fribourg": (46.79572, 7.154748, 33806),
            "Chur": (46.856753, 9.526918, 32874),
            "Neuchatel": (46.993089, 6.93005, 31216),
            "Vernier": (46.217693, 6.08511, 29767),
            "Uster": (47.351997, 8.713687, 29583),
            "Sion": (46.229076, 7.359417, 28246),
            "Emmen": (47.081101, 8.30477, 27290),
            "Lugano": (46.006182, 8.951142, 26327),
            "Kriens": (47.035366, 8.276307, 26117),
            ]

            // tag::annotation[]
            for (name, data) in cities {
                let lat = data.0
                let lon = data.1
                let people = formatter.string(for: data.2)!
                let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)

                let annotation = SwissAnnotation()
                annotation.coordinate = location
                annotation.title = name
                annotation.subtitle = "\(people) people"
                annotation.population = data.2
                mapView.addAnnotation(annotation)
            }
            // end::annotation[]
    }

    // tag::display[]
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let swissCity = annotation as? SwissAnnotation {
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if view == nil {
                view = MKAnnotationView(annotation: swissCity, reuseIdentifier: identifier)
                view?.isEnabled = true
                view?.canShowCallout = true
            }
            else {
                view?.annotation = annotation
            }
            
            if swissCity.population > 100000 {
                view?.image = UIImage(named: "city")
            }
            else {
                view?.image = UIImage(named: "town")
            }
            return view
        }

        return nil
    }
    // end::display[]
}
