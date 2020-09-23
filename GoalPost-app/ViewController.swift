//
//  ViewController.swift
//  GoalPost-app
//
//  Created by Wilman Garcia De Leon on 9/8/20.
//  Copyright © 2020 wilidgadev. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate
var goals: [Goal]  = []
var goalRemove: Bool = true
class GoalsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var UndoUIView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        UndoUIView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    
    }

  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObject()
        tableView.reloadData()
    }
    @objc func loadList(notification: NSNotification){
        //load data here
        fetchCoreDataObject()
        self.tableView.reloadData()
    }

 func fetchCoreDataObject(){
        self.fetch {(complete) in
                    if complete {
                       if goals.count >= 1 {
                           tableView.isHidden = false
                           
                       } else {
                       tableView.isHidden = true
                       }
                   }
               }
        
    }
    
    @IBAction func addGoalBtnWasPressed(_ sender: Any) {
//        guard let createGoalVC = storyboard?.instantiateViewController(identifier: "CreateGoalVC") else {
//            return }
//        
//        
//        createGoalVC.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//        self.present(createGoalVC, animated: true, completion: nil)
//        
////        presentDetail(createGoalVC)
////        present(createGoalVC, animated: true)
    }
    
    
    @IBAction func UndoBtnWasPressed(_ sender: Any) {
        goalRemove = false
    }
    
    
    
}


extension GoalsVC: UITableViewDelegate, UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoCell") as? GoCell else {
            return UITableViewCell() }
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
//            self.removeGoal(atIndexPath: indexPath)
//            self.fetchCoreDataObject()
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//        deleteAction.background = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
//
//    }
    
      func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            //Code I want to do here
           
//            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            //show the undo view
            self.UndoUIView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if goalRemove {
                    self.removeGoal(atIndexPath: indexPath)
                    self.fetchCoreDataObject()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } else {
                    goalRemove = true
                    tableView.reloadData()
                }
                self.UndoUIView.isHidden = true
            }
        }
        
        
        
        
        let addAction = UIContextualAction(style: .normal, title: "Add 1") {  (contextualAction, view, boolValue) in
                  //Code I want to do here
                self.setProgress(atIndexPaht: indexPath)
                tableView.reloadRows(at: [indexPath], with: .automatic)
              }
        addAction.backgroundColor = #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1)
        contextItem.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem, addAction])
        
        return swipeActions
    }
    
    
}

extension GoalsVC {
    func setProgress( atIndexPaht indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let chosenGoal = goals[indexPath.row]
        
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress = chosenGoal.goalProgress + 1
        } else {
            return
        }
        do {
            try managedContext.save()
            print("Successfully set progress!")
        } catch {
            debugPrint("Could not set Progress: \(error.localizedDescription)")
        }
        
        
    }
    
    
    func removeGoal(atIndexPath indexPath: IndexPath){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
      
        managedContext.delete(goals[indexPath.row])
        
        do {
            try managedContext.save()
        } catch  {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    func fetch(completion: (_ compleate: Bool) ->()) {
        guard  let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            goals = try managedContext.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
}





