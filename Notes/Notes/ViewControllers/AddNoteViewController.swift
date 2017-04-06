//
//  AddNotesViewController.swift
//  Notes
//
//  Created by Lakshmi on 4/7/17.
//  Copyright © 2017 com.arunsivakumar. All rights reserved.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController {
    
    var managedObjectContext:NSManagedObjectContext?
    
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    fileprivate let coreDataManager = CoreDataManager(modelName: "Notes")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Note"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        titleTextField.becomeFirstResponder()
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        guard let managedObjectContext = managedObjectContext else { return }
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(with: "Title Missing", and: "Your note doesn't have a title.")
            return
        }
        
        // Create Note
        let note = Note(context: managedObjectContext)
        
        // Configure Note
        note.createdAt = NSDate()
        note.updatedAt = NSDate()
        note.title = titleTextField.text
        note.contents = contentsTextView.text
        
        // Pop View Controller
        _ = navigationController?.popViewController(animated: true)

        
    }
    
    func showAlert(with title: String, and message: String) {
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Configure Alert Controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present Alert Controller
        present(alertController, animated: true, completion: nil)
    }
}
