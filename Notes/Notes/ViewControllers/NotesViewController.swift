//
//  ViewController.swift
//  Notes
//
//  Created by Lakshmi on 4/6/17.
//  Copyright © 2017 com.arunsivakumar. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    let segueAddNoteViewController = "SegueAddNoteviewController"
    let segueNoteViewController = "SegueNoteViewController"
 
    
    
//    var notes:[Note]?{
//        didSet{
//            updateView()
//        }
//    }
    
    
    private let estimatedRowHeight = CGFloat(44.0)

    
    fileprivate let coreDataManager = CoreDataManager(modelName: "Notes")

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var notesView: UIView!
    @IBOutlet var tableView: UITableView!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    
    fileprivate lazy var updatedAtDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        return dateFormatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchNotes()
        setUpNotificationHandling()
        
        updateView()


        // Do any additional setup after loading the view, typically from a nib.
        
//        print(coreDataManager.managedObjectContext)
//        
//        let note = Note(context: coreDataManager.managedObjectContext)
//        note.title = "My Note"
//        
//        let entityDescription = NSEntityDescription.entity(forEntityName: "Note", in: coreDataManager.managedObjectContext)
//        let note = NSManagedObject(entity: entityDescription!, insertInto: coreDataManager.managedObjectContext)
//        note.setValue("My first note",forKey: "title")
//        note.setValue(NSDate(), forKey: "createdAt")
//        note.setValue(NSDate(), forKey: "updatedAt")
//        print(note)
//
//        do{
//            try coreDataManager.managedObjectContext.save()
//        }catch{
//            print(error.localizedDescription)
//        }
//        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    func managedObjectContextObjectsDidChange(_ notification: Notification) {
        
        /*
        guard let userInfo = notification.userInfo else { return }
        
        var notesDidChange = false // change UI
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>{
            for insert in inserts{
                if let note = insert as? Note{
                    notes?.append(note)
                    notesDidChange = true
                }
            }
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>{
            for update in updates{
                if let _ = update as? Note{
                    notesDidChange = true
                }
            }
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>{
            for delete  in deletes{
                
                if let note = delete as? Note{
                    if let index = notes?.index(of: note){
                        notes?.remove(at: index)
                        notesDidChange = true
                    }
                }
            }
        }
        
        if notesDidChange{
            notes?.sort(by: {$0.updatedAtAsDate > $1.updatedAtAsDate})
            
            tableView.reloadData()
            
            updateView()
        }
 */

    }
    
    private func setUpNotificationHandling(){
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: coreDataManager.managedObjectContext)
    }
    
    // MARK: - View Methods
    
    fileprivate func setupView() {
        setupMessageLabel()
        setupTableView()
    }
    
    fileprivate func updateView() {
        tableView.isHidden = !hasNotes
        messageLabel.isHidden = hasNotes
    }
//    fileprivate var hasNotes:Bool{
//        guard let notes = notes else{ return false}
//        return notes.count > 0
//    }
    
    fileprivate var hasNotes: Bool {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return false }
        return fetchedObjects.count > 0
    }

    // MARK: -
    
    private func setupMessageLabel() {
        messageLabel.text = "You don't have any notes yet."
    }
    
//    private func fetchNotes(){
//        let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key:#keyPath(Note.updatedAt),ascending:false)]
//        coreDataManager.managedObjectContext.performAndWait {
//            do{
//                let notes = try fetchRequest.execute()
//                self.notes = notes
//                self.tableView.reloadData()
//            }catch{
//                print("error")
//            }
//        }
//    }
    
    private func fetchNotes() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
        }
    }

    
    // MARK: -
    
    private func setupTableView() {
        tableView.isHidden = true
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueAddNoteViewController{
            if let vc = segue.destination as? AddNoteViewController{
                vc.managedObjectContext = coreDataManager.managedObjectContext
            }
        }else if segue.identifier == segueNoteViewController {
            if let destinationViewController = segue.destination as? NoteViewController{
                
                if let indexPath = tableView.indexPathForSelectedRow{
                let note = fetchedResultsController.object(at: indexPath)

                // Fetch Note
//                let note = fetchedResultsController.object(at: indexPath)
                
                // Configure View Controller
                    destinationViewController.note = note
                }
                
            }
        }
    }

}

extension NotesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell {
                configure(cell, at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
    
}


extension NotesViewController:UITableViewDataSource{
    
    func configure(_ cell: NoteTableViewCell, at indexPath: IndexPath) {
        // Fetch Note
        let note = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.titleLabel.text = note.title
        cell.contentsLabel.text = note.contents
        cell.tagsLabel.text = note.alphabetizedTagsAsString ?? "No Tags"
        cell.updatedAtLabel.text = updatedAtDateFormatter.string(from: note.updatedAtAsDate)
        
//        if let color = note.category?.color {
//            cell.categoryColorView.backgroundColor = color
//        } else {
//            cell.categoryColorView.backgroundColor = .white
//        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return hasNotes ? 1:0
        
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        guard let count = self.notes?.count else {return 0}
//        return count
        
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        guard let note = notes?[indexPath.row]else{fatalError("no note")}
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell else{ fatalError("error")}
        
//        let note = fetchedResultsController.object(at: indexPath)
//
//        
//        cell.titleLabel.text = note.title
//        cell.contentsLabel.text = note.contents
//        cell.updatedAtLabel.text = updatedAtDateFormatter.string(from: note.updatedAtAsDate)
        
        configure(cell, at: indexPath)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        // Fetch Note
        let note = fetchedResultsController.object(at: indexPath)
        
        
        // Delete Note
        coreDataManager.managedObjectContext.delete(note)
    }
}

extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

