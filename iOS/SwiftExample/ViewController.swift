
import UIKit

class ViewController: UIViewController {
    
//    var imageView:UIImageView = UIImageView()
//    var backgroundDict:Dictionary<String,String> = Dictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let width:CGFloat = 320;
//        let height:CGFloat = 568

        self.title = "Hunt"

//        backgroundDict = ["HomeBackground":"HomeBackground"]
        
//        var view:UIView = UIView(frame: CGRectMake(0,0,width,height))
//        self.view.addSubview(view)

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "HomeBackground.png")!)
        
//        var backgroundImage:UIImage = UIImage(named: backgroundDict["HomeBackground"]!)!

//        imageView.image = backgroundImage;
//        view.addSubview(imageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

