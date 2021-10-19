//
//  ViewController.swift
//  WorkTests
//
//  Created by Vadim Genserovsky on 24.09.2021.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create URL
        let url = URL(string: "https://cdn.cocoacasts.com/cc00ceb0c6bff0d536f25454d50223875d5c79f1/above-the-clouds.jpg")!

        // Fetch Image Data
        if let data = try? Data(contentsOf: url) {
            // Create Image and Update Image View
            imageView.image = UIImage(data: data)
        }
    }
}
let imageUrl = "https://cdn.cocoacasts.com/cc00ceb0c6bff0d536f25454d50223875d5c79f1/above-the-clouds.jpg"


func imageDimenssions(url: String) -> String{
    if let imageSource = CGImageSourceCreateWithURL(URL(string: url)! as CFURL, nil) {
        if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
            let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as! Int
            let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as! Int
            return "Width: \(pixelWidth), Height: \(pixelHeight)"
        }
    }
    return "None"
}

