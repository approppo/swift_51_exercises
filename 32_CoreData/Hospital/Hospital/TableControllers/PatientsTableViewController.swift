import UIKit
import CoreData

class PatientsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, HospitalControllerProtocol {

    var context : NSManagedObjectContext?

    // tag::frc[]
    var _frc: NSFetchedResultsController<Patient>? = nil
    var fetchedResultsController: NSFetchedResultsController<Patient> {
        if _frc != nil {
            return _frc!
        }

        let fetchRequest: NSFetchRequest<Patient> = Patient.fetchRequest()
        fetchRequest.fetchBatchSize = 20

        let sortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.context!,
            sectionNameKeyPath: nil,
            cacheName: "Master")
        frc.delegate = self
        _frc = frc

        do {
            try _frc!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        return _frc!
    }
    // end::frc[]

    // tag::fetch[]
    func requestBed() -> Bed? {
        do {
            let bedsRequest: NSFetchRequest<Bed> = Bed.fetchRequest()
            bedsRequest.predicate = NSPredicate(format: "patient = nil")
            let beds = try context?.fetch(bedsRequest)
            if let bed = beds?.first {
                return bed
            }
        }
        catch {
            fatalError("Could not fetch beds")
        }
        return nil
    }
    // end::fetch[]

    // tag::random[]
    func requestDoctor() -> Doctor {
        do {
            let doctorsRequest: NSFetchRequest<Doctor> = Doctor.fetchRequest()
            let doctors = try context?.fetch(doctorsRequest)
            let random = Int(arc4random_uniform(UInt32((doctors?.count)!)))
            return doctors![random]
        }
        catch {
            fatalError("Could not fetch a doctor")
        }
    }
    // end::random[]

    // tag::add[]
    @IBAction func addPatient(_ sender: Any) {
        guard let bed = requestBed() else {
            let alert = UIAlertController(title: "The hospital is full",
                message: "Cannot add new patient",
                preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }

        let patient = Patient(context: self.context!)
        patient.admissionDate = Date()
        patient.firstName = Patient.random().0
        patient.lastName = Patient.random().1
        patient.age = Patient.random().2
        patient.bed = bed
        patient.doctor = requestDoctor()

        do {
            try context?.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    // end::add[]

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PATIENT_CELL",
            for: indexPath)

        let patient = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withPatient: patient)

        return cell
    }

    func configureCell(_ cell: UITableViewCell,
        withPatient patient: Patient) {
        cell.textLabel!.text = "\(patient)"
        cell.detailTextLabel!.text = "\(patient.bed!) – \(patient.doctor!)"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let destination = segue.destination as! PatientViewController
            let patient = fetchedResultsController.object(at: indexPath)
            destination.patient = patient
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
            switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            default:
                break
            }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
