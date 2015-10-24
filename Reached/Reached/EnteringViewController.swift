//
//  EnteringViewController.swift
//  Reached
//
//  Created by Laikh Tewari on 10/16/15.
//  Copyright © 2015 Laikh Tewari. All rights reserved.
//

import UIKit

class EnteringViewController: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)

        // Do any additional setup after loading the view.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let destinationViewController: MapViewController = segue.destinationViewController as! MapViewController
        destinationViewController.address = self.addressTextField.text
        destinationViewController.phoneNumber = self.phoneTextField.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goButtonClicked(sender: AnyObject)
    {
        
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