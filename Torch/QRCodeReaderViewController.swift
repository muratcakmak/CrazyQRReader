//
//  SecondViewController.swift
//  Torch
//
//  Created by muratcakmak on 15/02/16.
//  Copyright © 2016 Murat Cakmak. All rights reserved.
//

import UIKit
import AVFoundation
import SafariServices

class QRCodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{

    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var input: AVCaptureInput!
  var flashMode = false

    @IBOutlet weak var encodedQRLabel: UILabel!
  
  @IBOutlet weak var flash: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do{
            self.input = try AVCaptureDeviceInput.init(device: captureDevice)
        }catch let error as NSError{
                print(error.code)
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)

        // Start video capture.
        captureSession?.startRunning()
        
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
        
        view.bringSubviewToFront(encodedQRLabel)
      view.bringSubviewToFront(flash)

        }
    
    override func viewWillAppear(animated: Bool) {
        captureSession?.startRunning()
        encodedQRLabel.text = "No QR Code is detected 😢"
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if (metadataObjects == nil || metadataObjects.count == 0){
            qrCodeFrameView?.frame = CGRectZero
            print("No qr code is detected")
            return
        }
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode{
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barcodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barcodeObject.bounds
            
            if metadataObj.stringValue != nil {
                print("\(metadataObj.stringValue)")
                let urlString = metadataObj.stringValue
//                if UIApplication.sharedApplication().canOpenURL(NSURL(string: urlString)!){
//                    self.openWithSafariVC(urlString)
//                    self.captureSession?.stopRunning()
//                    self.encodedQRLabel.text = urlString
//                }else{
//                    self.encodedQRLabel.text = urlString
//                    print("This is not a URL")
//                }
                self.encodedQRLabel.text = urlString
            }
            
        }
        
    }
    
    func openWithSafariVC(urlString: String){
    
        let svc = SFSafariViewController(URL: NSURL(string: urlString)!)
        self.presentViewController(svc, animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func flashModeOnOff(){
    if flashMode{
      self.flashMode = false
      adjustFlash(flashMode)
    }else{
      
      self.flashMode = true
      adjustFlash(flashMode)
    }
  }

  func adjustFlash(key: Bool) {

    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    if (device.hasTorch) {
      do {
        try device.lockForConfiguration()
      } catch let error as NSError{
        // handle error
        print(error.code)
      }
      print("here")
      if (key){
        device.torchMode = .On
      }else{
        print("here")
        device.torchMode = .Off
      }
      device.unlockForConfiguration()
    }

  }
}




