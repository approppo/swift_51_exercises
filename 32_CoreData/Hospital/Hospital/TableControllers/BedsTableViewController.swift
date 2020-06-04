import UIKit
import CoreData

class BedsTableViewController: UITableViewController, HospitalControllerProtocol {

    var context : NSManagedObjectContext?

    var _frc: NSFetchedResultsController<Bed>? = nil
    var fetchedResultsController: NSFetchedResultsController<Bed> {
        if _frc != nil {
            return _frc!
        }
        
        let fetchRequest: NSFetchRequest<Bed> = Bed.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let floor = NSSortDescriptor(key: "floor", ascending: true)
        let room = NSSortDescriptor(key: "room", ascending: true)
        fetchRequest.sortDescriptors = [floor, room]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: self.context!,
                                             sectionNameKeyPath: "floor",
                                             cacheName: "Master")
        _frc = frc
        
        do {
            try _frc!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _frc!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        }
        catch {
            fatalError("Could not fetch")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections![section]
        return "\(sectionInfo.indexTitle!)th Floor"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BED_CELL", for: indexPath)
        
        let bed = fetchedResultsController.object(at: indexPath)
        cell.textLabel!.text = "Room \(bed.room)"
        if let person = bed.patient {
            cell.detailTextLabel!.text = "\(person)"
        }
        
        return cell
    }
}
