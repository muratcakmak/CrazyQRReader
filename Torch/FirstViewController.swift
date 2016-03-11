//
//  FirstViewController.swift
//  Torch
//
//  Created by muratcakmak on 15/02/16.
//  Copyright © 2016 Murat Cakmak. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController {
    
    var key = false

    @IBAction func adjustFlashlightSensitivity(sender: AnyObject) {
        print(flashlightSensitivity.value)
        let sensitivity = flashlightSensitivity.value
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
            } catch let error as NSError{
                // handle error
                print(error.code)
            }
            
            if (sensitivity > 0.0)
            {
                do{
                    try device.setTorchModeOnWithLevel(sensitivity)
                }catch{
                    return
                }
                print("Hello")
            }
            else{
                        device.torchMode = .Off
                }
            device.unlockForConfiguration()
        }
    }
    
    @IBOutlet weak var flashlightSensitivity: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //adjustFlashlightSensitivity(flashlightSensitivity.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func flicker(sender: AnyObject){
        if(key){
            key = false
        }else{
            key = true
            blinkFlashlight(key)
        }
    }
    
    func blinkFlashlight(key: Bool){
        print("At the very beginning of the function")
        while(key){
            print(key)
        }
    }
    
}

