//
//  ViewController.swift
//  Notes
//
//  Created by Lakshmi on 4/6/17.
//  Copyright © 2017 com.arunsivakumar. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    fileprivate let coreDataManager = CoreDataManager(modelName: "Notes")


    override func viewDidLoad() {
        super.viewDidLoad()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

