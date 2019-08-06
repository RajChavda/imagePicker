//
//  ViewController.swift
//  MultipleImagesCollection
//
//  Created by Rudrarajsinh Chavda on 05/08/19.
//  Copyright © 2019 Rudrarajsinh Chavda. All rights reserved.
//

import UIKit

import Photos
import BSImagePicker

class ViewController: UIViewController , URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {

    @IBOutlet weak var imgView : UIImageView!
    var SelectedAssests = [PHAsset]()
    var photoArray = [UIImage]()
    @IBOutlet weak var imageUploadProgressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addImages(sender: UIButton!)
    {
        let vc = BSImagePickerViewController()
    self.bs_presentImagePickerController(vc, animated: true, select: { (assests: PHAsset) in
        
        }, deselect: { (assests: PHAsset) in

        }, cancel: { (assests: [PHAsset]) in

    }, finish: { (assests: [PHAsset]) in

            for i in 0..<assests.count
            {
                self.SelectedAssests.append(assests[i])
            }
        self.assetToImages()
        }, completion: nil)
    }

    //MARK:- Convert Assests to images

    func assetToImages() {

        if SelectedAssests.count != 0 {

            for i in 0..<SelectedAssests.count {

                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: SelectedAssests[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option) { (result, info) in
                    thumbnail = result!
                }
                let data =  thumbnail.jpegData(compressionQuality: 1.0)
                let newImage = UIImage(data: data!)
                self.photoArray.append(newImage! as UIImage)
            }
//            self.imgView.image = self.photoArray[i]
            self.imgView.animationImages = self.photoArray
            self.imgView.animationDuration  = 2.0
            self.imgView.startAnimating()
        }
    }

    func uploadImages() {

        let imageData = self.photoArray[0].jpegData(compressionQuality: 1.0)!

        let uploadScriptUrl = NSURL(string:"http://www.swiftdeveloperblog.com/http-post-example-script/")
        let request = NSMutableURLRequest(url: uploadScriptUrl! as URL)
        request.httpMethod = "POST"
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")

//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)

//        let task = session.dataTask(with: urlRequest) { (data, response, error) in
//            if let error = error {
//                print("Api Error: \(error.localizedDescription)")
//                return
//            }



//        let task = session.uploadTask(with: request as URLRequest, from: imageData)
//        task.resume()
    }

    private func URLSession(session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?)
    {
        let myAlert = UIAlertView(title: "Alert", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "Ok")
        myAlert.show()

//        self.uploadButton.isEnabled = true

    }


    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    {
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)

        imageUploadProgressView.progress = uploadProgress
        let progressPercent = Int(uploadProgress*100)
        progressLabel.text = "\(progressPercent)%"

    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void)
    {
//        self.uploadButton.isEnabled = true
    }

    @IBAction func btn_databasePressed(sender: UIButton!)
    {
        let story = storyboard?.instantiateViewController(withIdentifier: "DatabaseVC") as! DatabaseVC
        self.navigationController?.pushViewController(story, animated: true)
    }
}

