//
//  SettingsViewController.swift
//  Reached
//
//  Created by Laikh Tewari on 1/26/17.
//  Copyright © 2017 Laikh Tewari. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var geofenceRadiusLabel: UILabel!
    @IBOutlet weak var geofenceRadiusSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let radius = defaults.value(forKey: "radius") {
            self.geofenceRadiusLabel.text = String(radius as! Float)
            self.geofenceRadiusSlider.setValue(radius as! Float, animated: false)
        } else {
            print("ERROR: NO PRESET RADIUS")
            defaults.setValue(Float(75), forKey: "radius")
            self.geofenceRadiusLabel.text = String(75)
            self.geofenceRadiusSlider.setValue(75, animated: false)
        }
    
        
        if let name = defaults.value(forKey: "name") {
            nameField.text = name as? String
        }
        
        if let phone = defaults.value(forKey: "phone") {
            phoneField.text = phone as? String
        }
        
        if let address = defaults.value(forKey: "address") {
            addressField.text = address as? String
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(EnteringViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func radiusChanged(_ sender: Any) {
        geofenceRadiusLabel.text = String(geofenceRadiusSlider.value)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func save(_ sender: Any) {
        defaults.setValue(nameField.text, forKey: "name")
        defaults.setValue(phoneField.text, forKey: "phone")
        defaults.setValue(addressField.text, forKey: "address")
        defaults.setValue(geofenceRadiusSlider.value, forKey: "radius")
        backButtonTapped(sender as! AnyObject)
    }
    
    @IBAction func backButtonTapped(_ sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
