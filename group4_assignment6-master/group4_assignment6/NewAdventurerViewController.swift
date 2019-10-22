//
//  ViewController.swift
//  group4_assignment6
//
//  Created by Geneivie Nguyen on 10/16/19.
//  Copyright © 2019 cs329e. All rights reserved.
//

import UIKit
import CoreData
import os.log

class AdventurerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var adventurerImage: UIImageView!
}


// ENTER AND SAVE NEW ENTRIES
class NewAdventurerViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //saves character
    @IBAction func saveButton(_ sender: UIButton) {
        if(nameTextField.text! != "" && classTextField.text! != "") {
            self.save(name: nameTextField.text!, profession: classTextField.text!)
        
        dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath as IndexPath) as! AdventurerCollectionViewCell
        return cell
    }
    
    //creates character
    func save(name: String, profession: String) -> NSManagedObject {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return NSManagedObject()
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Adventurer", in: managedContext)! 
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        //initializes attributes
        person.setValue(name, forKeyPath: "name")
        person.setValue(profession, forKeyPath: "profession")
        person.setValue(1, forKeyPath: "level")
        person.setValue(10, forKeyPath: "currentHP")
        person.setValue(10, forKeyPath: "totalHP")
        person.setValue(5, forKeyPath: "attackModifier")
        
        return person
        /*
        // append to adventurers array in table view
        do {
            try managedContext.save()
            adventurers.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
 */


    }
    
    var newPerson:NSManagedObject? = nil
    
    // This method lets you configure a view controller before it's presented.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIButton, button == saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        

        // Set the meal to be passed to MealTableViewController after the unwind segue.
        newPerson = save(name: nameTextField.text!, profession: classTextField.text!)
    }
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        adventurerImage.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}

