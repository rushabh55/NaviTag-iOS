//
//  This code is copied from another code I was working on, which is a part of another project. Use this as reference, and create new class
// TODO: Create new class, copy contents of this file into that one and link UI to this.

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {

    
    
    // Usual Stuff
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // End of usual stuff
    
    
    @IBOutlet weak var textBox: UITextField!
    var locManager : CLLocationManager = CLLocationManager();

    @IBAction func OnTapped(sender: AnyObject) {
            let t = LocationManager()
            t.initialize()
            textBox.text = t._lat.description + "  " + t._long.description
    }
    
    
    @IBAction func onSendClick(sender: AnyObject) {
        let http = NSURL ( fileURLWithPath: NSString ( string: "http://rushg.me/TreasureHunt/User.php?q=AddUser&username=" + "as" ))
        let req = NSURLRequest( URL: http! )
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue()) {(response, data, error) in println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
    }
    @IBOutlet weak var sendButton: UIButton!
}

//Helper class to get shit done. 
class LocationManager : NSObject, CLLocationManagerDelegate {

    override func isEqual(anObject: AnyObject?) -> Bool {
        return super.isEqual(anObject)
    }
    
    var _lat : CLLocationDegrees = CLLocationDegrees()
    var _long : CLLocationDegrees = CLLocationDegrees()
    
    func getLat() -> CLLocationDegrees{
        return self._lat
    }
    
    func getLong() -> CLLocationDegrees {
        return self._long
    }
    var _manager : CLLocationManager = CLLocationManager()
    
    func initialize() {
        _manager = CLLocationManager()
        _manager.delegate = self
        _manager.desiredAccuracy = kCLLocationAccuracyBest
        _manager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(_manager.location, completionHandler: {(placemarks, error) -> Void in
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                var t : CLPlacemark = pm
                self._lat = t.location.coordinate.latitude
                self._long = t.location.coordinate.longitude
            }
            else {
                debugPrint(error)
            }
        })
    }
    
}


// TODO :
//  1 )Show request to user about the location permissions
//  2 )specify the URL in string and non-URI format. 
