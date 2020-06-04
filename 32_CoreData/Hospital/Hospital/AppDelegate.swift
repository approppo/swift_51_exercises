import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // tag::stack[]
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HospitalModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // end::stack[]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if TARGET_OS_SIMULATOR != 0 {
            // Where is the SQLite file?
            let path = FileManager.default.urls(for: .libraryDirectory,
                                                in: .userDomainMask)
            print("Documents Directory: \(path)");
        }

        // tag::context[]
        let rootController = self.window!.rootViewController as! UITabBarController
        let context = self.persistentContainer.viewContext
        for child in rootController.viewControllers! {
            let nav = child as! UINavigationController
            var controller = nav.topViewController as! HospitalControllerProtocol
            controller.context = context
        }
        // end::context[]

        initializeContext()

        return true
    }

    // tag::init[]
    func initializeContext() {
        do {
            let context = self.persistentContainer.viewContext
            let bedsRequest: NSFetchRequest<Bed> = Bed.fetchRequest()
            let beds = try context.fetch(bedsRequest)
            if beds.count == 0 {
                for floor : Int32 in 1...3 {
                    for room : Int32 in 1...5 {
                        let bed = Bed(context: context)
                        bed.floor = floor
                        bed.room = room
                    }
                }

                let doctor1 = Doctor(context: context)
                doctor1.firstName = "Meredith"
                doctor1.lastName = "Grey"
                doctor1.speciality = "Pediatrics"

                let doctor2 = Doctor(context: context)
                doctor2.firstName = "Piotr"
                doctor2.lastName = "Doctorovitch"
                doctor2.speciality = "Ophtalmology"

                let doctor3 = Doctor(context: context)
                doctor3.firstName = "Derek"
                doctor3.lastName = "Shepherd"
                doctor3.speciality = "Neurology"
            }

            try context.save()
        }
        catch {
            fatalError("Could not initialize database")
        }
    }
    // end::init[]
}
