import UIKit
import CoreData

class DoctorsTableViewController: UITableViewController, HospitalControllerProtocol {

    var context : NSManagedObjectContext?

    var _frc: NSFetchedResultsController<Doctor>? = nil
    var fetchedResultsController: NSFetchedResultsController<Doctor> {
        if _frc != nil {
            return _frc!
        }
        
        let fetchRequest: NSFetchRequest<Doctor> = Doctor.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: self.context!,
                                             sectionNameKeyPath: nil,
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DOCTOR_CELL", for: indexPath)
        
        let doctor = fetchedResultsController.object(at: indexPath)
        cell.detailTextLabel!.text = "\(doctor)"
        cell.textLabel!.text = "\(doctor.speciality!)"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let destination = segue.destination as! DoctorViewController
            let doctor = fetchedResultsController.object(at: indexPath)
            destination.doctor = doctor
        }
    }
}
