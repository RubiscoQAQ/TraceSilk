//
//  GetImageController.swift
//  TraceSilk
//
//  Created by 孙钰昇 on 2021/1/26.
//

import UIKit
import PhotosUI

class GetImageController:UIViewController,PHPickerViewControllerDelegate,UINavigationControllerDelegate{
    
    public static var image:UIImage!
    @IBOutlet weak var nextButton: UIButton!
    public static var location:CLLocationCoordinate2D!
    @IBOutlet weak var imageview: UIImageView!
    var imagePickerController:PHPickerViewController!
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.setTitle("选择要识别的照片", for: .normal)
        button.addTarget(self, action: #selector(GetImageController.pickImage), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor.white
    }

    @IBAction func getMore(_ sender: Any) {
        if let url = URL(string: "https://rubisco.cn/archives/184/"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @objc func pickImage(){
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        self.imagePickerController = PHPickerViewController.init(configuration: config)
        self.imagePickerController.delegate = self
        self.present(self.imagePickerController, animated: true, completion: nil)
        
    }
    func picker(_ picker: PHPickerViewController,didFinishPicking results:[PHPickerResult]) {
        print(1111111)
        var a:CLLocationCoordinate2D? = nil
        for result in results {
                // 判断类型是否为 UIImage
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    // 确认类型后，调用 loadObject 方法获取图片
                result.itemProvider.loadObject(ofClass: UIImage.self) { (data, error) in
                        // 回调结果是在异步线程，展示时需要切换到主线程
                    if let image = data as? UIImage {
                        DispatchQueue.main.async {
                            print("get image")
                            self.imageview.image = image
                            GetImageController.image = self.imageview.image
                        }
                    }
                }
                if let assetId = result.assetIdentifier {
                    let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                    print(assetResults.firstObject?.location?.coordinate ?? "No location")
                    a = assetResults.firstObject?.location?.coordinate
                    
                }
                
            }
        }
        nextButton.isHidden = false
        if a != nil{
            GetImageController.location = a
            nextButton.setTitle("魔法部已经定位到了图片踪丝,点击查看👋", for: .normal)
        }
        else{
            GetImageController.location = nil
            nextButton.setTitle("魔法部没有发现图片踪丝,点击查看傲罗的预测👋", for: .normal)
            
        }
        self.dismiss(animated: true, completion: nil)
    }
}
