
import UIKit
import CoreLocation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate{
    
    var window: UIWindow?
    
    var userName = String()
    var lat : Double = Double()
    var long : Double = Double()
    
    var locationManager: CLLocationManager!
    var myLong: Double = 0.0
    var myLat: Double = 0.0
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        println("start \(__FUNCTION__)")
        println("end \(__FUNCTION__)")
        return true
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            print(error)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var str: String
        switch(status){
        case .NotDetermined:       str = "NotDetermined"
        case .Restricted:          str = "Restricted"
        case .Denied:              str = "Denied"
        case .Authorized:          str = "Authorized"
        case .AuthorizedWhenInUse: str = "AuthorizedWhenInUse"
        }
        //println("locationManager auth status changed, \(str)")
        
        if( status == .Authorized || status == .AuthorizedWhenInUse ) {
            locationManager.startUpdatingLocation()
            println("startUpdatingLocation")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("found \(locations.count) placemarks.")
        if( locations.count > 0 ){
            let location = locations[0] as CLLocation;
            //locationManager.stopUpdatingLocation()
            //self.L1 = location
            myLong = location.coordinate.latitude
            myLat = location.coordinate.longitude
            println("location updated, lat:\(location.coordinate.latitude), lon:\(location.coordinate.longitude), stop updating.")
            
        }
        
    }
    
    
    func update() {
        if self.userName != "" {
            let url: NSURL = NSURL(string: "http://rushg.me/TreasureHunt/User.php?q=editUser&username=" + self.userName + "&location=" + myLat.description + "," + myLong.description)!
           // debugPrint(url)
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())       {(response, data, error) in
             //   debugPrint(NSString(data: data, encoding: NSUTF8StringEncoding))
            }
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        println("start \(__FUNCTION__)")
        println("end \(__FUNCTION__)")
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        println("start \(__FUNCTION__)")
        println("end \(__FUNCTION__)")
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        println("start \(__FUNCTION__)")
        println("end \(__FUNCTION__)")
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        println("start \(__FUNCTION__)")
        println("end \(__FUNCTION__)")
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        println("start \(__FUNCTION__)")
        println("end \(__FUNCTION__)")
        
    }
    
}

