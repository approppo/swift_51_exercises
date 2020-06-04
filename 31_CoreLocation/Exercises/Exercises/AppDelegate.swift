import MapKit

extension Notification.Name {
    static let showMapData = Notification.Name("Show map data notification")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locations = [CLLocation]()
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        locationManager.requestAlwaysAuthorization()
        locationManager.activityType = .fitness
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        notify()
    }
    
    func notify() {
        let notification = Notification(name: .showMapData,
                                        object: self,
                                        userInfo: ["locations": locations])
        NotificationCenter.default.post(notification)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        self.locations.append(contentsOf: locations)
        if UIApplication.shared.applicationState == .active {
            notify()
        }
    }
}
