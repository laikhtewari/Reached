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
import Parse

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
    @IBOutlet weak var mapView: MKMapView!
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        if self.name.isEmpty || self.address.isEmpty || self.phoneNumber.isEmpty
        {
            let errorAlert = UIAlertView(title: "Error", message: "Please fill in all spaces", delegate: nil, cancelButtonTitle: "OK")
            errorAlert.show()
            self.dismissViewControllerAnimated(true, completion: nil)
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
                        self.region = CLCircularRegion(center: placemark.location!.coordinate, radius: 500, identifier: "myFirstGeofence")
                        self.circle = MKCircle(centerCoordinate: placemark.location!.coordinate, radius: 500)
                        self.mapView.addOverlay(self.circle as MKOverlay)
                        self.locationManager.startMonitoringForRegion(self.region)
//                        let myCircle = MKCircle(centerCoordinate: placemark.location!.coordinate, radius: myCircularRegion.radius)
//                        self.mapView.addOverlay(myCircle)
                    }
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButtonTapped(sender: AnyObject)
    {
        if let region = self.region
        {
            locationManager.stopMonitoringForRegion(region)
        }
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
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//    }
//    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
////        let errorAlert = UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "OK")
////        errorAlert.show()
//    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("ENTERED REGION")
        let myEntryMessage = "\(name) has reached \(address)."
        textWithMessage(myEntryMessage)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("EXITED REGION")
        let myExitMessage = "\(name) has left \(address)."
        textWithMessage(myExitMessage)
        locationManager.stopMonitoringForRegion(self.region)
    }

    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        return self.circleRenderer
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
            
//            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            if let error = error {
//                let myAlert = UIAlertView(title: "Error", message: "Unable to send message: \(error)", delegate: nil, cancelButtonTitle: "OK")
//                myAlert.show()
//            }
//            else {
//                let myAlert = UIAlertView(title: "Success", message: "Message sent", delegate: nil, cancelButtonTitle: "OK")
//                myAlert.show()
//            }
            
        }
        task.resume()
        
        let pushQuery = PFInstallation.query()!
        pushQuery.whereKey("deviceToken", equalTo: defaults.objectForKey("deviceToken")!)
        let push = PFPush()
        let data = ["alert" : "Message sent"]
        push.setQuery(pushQuery)
        push.setData(data)
        push.sendPushInBackground()
    }
}

