//
//  AdventurerTableViewController.swift
//  group4_assignment6
//
//  Created by Geneivie Nguyen on 10/18/19.
//  Copyright © 2019 cs329e. All rights reserved.
//

import UIKit
import CoreData
import os.log


class AdventurerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var adventurerImage: UIImageView!
    @IBOutlet weak var adventurerName: UILabel!
    @IBOutlet weak var adventurerProfession: UILabel!
    @IBOutlet weak var adventurerLevel: UILabel!
    @IBOutlet weak var hpPoints: UILabel!
    @IBOutlet weak var attackPoints: UILabel!
    
}

var adventurers: [NSManagedObject] = []

class AdventurerTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Adventurer")
        do {
            adventurers = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adventurers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let adventurer = adventurers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdventurerCell", for: indexPath) as! AdventurerTableViewCell
        
        cell.adventurerName?.text = adventurer.value(forKeyPath: "name") as? String
        let level = adventurer.value(forKey: "level") as! Int
        let attack = adventurer.value(forKey: "attackModifier") as! Int
        let currentHP = adventurer.value(forKey: "currentHP") as! Int
        let totalHP = adventurer.value(forKey: "totalHP") as! Int
        cell.adventurerLevel?.text = "Level: \(level)"
        cell.adventurerProfession?.text = adventurer.value(forKeyPath: "profession") as? String
        cell.attackPoints?.text = "\(attack)"
        cell.hpPoints?.text = "\(currentHP) / \(totalHP)"

        return cell
    }
    
    // MARK - Formatting
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    

    //MARK: - Navigation

  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMemberSegue"{
            let questViewController = segue.destination as? QuestViewController
            
            if let selectedCell = sender as? AdventurerTableViewCell {
                let indexPath = tableView.indexPath(for: selectedCell)!
                let adventurer = adventurers[indexPath.row]
                if (questViewController != nil){
                    questViewController!.adventurer = adventurer
                }
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/
 
    
    
    @IBAction func unwindToAdventurersTableView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewAdventurerViewController {
            let person = sourceViewController.newPerson!
            
            // Add a new meal.
            let newIndexPath = IndexPath(row: adventurers.count, section: 0)
            
            adventurers.append(person)
            print(person)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
}
