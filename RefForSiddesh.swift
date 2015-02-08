
import UIKit
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
//    
    @IBOutlet var backgroundImage:UIImageView?
    @IBOutlet weak var imageControl: UIImageView!
    var cameraUI:UIImagePickerController = UIImagePickerController()
    @IBOutlet weak var pickButton: UIButton!
    
    @IBOutlet weak var hintView: UITextField!
    @IBOutlet weak var radioButton: UISegmentedControl!
    
    @IBOutlet weak var mangleButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        staticTextView.allowsEditingTextAttributes = false
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    //pragma mark - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cameraShow()
    {
        self.presentCamera()
    }
    // MARK : Image Serialization
    //pragma mark - Camera
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

    
    @IBAction func onAddHuntDone(sender: AnyObject) {
        
        // http://rushg.me/TreasureHunt/hunt.php?q=addHunt&name=first&image=&hint&coordinates=VARCHAR&created_user=int&count_finish_users=int
        var selected : Bool = false
        if radioButton.selectedSegmentIndex == 1 {
            selected = true
        }
        else {
            selected = false
        }
        let img = CIImage(image: imageControl.image)
        
        var bodyData = "q=addHunt&hint=" + hintView.text + "show_user" + selected.description
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
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        self.savedImage()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func savedImage()
    {
        var alert:UIAlertView = UIAlertView()
        alert.title = "Awesome!"
        alert.message = "Now Mangle this image!"
        alert.delegate = self
        alert.addButtonWithTitle("Awesome")
        alert.show()
    }
    
    @IBAction func onMangleClick(sender: AnyObject) {
        let beginImage =  CIImage(image: imageControl.image)
   
        let filter = CIFilter(name: "CISepiaTone")
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        filter.setValue(0.5, forKey: kCIInputIntensityKey)
        let newImage = UIImage(CIImage: filter.outputImage)
        imageControl.image = newImage
    }
    
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int)
    {
        NSLog("Did dismiss button: %d", buttonIndex)
       // self.presentCamera()
    }
}
