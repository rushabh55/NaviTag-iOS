
import UIKit
import CoreLocation
import MobileCoreServices

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate {
    
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//        println("i've got an image");
//    }
//    
//    @IBAction func capture(sender : UIButton) {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
//            println("Button capture")
//            
//            var imag = UIImagePickerController()
//            imag.delegate = self
//            imag.sourceType = UIImagePickerControllerSourceType.Camera;
//            imag.mediaTypes = [kUTTypeImage]
//            imag.allowsEditing = false
//            
//            self.presentViewController(imag, animated: true, completion: nil)
//        }
//    }
    @IBOutlet weak var blurSlider: UISlider!
//    
    
    @IBOutlet var backgroundImage:UIImageView?
    @IBOutlet weak var imageControl: UIImageView!
    var cameraUI:UIImagePickerController = UIImagePickerController()
    @IBOutlet weak var pickButton: UIButton!
    
    @IBOutlet weak var hintView: UITextField!
    @IBOutlet weak var radioButton: UISegmentedControl!
    
    @IBOutlet weak var mangleButton: UIButton!
    let scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
//    var locManager : CLLocationManager = CLLocationManager();
    
    var loc : LocationManager = LocationManager();
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        staticTextView.allowsEditingTextAttributes = false
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

    //pragma mark - View
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.view = self.scrollView
        
        // setup the scroll view
        self.scrollView.contentSize = CGSize(width:1234, height: 5678)
        let sampleSubView = UIView()
        self.view.addSubview(sampleSubView) // adds to the scroll view
        
        self.scrollView.contentOffset = CGPoint(x: 10, y: 20)
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cameraShow()
    {
        self.presentCamera()
    }
    
    //pragma mark - Camera
    
    @IBAction func onAddHuntDone(sender: AnyObject) {
        
        // http://rushg.me/TreasureHunt/hunt.php?q=addHunt&name=first&image=&hint&coordinates=VARCHAR&created_user=int&count_finish_users=int
        var bodyData = "q=addHunt&hint=" + hintView.text + loc.getLat().description + "," + loc.getLong().description
        
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
}
