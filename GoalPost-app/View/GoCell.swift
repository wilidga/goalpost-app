//
//  GoCell.swift
//  GoalPost-app
//
//  Created by Wilman Garcia De Leon on 9/9/20.
//  Copyright © 2020 wilidgadev. All rights reserved.
//

import UIKit

class GoCell: UITableViewCell {

    @IBOutlet weak var goalDescriptionLbl: UILabel!
    @IBOutlet weak var goalTypeLbl: UILabel!
    @IBOutlet weak var goalProgressLbl: UILabel!
    
    @IBOutlet weak var completionView: UIView!
    func configureCell(goal: Goal){
        
        self.goalDescriptionLbl.text = goal.goalDescription
        self.goalTypeLbl.text = goal.goalType
        self.goalProgressLbl.text = String(describing: goal.goalProgress )
        
        if goal.goalProgress == goal.goalCompletionValue {
            self.completionView.isHidden = false
        }else{
            self.completionView.isHidden = true
        }
        
    }
    
    
}

