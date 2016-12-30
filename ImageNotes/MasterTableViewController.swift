//
//  MasterTableViewController.swift
//  ImageNotes
//
//  Created by Mohru on 12/30/16.
//  Copyright © 2016 Mohru. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewCell: UITableViewCell{
    
    @IBOutlet weak var noteTitle: UILabel!
    
    @IBOutlet weak var noteDate: UILabel!
    
    
}

class MasterTableViewController: UITableViewController {
    
    var notes: [Note] = []
    var managedContext: NSManagedObjectContext?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<Note>(entityName: "Note")
        
        do {
            notes = try managedContext!.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func addNote(_ sender: UIBarButtonItem) {
 
        let alert = UIAlertController(title: "New note",
                                      message: "Add a new note",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        
                                        guard let textField = alert.textFields?.first,
                                            let noteTitle = textField.text else {
                                                return
                                        }
                                        
                                        let currentDate = Date()
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "dd.MM.yy"
                                        let dateString = formatter.string(from: currentDate)
                                        
                                        self.save(title: noteTitle, date:dateString)
                                        self.tableView.reloadData()
 
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
     
      
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter note title"
        }
        //alert.addTextField { (textField : UITextField!) -> Void in
        //    textField.placeholder = "Enter note text"
        //}
        
     
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(title: String, date: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Note",
                                       in: managedContext!)!
        
        let note = Note(entity: entity,
                            insertInto: managedContext)
        
        note.title = title
        note.text = ""
        note.date = date
        note.image = nil
        
        do {
            try managedContext?.save()
            notes.append(note)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell

        // Configure the cell...
        cell.noteTitle.text = notes[indexPath.row].title
        cell.noteDate.text = notes[indexPath.row].date

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
