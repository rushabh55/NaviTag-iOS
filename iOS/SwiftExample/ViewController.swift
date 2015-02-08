
import UIKit
import SpriteKit

class ViewController: UIViewController {
    let fieldMask : UInt32 = 0b1;
    let categoryMask: UInt32 = 0b1;
    
    var fieldNode: SKFieldNode = SKFieldNode();
    var shapeEmitterTuples : [(SKShapeNode,SKEmitterNode)] = [];
//    var imageView:UIImageView = UIImageView()
//    var backgroundDict:Dictionary<String,String> = Dictionary()
    func setupTimerInterface() {
        //var timer = NSTimer()
           var timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    let counter = Int()
    func update() {
        //debugPrint("counter " + counter.description)
        counter.advancedBy(100)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimerInterface()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
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
        // Do any additional setup after loading the view, typically from a nib.
//        let width:CGFloat = 320;
//        let height:CGFloat = 568
//        let shape = SKShapeNode(circleOfRadius : 20)
//        shape.physicsBody = SKPhysicsBody(circleOfRadius: 20)
//        shape.physicsBody?.friction = 0
//        shape.physicsBody?.charge = 4
//        let untypedEmitter : AnyObject = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("Particle", ofType: "sks")!)!;
//        
//        
//        let emitter:SKEmitterNode = untypedEmitter as SKEmitterNode;
//        var shapeEmitterTuples : [(SKShapeNode,SKEmitterNode)];
//        
//        
//        let shapeEmitterTuple = (shape, emitter)
//        shapeEmitterTuples = [shapeEmitterTuple]
//        for (shape, emitter) in shapeEmitterTuples
//        {
//            emitter.particlePosition = shape.position;
//            
//        }
        
        self.title = "Hunt"

//        backgroundDict = ["HomeBackground":"HomeBackground"]
        
//        var view:UIView = UIView(frame: CGRectMake(0,0,width,height))
//        self.view.addSubview(view)

        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "HomeBackground.png")!)
        
//        var backgroundImage:UIImage = UIImage(named: backgroundDict["HomeBackground"]!)!

//        imageView.image = backgroundImage;
//        view.addSubview(imageView)
        shapeEmitterTuples = [];
        self.fieldNode = SKFieldNode.radialGravityField();
        fieldNode.falloff = 0.5;
        fieldNode.animationSpeed = 0.5;
        fieldNode.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        fieldNode.categoryBitMask = categoryMask;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

