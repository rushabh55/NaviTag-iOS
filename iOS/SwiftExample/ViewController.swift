
import UIKit
import SpriteKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    let fieldMask : UInt32 = 0b1;
    
    
    let categoryMask: UInt32 = 0b1;
    var name = String()
    
    func setupTimerInterface() {
    }
    let counter = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimerInterface()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
      
                var coordinates:CLLocationCoordinate2D =  CLLocationCoordinate2DMake(appDelegate.lat, appDelegate.long)
                
                var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = coordinates
                pointAnnotation.title = "You are here!\n" + appDelegate.userName
                
                self.map?.addAnnotation(pointAnnotation)
                self.map?.centerCoordinate = coordinates
                self.map?.selectAnnotation(pointAnnotation, animated: true)
                self.map?.zoomEnabled = true
                let mapCoord = coordinates
                var mapCamera = MKMapCamera(lookingAtCenterCoordinate: mapCoord, fromEyeCoordinate: mapCoord, eyeAltitude: 1000)
                self.map?.setCamera(mapCamera, animated: true)
                
        
            
    

        
        
        
        if  appDelegate.userName == ""
        {
            
        var alert = UIAlertController(title: "Tell us your name",
            message: "Add a new name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction!) -> Void in
                var t = alert.textFields![0] as UITextField
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                appDelegate.userName = t.text
                self.name = t.text
                if self.name != "" {
                    let url: NSURL = NSURL(string: "http://rushg.me/TreasureHunt/User.php?q=addUser&username=" + self.name)!
                    debugPrint(url)
                    let request = NSURLRequest(URL: url)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())       {(response, data, error) in
                        debugPrint(NSString(data: data, encoding: NSUTF8StringEncoding))
                    }
                }
                
                
               // NSUserDefaults.setValue( t.text, forKey: "userName")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        }
        
        self.title = "Hunt"
    }
    
    @IBOutlet weak var map: MKMapView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

