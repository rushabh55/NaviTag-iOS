//
//  ViewController.swift
//  IP
//
//  Created by Rushabh Gosar on 2/7/15.
//  Copyright (c) 2015 Rushabh Gosar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //struct for the Color
    typealias RawColorType = (newRedColor:UInt8, newgreenColor:UInt8, newblueColor:UInt8, newalphaValue:UInt8)
    
    
    @IBOutlet weak var imageControl: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onClick(sender: AnyObject) {
        // 1
        let fileURL = NSBundle.mainBundle().URLForResource("image", withExtension: "jpg")
        
        // 2
        let beginImage = CIImage(contentsOfURL: fileURL)
        
        // 3
        let filter = CIFilter(name: "CISepiaTone")
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        filter.setValue(0.5, forKey: kCIInputIntensityKey)
        
        // 4
        let newImage = UIImage(CIImage: filter.outputImage)
       // self.imageView.image = newImage
        imageControl.image = newImage
    }
    
    func getARGBBPerPixel(inImage : CGImageRef, context : CGContext, pixelWide : Int, point: CGPoint) -> UIColor{
        let rect = Rect(top: 10, left: 10, bottom: 10, right: 10)
        let data = CGBitmapContextGetData(context)
        let dataType = UnsafePointer<UInt8>(data)
        
        let offset = 4 * ((Int(pixelWide) * Int(point.y)) + Int(point.x))
        let alphaValue = dataType[offset]
        let redColor = dataType[offset+1]
        let greenColor = dataType[offset+2]
        let blueColor = dataType[offset+3]
        let redFloat = CGFloat(redColor)/255.0
        let greenFloat = CGFloat(greenColor)/255.0
        let blueFloat = CGFloat(blueColor)/255.0
        let alphaFloat = CGFloat(alphaValue)/255.0
        return UIColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: alphaFloat)
    }
    
    func setARGBBPerPixel(inImage : CGImageRef, context : CGContext, pixelsWide : UInt, pixelsHigh : UInt, point: CGPoint, color : RawColorType) -> UIImage{
        var data = CGBitmapContextGetData(context)
        var dataType = UnsafeMutablePointer<UInt8>(data)
        let offset = 4*((Int(pixelsWide) * Int(point.y)) + Int(point.x))
        dataType[offset] = color.newalphaValue
        dataType[offset+1] = color.newRedColor
        dataType[offset+2] = color.newgreenColor
        dataType[offset+3] = color.newblueColor
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        let finalcontext = CGBitmapContextCreate(data, pixelsWide, pixelsHigh, CUnsignedLong(8), CUnsignedLong(bitmapBytesPerRow), colorSpace, bitmapInfo)
        let imageRef = CGBitmapContextCreateImage(finalcontext)
        return UIImage(CGImage: imageRef)!
    }
    func createARGBBitmapContext(inImage: CGImageRef, point: CGPoint) -> CGContext {
        
        let pixelWide = CGImageGetWidth( inImage )
        let pixelHigh = CGImageGetHeight(inImage)
        
        let bitmapBytesPerRow = Int(pixelWide) * 4 // coz there are 4 channels
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelHigh)  // total pixels in matrix
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapData = malloc(CUnsignedLong(bitmapByteCount))
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        let context = CGBitmapContextCreate(bitmapData, pixelWide, pixelHigh, CUnsignedLong(8), CUnsignedLong(bitmapBytesPerRow), colorSpace, bitmapInfo)
        
       
        return context
    }

}

