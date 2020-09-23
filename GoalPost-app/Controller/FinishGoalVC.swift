//
//  FinishGoalVC.swift
//  GoalPost-app
//
//  Created by Wilman Garcia De Leon on 9/15/20.
//  Copyright © 2020 wilidgadev. All rights reserved.
//

import UIKit

class FinishGoalVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var createGoalBtn: UIButton!
    @IBOutlet weak var pointsTextField: UITextField!
    
    var goalDescription: String = ""
    var goalType: GoalType = GoalType.shortTerm
    
    
    
    func initData(description: String, goalType: GoalType){
        self.goalDescription = description
        self.goalType = goalType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGoalBtn.bindTokeyboard()
        pointsTextField.delegate = self
    }
    
    
    @IBAction func createGoalBtnWasPressed(_ sender: Any) {
        //pass data to core model.
        if pointsTextField.text != "" {
            self.save{(complete) in
                if complete {
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func save(completion:(_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let goal = Goal(context: managedContext)
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = Int32(pointsTextField.text!)!
        goal.goalProgress = Int32(0)
        
        do {
            try managedContext.save()
            completion(true)
//            self.delegate?.didFinishUpdates(finished: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }catch {
            debugPrint("Could not save: \(error)")
            completion(false)
        }
    }
}
