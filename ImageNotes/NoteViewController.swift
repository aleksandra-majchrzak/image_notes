//
//  NoteViewController.swift
//  ImageNotes
//
//  Created by Mohru on 12/30/16.
//  Copyright © 2016 Mohru. All rights reserved.
//

import UIKit

protocol NoteChangedDelegate: class{
    func noteChanged(editedNote: Note)
    func deleteNote(noteToDelete: Note)
}

class NoteViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var textTextView: UITextView!
    
    @IBOutlet weak var image: UIImageView!
    
    weak var delegate: NoteChangedDelegate?
    
    var note: Note!{
        didSet(newNote){
            self.refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if note != nil{
            refreshUI()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshUI() {
        if note != nil{
            titleLabel.isHidden = false
            dateLabel.isHidden = false
            textTextView.isHidden = false
            image.isHidden = false

            titleLabel?.text = note.title
            dateLabel?.text = note.date
            textTextView?.text = note.text
        
            if note.image != nil{
                image?.image = note.getImage()
            }
            else {
                image?.image = nil
            }
        }
        else{
            titleLabel.isHidden = true
            dateLabel.isHidden = true
            textTextView.isHidden = true
            image.isHidden = true
        }
        
    }
    
    @IBAction func editNote(_ sender: Any) {
        
        if note != nil{
            let vc: AddNoteViewController  = self.storyboard?.instantiateViewController(withIdentifier: "addNoteId") as! AddNoteViewController
            vc.editDelegate = self
            vc.note = self.note
            vc.modalTransitionStyle =  UIModalTransitionStyle.flipHorizontal
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func deleteNote(_ sender: Any) {
        if note != nil{
            
            let alert = UIAlertController(title: NSLocalizedString("Delete_note", comment: "") ,
                                          message: NSLocalizedString("Are_you_sure_to_delete_this_note", comment:""),
                                          preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""),
                                             style: .default) {
                                                
                                                [unowned self] action in
                                                
                                                self.delegate?.deleteNote(noteToDelete: self.note)
                                                self.note = nil
                                                
                                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                
                                                if (appDelegate.splitViewController?.isCollapsed)!{
                                                    self.navigationController?.popToRootViewController(animated: true)
                                                }
                                                
            }
            
            let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""),
                                         style: .default)

            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            present(alert, animated: true)

        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NoteViewController: NoteSelectionDelegate{
    func noteSelected(newNote: Note) {
        note = newNote
    }
}

extension NoteViewController: EditNoteControllerDelegate{
    func saveEditedNote(note: Note){
        
        self.note = note
        delegate?.noteChanged(editedNote: note)
        
    }
}
