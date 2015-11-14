//
//  SettingsViewController.swift
//  Reached
//
//  Created by Laikh Tewari on 10/26/15.
//  Copyright © 2015 Laikh Tewari. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var showFavoriteAtStartSwitch: UISwitch!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var showTutorialAtStartSwitch: UISwitch!
    
    let myDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)
        
        if let name = myDefaults.objectForKey("name") as? String
        {
            nameTextField.text = name
        }
        if let phoneNumber = myDefaults.objectForKey("phoneNumber") as? String
        {
            phoneNumberTextField.text = phoneNumber
        }
        if let address = myDefaults.objectForKey("address") as? String
        {
            addressTextField.text = address
        }
        
        if let favoriteSwitchEnabled = myDefaults.objectForKey("favoriteShowStart") as? Bool
        {
            showFavoriteAtStartSwitch.on = favoriteSwitchEnabled
            
            if !showFavoriteAtStartSwitch.on
            {
                nameTextField.enabled = false
                addressTextField.enabled = false
                phoneNumberTextField.enabled = false
            }
        }
        else
        {
            myDefaults.setObject(false, forKey: "favoriteShowStart")
            showFavoriteAtStartSwitch.on = false
        }
        
        if let tutorialAtStart = myDefaults.objectForKey("tutorialAtStart") as? Bool
        {
            showTutorialAtStartSwitch.on = tutorialAtStart
        }
        else
        {
            myDefaults.setObject(false, forKey: "tutorialAtStart")
            showTutorialAtStartSwitch.on = false
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func favoriteAtStartSwitched(sender: AnyObject)
    {
        let enabled = showFavoriteAtStartSwitch.on
        if enabled
        {
            nameTextField.enabled = true
            addressTextField.enabled = true
            phoneNumberTextField.enabled = true
        }
        else
        {
            nameTextField.enabled = false
            addressTextField.enabled = false
            phoneNumberTextField.enabled = false
        }
        myDefaults.setObject(enabled, forKey: "favoriteShowStart")
    }
    
    @IBAction func tutorialAtStartSwitched(sender: AnyObject)
    {
        let enabled = showTutorialAtStartSwitch.on
        myDefaults.setObject(enabled, forKey: "tutorialAtStart")
    }
    
    func didTapView()
    {
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
