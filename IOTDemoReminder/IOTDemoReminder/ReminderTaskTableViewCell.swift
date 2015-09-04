//
//  ReminderTaskTableViewCell.swift
//  IOTDemoReminder
//
//  Created by  on 9/4/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

import UIKit
import EventKit

class ReminderTaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblReminderTitle: UILabel!
    @IBOutlet weak var lblReminderNote: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fetchingDataToView (reminder : EKReminder) {
        self.lblReminderTitle.text = reminder.title
        if let tempNote = reminder.notes {
            self.lblReminderNote.text = tempNote
        } else {
            self.lblReminderNote.text = ""
        }
    }
}
