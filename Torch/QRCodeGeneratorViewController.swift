//
//  QRCodeGeneratorViewController.swift
//  Torch
//
//  Created by muratcakmak on 20/02/16.
//  Copyright © 2016 Murat Cakmak. All rights reserved.
//

import UIKit

class QRCodeGeneratorViewController: UIViewController {

  
  @IBOutlet weak var textField: UITextField!
  
  @IBOutlet weak var imgQRCode: UIImageView!
  
  @IBOutlet weak var btnAction: UIButton!
  
  var qrcodeImage: CIImage!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  @IBAction func performButtonAction(sender: AnyObject) {
    if qrcodeImage == nil{
      if textField.text == nil {
        return
      }
      
      let data = textField.text?.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
      let filter = CIFilter(name: "CIQRCodeGenerator")
      
      filter?.setValue(data, forKey: "inputMessage")
      filter?.setValue("L", forKey: "inputCorrectionLevel")
      
      qrcodeImage = filter?.outputImage
      
      textField.resignFirstResponder()
      btnAction.setTitle("Clear", forState: .Normal)
      displayQRCodeImage()
    }else{
      imgQRCode.image = nil
      qrcodeImage = nil
      textField.text = nil
      btnAction.setTitle("Transform", forState: .Normal)
    
    }
    
  }

  func displayQRCodeImage() {
    let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
    let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
    
    let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
    
    imgQRCode.image = UIImage(CIImage: transformedImage)
    
    
  }

}
