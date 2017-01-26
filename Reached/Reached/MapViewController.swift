//
//  MapViewController.swift
//  Reached
//
//  Created by Laikh Tewari on 10/16/15.
//  Copyright © 2015 Laikh Tewari. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    var name: String!
    var address: String!
    var phoneNumber: String!
    let locationManager = CLLocationManager()
    var circleRenderer = MKCircleRenderer()
    var circle: MKCircle!
    var region: CLCircularRegion!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if self.name.isEmpty || self.address.isEmpty || self.phoneNumber.isEmpty
        {
            let alertController = UIAlertController(title: "Error", message: "Please fill in all spaces", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true) {
                // ...
            }
            
//            let errorAlert = UIAlertView(title: "Error", message: "Please fill in all spaces", delegate: nil, cancelButtonTitle: "OK")
//            errorAlert.show()
//            self.dismiss(animated: true, completion: nil)
        }
        
        
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        if #available(iOS 9.0, *) {
//            locationManager.requestLocation()
//        } else {
//            locationManager.startUpdatingLocation()
//        }
        
        addressLabel.text = address

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: Error?) in
            if let error = error {
                print(error)
                let alertController = UIAlertController(title: "Something went wrong...", message: "That's all we know. Try again", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true) {
                    // ...
                }
            } else {
                if let placemark = placemarks?[0]
                {
                    self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                    
                    let myRegion = MKCoordinateRegionMakeWithDistance(placemark.location!.coordinate, 1500, 1500)
                    self.mapView.setRegion(myRegion, animated: true)
                    
                    self.region = CLCircularRegion(center: placemark.location!.coordinate, radius: 500, identifier: "myFirstGeofence")
                    
                    let myCircle = MKCircle(center: placemark.location!.coordinate, radius: 500)
                    
                    self.locationManager.startMonitoring(for: self.region)
                }
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func backButtonTapped(_ sender: AnyObject)
    {
        if let region = self.region
        {
            print("STOPPED MONITORING")
            locationManager.stopMonitoring(for: region)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textWithMessage( _ message: String )
    {
        var request = URLRequest(url: URL(string: "https://textbelt.com/text")!)
        request.httpMethod = "POST"
        let postString = "number=" + phoneNumber! + "&message=" + message
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
//        let request = NSMutableURLRequest(url: URL(string: "https://textbelt.com/text")!)
//        request.httpMethod = "POST"
//        let postString = "number=" + phoneNumber! + "&message=" + message
//        request.httpBody = postString.data(using: String.Encoding.utf8)
//        let task = URLSession.shared.dataTask(with: request, completionHandler: {
//            data, response, error in
//
//            print("RESPONSE = \(response)")
//            
//            do
//            {
//                let jsonObject:AnyObject? = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//                
//                if let dictionary = jsonObject as? NSDictionary
//                {
//                    if let success = dictionary["success"]
//                    {
//                        if !(success as! Bool)
//                        {
//                            if let errorMessage = dictionary["message"]
//                            {
//                                let errorString = errorMessage as? String
//                                self.mixpanel.track("Error sending text", properties: ["error":errorString!])
//                            }
//                        }
//                        else
//                        {
//                            self.mixpanel.track("Message successfully sent")
//                        }
//                    }
//                }
//            }
//            catch let caught as NSError
//            {
//                self.mixpanel.track("Error sending text", properties: ["error" : caught.domain])
//            }
//            catch
//            {
//                self.mixpanel.track("Error sending text", properties: ["error" : "unexpected"])
//            }
//        
//        })        
//
//        task.resume()
    }
}

extension MapViewController
{
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("ENTERED REGION")
        let myEntryMessage = "\(name) has reached \(address)."
        textWithMessage(myEntryMessage)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("EXITED REGION")
        let myExitMessage = "\(name) has left \(address)."
        textWithMessage(myExitMessage)
        locationManager.stopMonitoring(for: self.region)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        return self.circleRenderer
    }
}

