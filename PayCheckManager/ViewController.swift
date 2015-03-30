//
//  ViewController.swift
//  PayCheckManager
//
//  Created by Rogojan Nicolae on 3/25/15.
//  Copyright (c) 2015 Rogojan Nicolae. All rights reserved.
//

import UIKit
import MobileCoreServices



class ViewController: UIViewController, TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var videoCamera: GPUImageVideoCamera?
    var filter: GPUImagePixellateFilter?
    var filter2: GPUImageKuwaharaFilter?
    var filter3: GPUImageLineGenerator?

    @IBOutlet weak var scanerBtn: UIButton!
    var newMedia: Bool?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewFiltred: UIImageView!
    
    @IBAction func startScan(sender: AnyObject) {
        /*
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
                newMedia = true
        }
        */
        
        videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset640x480, cameraPosition: .Back)
        videoCamera!.outputImageOrientation = .Portrait;
        filter = GPUImagePixellateFilter()
        filter2 = GPUImageKuwaharaFilter()
        filter3 = GPUImageLineGenerator()
        videoCamera?.addTarget(filter3)
        filter3?.addTarget(self.view as GPUImageView)
        videoCamera?.startCameraCapture()
        
    }
    
    @IBAction func useCameraRoll(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = false
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as NSString
        
        self.dismissViewControllerAnimated(true, completion: nil)

        
        if mediaType.isEqualToString(kUTTypeImage as NSString) {
            var image = info[UIImagePickerControllerOriginalImage]
                as UIImage
            
            imageView.image = image
            
            image = sFunc_imageFixOrientation(image)

            NSLog("Start Tesseract.... %@",image.description)
//            <UIImage: 0x174286ef0> size {2592, 1936} orientation 1 scale 1.000000  __OK
//            size {1936, 2592} orientation 3 scale  Bad
            

            var tesseract:Tesseract = Tesseract();
            tesseract.language = "eng"
            tesseract.delegate = self
//            tesseract.setVariableValue("0123456789", forKey: "tessedit_char_whitelist")
            tesseract.image = image

            tesseract.recognize()
            
            NSLog("%@", tesseract.recognizedText)
  
/*
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            } else if mediaType.isEqualToString(kUTTypeMovie as NSString) {
                // Code to support video here
            }
*/

        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "Check_2.jpg")!
                imageView.image = image
        /*
        
        let imageSource = GPUImagePicture().imageByFilteringImage(image)
        
        let cropFilter = GPUImageCropFilter();
        cropFilter.forceProcessingAtSize(CGSize(width: 20,height: 20))
        
        let adaptiveThreshold = GPUImageAdaptiveThresholdFilter()
        adaptiveThreshold.blurRadiusInPixels = 8.0
        
        let luminanceThreshold = GPUImageLuminanceThresholdFilter()
        luminanceThreshold.threshold = 0.4
        
        var imageFitred = image

//        imageFitred = adaptiveThreshold.imageByFilteringImage(imageFitred)
        imageFitred = luminanceThreshold.imageByFilteringImage(imageFitred)
        imageFitred = adaptiveThreshold.imageByFilteringImage(imageFitred)
        
        
        imageView.image = imageFitred

        
        var tesseract:Tesseract = Tesseract();
        tesseract.language = "eng"
        tesseract.delegate = self
//        tesseract.setVariableValue("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-,=", forKey:"tessedit_char_whitelist")
        tesseract.image = imageFitred
        tesseract.recognize()
        NSLog("Text1: %@", tesseract.recognizedText)

        
        imageViewFiltred.image = UIImage(named: "Check_2.jpg")
        tesseract.image = UIImage(named: "Check_2.jpg")!
        tesseract.recognize()
        NSLog("Text withaut filter: %@", tesseract.recognizedText)
*/

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSLog("Error did receive memory")
        // Dispose of any resources that can be recreated.
    }

    func shouldCancelImageRecognitionForTesseract(tesseract: Tesseract!) -> Bool {
        return false // return true if you need to interrupt tesseract before it finishes
    }

    
    func sFunc_imageFixOrientation(img:UIImage) -> UIImage {
        
        
        // No-op if the orientation is already correct
        if (img.imageOrientation == UIImageOrientation.Up) {
            return img;
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform:CGAffineTransform = CGAffineTransformIdentity
        
        if (img.imageOrientation == UIImageOrientation.Down
            || img.imageOrientation == UIImageOrientation.DownMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.width, img.size.height)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        }
        
        if (img.imageOrientation == UIImageOrientation.Left
            || img.imageOrientation == UIImageOrientation.LeftMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.width, 0)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        }
        
        if (img.imageOrientation == UIImageOrientation.Right
            || img.imageOrientation == UIImageOrientation.RightMirrored) {
                
                transform = CGAffineTransformTranslate(transform, 0, img.size.height);
                transform = CGAffineTransformRotate(transform,  CGFloat(-M_PI_2));
        }
        
        if (img.imageOrientation == UIImageOrientation.UpMirrored
            || img.imageOrientation == UIImageOrientation.DownMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.width, 0)
                transform = CGAffineTransformScale(transform, -1, 1)
        }
        
        if (img.imageOrientation == UIImageOrientation.LeftMirrored
            || img.imageOrientation == UIImageOrientation.RightMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
        }
        
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        var ctx:CGContextRef = CGBitmapContextCreate(nil, UInt(img.size.width), UInt(img.size.height),
            CGImageGetBitsPerComponent(img.CGImage), 0,
            CGImageGetColorSpace(img.CGImage),
            CGImageGetBitmapInfo(img.CGImage));
        CGContextConcatCTM(ctx, transform)
        
        
        if (img.imageOrientation == UIImageOrientation.Left
            || img.imageOrientation == UIImageOrientation.LeftMirrored
            || img.imageOrientation == UIImageOrientation.Right
            || img.imageOrientation == UIImageOrientation.RightMirrored
            ) {
                
                CGContextDrawImage(ctx, CGRectMake(0,0,img.size.height,img.size.width), img.CGImage)
        } else {
            CGContextDrawImage(ctx, CGRectMake(0,0,img.size.width,img.size.height), img.CGImage)
        }
        
        
        // And now we just create a new UIImage from the drawing context
        var cgimg:CGImageRef = CGBitmapContextCreateImage(ctx)
        var imgEnd:UIImage = UIImage(CGImage: cgimg)!
        
        return imgEnd
    }
    
}

