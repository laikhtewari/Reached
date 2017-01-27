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
    
    var geofenceRadius = 75
    
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
        
        if let radius = UserDefaults.standard.value(forKey: "radius") {
            self.geofenceRadius = Int(radius as! Float)
        }

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
                    self.addressLabel.text = placemark.name
                    
                    let myRegion = MKCoordinateRegionMakeWithDistance(placemark.location!.coordinate, 500, 500)
                    self.mapView.setRegion(myRegion, animated: true)
                    
                    self.region = CLCircularRegion(center: placemark.location!.coordinate, radius: CLLocationDistance(self.geofenceRadius), identifier: "myFirstGeofence")
                    
                    let myCircle = MKCircle(center: placemark.location!.coordinate, radius: CLLocationDistance(self.geofenceRadius))
                    self.mapView.add(myCircle)
                    
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
    
    
    func textWithMessageTextbelt( _ message: String )
    {
        
        //Textbelt
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
    }
    
    func textWithMessage(_ message: String) {
        let twilioSID = "ACf0b6b8965d96aaae85a497897bcb475f"
        let twilioSecret = "c7857cde401d1e2585aff93924221f22"
        
        let fromNumber = "%2B12017204289"
        let toNumber = "%2B1" + (phoneNumber as String)
        
        var request = URLRequest(url: URL(string: "https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")!)
        request.httpMethod = "POST"
        request.httpBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            print("Finished")
            if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                // Success
                print("Response: \(responseDetails)")
            } else {
                // Failure
                print("Error: \(error)")
            }
        }).resume()
    }
}

extension MapViewController
{
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("ENTERED REGION")
        let myEntryMessage = "\(name as String) has reached \(address as String)."
        textWithMessage(myEntryMessage)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("EXITED REGION")
        let myExitMessage = "\(name as String) has left \(address as String)."
        textWithMessage(myExitMessage)
        locationManager.stopMonitoring(for: self.region)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        if let overlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.fillColor = UIColor(red:0.00, green:1.00, blue:0.81, alpha:0.4)
            circleRenderer.strokeColor = UIColor(red:0.00, green:1.00, blue:0.81, alpha:0.75)
            circleRenderer.lineWidth = 5
            return circleRenderer
        } else {
            return MKOverlayRenderer()
        }
    }
}

