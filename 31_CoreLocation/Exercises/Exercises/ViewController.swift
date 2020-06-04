import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        
        NotificationCenter.default.addObserver(forName: .showMapData,
                                               object: nil,
                                               queue: nil) { notification in
            let locations = notification.userInfo?["locations"] as! [CLLocation]
            
            if locations.count > 0 {
                var mapRegion = MKCoordinateRegion();
                mapRegion.center = (locations.last?.coordinate)!
                mapRegion.span.latitudeDelta = 0.01
                mapRegion.span.longitudeDelta = 0.01
                self.mapView.setRegion(mapRegion, animated: true)
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                for location in locations {
                    let pin = MKPointAnnotation()
                    pin.coordinate = location.coordinate
                    self.mapView.addAnnotation(pin)
                }
            }
        }
    }
}
