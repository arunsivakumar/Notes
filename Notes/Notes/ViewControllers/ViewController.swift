//
//  ViewController.swift
//  Notes
//
//  Created by Lakshmi on 4/6/17.
//  Copyright © 2017 com.arunsivakumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate let coreDataManager = CoreDataManager(modelName: "Notes")


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(coreDataManager.managedObjectContext)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

