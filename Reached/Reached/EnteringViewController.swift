//
//  EnteringViewController.swift
//  Reached
//
//  Created by Laikh Tewari on 10/16/15.
//  Copyright © 2015 Laikh Tewari. All rights reserved.
//

import UIKit

class EnteringViewController: UIViewController {

    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    override func viewDidLoad()
    {
        if let tutorial = UserDefaults.standard.value(forKey: "tutorial") as? Bool
        {
            if tutorial
            {
                //DO TUTORIAL
            }
        }
        else
        {
            //DO TUTORIAL
            UserDefaults.standard.setValue(false, forKey: "tutorial")
        }
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(EnteringViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    
        if let favoriteShowStart = UserDefaults.standard.value(forKey: "favoriteShowStart") as? Bool
        {
            if favoriteShowStart
            {
                if let name = UserDefaults.standard.value(forKey: "name") as? String
                {
                    self.nameTextField.text = name
                }
                if let phoneNumber = UserDefaults.standard.value(forKey: "phoneNumber") as? String
                {
                    self.phoneTextField.text = phoneNumber
                }
                if let address = UserDefaults.standard.value(forKey: "address") as? String
                {
                    self.addressTextField.text = address
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let name = UserDefaults.standard.value(forKey: "name") as? String
        {
            self.nameTextField.text = name
        }
        if let phoneNumber = UserDefaults.standard.value(forKey: "phone") as? String
        {
            self.phoneTextField.text = phoneNumber
        }
        if let address = UserDefaults.standard.value(forKey: "address") as? String
        {
            self.addressTextField.text = address
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ToMap"
        {
//            defaults.setObject(nameTextField.text, forKey: "name")
//            defaults.setObject(phoneTextField.text, forKey: "phoneNumber")
//            defaults.setObject(addressTextField.text, forKey: "address")
        
            let destinationViewController = segue.destination as! MapViewController
            destinationViewController.address = self.addressTextField.text
            destinationViewController.phoneNumber = self.phoneTextField.text
            destinationViewController.name = self.nameTextField.text
        } else if segue.identifier == "ToSettings"
        {
            //Into settings
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "ToMap", sender: self)
    }
    
    func didTapView()
    {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}
