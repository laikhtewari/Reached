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
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad()
    {
//        self.phoneTextField.hidden = true
//        self.nameTextField.hidden = true
//        self.addressTextField.hidden = true
//        self.goButton.hidden = true
//        
//        self.phoneTextField.
        
        super.viewDidLoad()
            
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)
    
        if let name = defaults.objectForKey("name") as? String
        {
            self.nameTextField.text = name
        }
        if let phoneNumber = defaults.objectForKey("phoneNumber") as? String
        {
            self.phoneTextField.text = phoneNumber
        }
        if let address = defaults.objectForKey("address") as? String
        {
            self.addressTextField.text = address
        }

        // Do any additional setup after loading the view.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        defaults.setObject(nameTextField.text, forKey: "name")
        defaults.setObject(phoneTextField.text, forKey: "phoneNumber")
        defaults.setObject(addressTextField.text, forKey: "address")
        
        let destinationViewController: MapViewController = segue.destinationViewController as! MapViewController
        destinationViewController.address = self.addressTextField.text
        destinationViewController.phoneNumber = self.phoneTextField.text
        destinationViewController.name = self.nameTextField.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        // Pass the selected object to the new view controlle
    }
    */

}
