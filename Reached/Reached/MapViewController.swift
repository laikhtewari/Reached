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

class MapViewController: UIViewController, CLLocationManagerDelegate
{
    var name: String!
    var address: String!
    var phoneNumber: String!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
        } else {
            locationManager.startUpdatingLocation()
        }

        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address)
            { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if let error = error
                {
                    print(error)
                }
                else
                {
                    if let placemark = placemarks?[0]
                    {
                        self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                        let myRegion = MKCoordinateRegionMakeWithDistance(placemark.location!.coordinate, 1500, 1500)
                        self.mapView.setRegion(myRegion, animated: true)
                        let myCircularRegion = CLCircularRegion(center: placemark.location!.coordinate, radius: 200, identifier: "myFirstGeofence")
                        self.locationManager.startMonitoringForRegion(myCircularRegion)
                        let myCircle = MKCircle(centerCoordinate: placemark.location!.coordinate, radius: myCircularRegion.radius)
                        self.mapView.addOverlay(myCircle)
                    }
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func regionMonitoring()
    {
        
        let currentRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 37.453263, longitude: -122.191283), radius: 100, identifier: "School")
        
        locationManager.startMonitoringForRegion(currentRegion)
    }
    

    @IBAction func backButtonTapped(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let errorAlert = UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK")
        errorAlert.show()
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("ENTERED REGION")
        let myEntryMessage = "\(name) has arrived at \(address)."
        textWithMessage(myEntryMessage)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("EXITED REGION")
        let myExitMessage = "\(name) has left \(address)."
        textWithMessage(myExitMessage)
    }
    
    func textWithMessage( message: String )
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://textbelt.com/text")!)
        request.HTTPMethod = "POST"
        let postString = "number=" + phoneNumber! + "&message=" + message
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in

            print("RESPONSE = \(response)")
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
}

