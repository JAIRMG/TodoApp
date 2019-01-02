//
//  AddTodoViewController.swift
//  TodoApp
//
//  Created by Jair Moreno Gaspar on 12/27/18.
//  Copyright © 2018 Jair Moreno Gaspar. All rights reserved.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController {

    
    //MARK: Properties
    var managedContext: NSManagedObjectContext!
    var todo: Todo?
    
    //MARK: Outlets
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        
        textView.becomeFirstResponder()
        
        if let todo = self.todo {
            textView.text = todo.title
            segmentedControl.selectedSegmentIndex = Int(todo.priority)
        }
        
    }
    
    fileprivate func dismissAndResign() {
        dismiss(animated: true, completion: nil)
        textView.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismissAndResign()
    }
    
    @IBAction func done(_ sender: Any) {
        
        guard let title = textView.text, !title.isEmpty else {
            return
        }
        
        if let todo = self.todo {
            todo.title = title
            todo.priority = Int16(segmentedControl.selectedSegmentIndex)
            todo.date = Date()
        } else {
            let todo = Todo(context: managedContext)
            todo.title = title
            todo.priority = Int16(segmentedControl.selectedSegmentIndex)
            todo.date = Date()
        }
        
        do {
            try managedContext.save()
            dismissAndResign()
        } catch  {
            print("error saving \(error)")
        }
        
        
    }
    
    @objc func keyboardWillShow(notification: Notification){
        
        let key = "UIKeyboardFrameEndUserInfoKey"
        
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }


}


extension AddTodoViewController: UITextViewDelegate{
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if doneButton.isHidden {
            textView.text.removeAll()
            textView.textColor = UIColor.white
            
            doneButton.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    
}
