//
//  NotesTableViewCell.swift
//  Notes
//
//  Created by Lakshmi on 4/7/17.
//  Copyright © 2017 com.arunsivakumar. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "NoteTableViewCell"
    
    // MARK: -
    
    @IBOutlet var tagsLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentsLabel: UILabel!
    @IBOutlet var updatedAtLabel: UILabel!
    @IBOutlet var categoryColorView: UIView!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
