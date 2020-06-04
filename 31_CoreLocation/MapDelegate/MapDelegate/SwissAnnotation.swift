// tag::class[]
import MapKit

class SwissAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    public var title: String? = nil
    public var subtitle: String? = nil

    public var population = 0
}
// end::class[]

