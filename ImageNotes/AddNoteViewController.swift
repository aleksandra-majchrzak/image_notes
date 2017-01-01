//
//  AddNoteViewController.swift
//  ImageNotes
//
//  Created by Mohru on 1/1/17.
//  Copyright © 2017 Mohru. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddNoteViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate{

    var delegate:AddNoteViewControllerDelegate!
    var editDelegate: EditNoteControllerDelegate!
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    
    @IBOutlet weak var noteDateLabel: UILabel!
    
    @IBOutlet weak var noteTextTextView: UITextView!
    
    @IBOutlet weak var noteImageView: UIImageView!
    
    var noteTitle: String?
    
    var note: Note?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        noteTextTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        noteTextTextView.layer.borderWidth = 0.5
        noteTextTextView.layer.cornerRadius = 5.0
        
        
        if note == nil {
            noteTitleTextField?.text = noteTitle
        
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy"
            let dateString = formatter.string(from: currentDate)
        
            noteDateLabel?.text = dateString
        }
        else {
            noteTitleTextField.text = note?.title
            noteDateLabel.text = note?.date
            noteTextTextView.text = note?.text
            noteImageView.image = note?.getImage()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func saveNote(_ sender: UIBarButtonItem) {
        
        if note == nil {
            let title = noteTitleTextField.text
            let text = noteTextTextView.text
            let image = noteImageView.image
            let date = noteDateLabel.text
        
            var imageData : Data?
            
            if image != nil{
                imageData = UIImagePNGRepresentation(image!)
            }
            else{
                imageData = nil
            }

            delegate.savePressedInAddNote(title: title!, date: date!, text: text!, image: imageData as NSData?)
        }
        else {
            
            note?.title = noteTitleTextField.text
            note?.date = noteDateLabel.text
            note?.text = noteTextTextView.text
            
            let image = noteImageView.image
            
            if image != nil{
                note?.image = UIImagePNGRepresentation(image!) as NSData?
            }
            else{
                note?.image = nil
            }
            
            editDelegate.saveEditedNote(note: note!)
        }
        
        super.dismiss(animated: true,completion:nil)
    }
    
    @IBAction func chooseImage(_ sender: UIBarButtonItem) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.mediaTypes = [kUTTypeImage as String]
            imagePickerController.isEditing = false
        }else{
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(imagePickerController, animated: true, completion: nil)

        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        noteImageView.image = selectedImage
        // self.note?.image = selectedImage
        super.dismiss(animated: true , completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        super.dismiss(animated: true,completion:nil)
    }
    

}

protocol AddNoteViewControllerDelegate{
    func savePressedInAddNote(title: String, date: String, text: String, image: NSData?)
}

protocol EditNoteControllerDelegate{
    func saveEditedNote(note: Note)
}
