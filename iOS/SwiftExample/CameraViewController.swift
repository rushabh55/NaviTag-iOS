
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
    
    //pragma mark - Camera
    
    @IBAction func onAddHuntDone(sender: AnyObject) {
        
        // http://rushg.me/TreasureHunt/hunt.php?q=addHunt&name=first&image=&hint&coordinates=VARCHAR&created_user=int&count_finish_users=int
        var bodyData = "q=addHunt&hint=" + hintView.text
        
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
        mangleButton.highlighted = true
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        self.savedImage()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func savedImage()
    {
        var alert:UIAlertView = UIAlertView()
        alert.title = "Saved!"
        alert.message = "Your picture was saved to Camera Roll"
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
