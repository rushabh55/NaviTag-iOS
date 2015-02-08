
import UIKit
import CoreLocation
import Foundation
import MobileCoreServices


    

class CameraViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var blurSlider: UISlider!
    @IBOutlet var backgroundImage:UIImageView?
    @IBOutlet weak var imageControl: UIImageView!
    @IBOutlet weak var pickButton: UIButton!
    @IBOutlet weak var hintView: UITextField!
    @IBOutlet weak var radioButton: UISegmentedControl!
    @IBOutlet weak var mangleButton: UIButton!

    let scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)

    
    var cameraUI:UIImagePickerController = UIImagePickerController()

    var locationManager: CLLocationManager!
    
    var myLong: Double = 0.0
    var myLat: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        scrollView.addSubview(self.view)
        scrollView.contentSize = self.view.bounds.size
        scrollView.delegate = self
        scrollView.indicatorStyle = .White
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
  
    func getFilterName() -> String{
        let rand = arc4random()
        let dict = ["CIMaskedVariableBlur", "CISepiaTone", "CIBloom", "CINoiceReduction"]
        let c = UInt32(dict.count)
        var i = Int(rand % c)
        var res =  dict[i]
        debugPrint(res)
        return res
    }
    
    //pragma mark - Vie
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        /* Gets called when user scrolls or drags */
        scrollView.alpha = 0.50
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        /* Gets called only after scrolling */
        scrollView.alpha = 1
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!,
        willDecelerate decelerate: Bool){
            scrollView.alpha = 1
    }
    
    
    // MARK: - CoreLocation Delegate Methods
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
        println("locationManager auth status changed, \(str)")
        
        if( status == .Authorized || status == .AuthorizedWhenInUse ) {
            locationManager.startUpdatingLocation()
            println("startUpdatingLocation")
        }
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("found \(locations.count) placemarks.")
        if( locations.count > 0 ){
            let location = locations[0] as CLLocation;
            locationManager.stopUpdatingLocation()
            //self.L1 = location
            myLong = location.coordinate.latitude
            myLat = location.coordinate.longitude
            println("location updated, lat:\(location.coordinate.latitude), lon:\(location.coordinate.longitude), stop updating.")
            
        }

    }
    
    @IBAction func cameraShow()
    {
        self.presentCamera()
    }
    
    @IBAction func onAddHuntDone(sender: AnyObject) {
        
        // http://rushg.me/TreasureHunt/hunt.php?q=addHunt&name=first&image=&hint&coordinates=VARCHAR&created_user=int&count_finish_users=int
        var bodyData = "q=addHunt&hint=" + hintView.text + self.myLat.description + "," + self.myLong.description 
        
        let URL: NSURL = NSURL(string: "http://rushg.me/TreasureHunt/hunt.php?")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
        {
                (response, data, error) in
                debugPrint(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        
    }
    
    func mimeTypeForPath(path: String) -> String {
        let pathExtension = path.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as NSString
            }
        }
        return "application/octet-stream";
    }
    
    func createBodyWithParameters(request : NSMutableURLRequest) -> NSData {
        let boundary = "----------SwIfTeRhTtPrEqUeStBoUnDaRy"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField:"Content-Type")
        var body = NSMutableData();
        
        
        let tempData = NSMutableData()
        let fileName = imageControl.image
        let parameterName = "userfile"
        
        var imageData :NSData = UIImageJPEGRepresentation(fileName, 1.0);
        let mimeType = "application/octet-stream"
        
        tempData.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        let fileNameContentDisposition = fileName != nil ? "filename=\"\(fileName)\"" : ""
        let contentDisposition = "Content-Disposition: form-data; name=\"\(parameterName)\"; \(fileNameContentDisposition)\r\n"
        tempData.appendData(contentDisposition.dataUsingEncoding(NSUTF8StringEncoding)!)
        tempData.appendData("Content-Type: \(mimeType)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        tempData.appendData(imageData)
        tempData.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData(tempData)
        
        body.appendData("\r\n--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        return body
    }
    
    func presentCamera()
    {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.PhotoLibrary //camera
        cameraUI.mediaTypes = [kUTTypeImage]
        cameraUI.allowsEditing = false
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
    }
    @IBOutlet weak var staticTextView: UITextField!
    
    //pragma mark- Image
    @IBAction func onEditBegin(sender: AnyObject) {
        staticTextView.text = "Show your name"
    
    }
    
    @IBOutlet weak var navigationControl: UINavigationItem!
    func imagePickerControllerDidCancel(picker:UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker:UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary)
    {
//        var mediaType:NSString = info.objectForKey(UIImagePickerControllerEditedImage) as NSString
        var imageToSave:UIImage
        
        imageToSave = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        imageControl.image = imageToSave
        pickButton.hidden = true
        mangleButton.hidden = false
        blurSlider.hidden = false
        mangleButton.highlighted = true
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        self.savedImage()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func savedImage()
    {
        var alert:UIAlertView = UIAlertView()
        alert.title = "Saved!"
        alert.message = "Now hit the Magic Wand to see the Magic"
        alert.delegate = self
        alert.addButtonWithTitle("Awesome")
        alert.show()
    }
    
    @IBAction func onMangleClick(sender: AnyObject) {
        let beginImage =  CIImage(image: imageControl.image)
        let filter = CIFilter(name: getFilterName())
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        var val = blurSlider.value
        filter.setValue(val, forKey: kCIInputIntensityKey)
        let newImage = UIImage(CIImage: filter.outputImage)
        imageControl.image = newImage
        blurSlider.hidden = true
        mangleButton.hidden = true
    }
    
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int)
    {
        NSLog("Did dismiss button: %d", buttonIndex)
       // self.presentCamera()
    }
    
}
