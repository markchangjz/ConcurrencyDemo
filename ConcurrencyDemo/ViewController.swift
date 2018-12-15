//
//  ViewController.swift
//  ConcurrencyDemo
//
//  Created by Hossam Ghareeb on 11/15/15.
//  Copyright © 2015 Hossam Ghareeb. All rights reserved.
//

import UIKit

let imageURLs = ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg"]

class Downloader {
    
    class func downloadImageWithURL(url:String) -> UIImage! {
        
		let data = NSData(contentsOf: NSURL(string: url)! as URL)
		return UIImage(data: data! as Data)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var imageView3: UIImageView!
    
    @IBOutlet weak var imageView4: UIImageView!
    
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func didClickOnStart(_ sender: Any) {
//		original()
		usingConcurrentDispatchQueues()
//		usingSerialDispatchQueues()
	}

	@IBAction func sliderValueChanged(_ sender: UISlider) {
		self.sliderValueLabel.text = "\(sender.value * 100.0)"
	}
}


extension ViewController {
	
	func original() {
		let img1 = Downloader.downloadImageWithURL(url: imageURLs[0])
		self.imageView1.image = img1
		
		let img2 = Downloader.downloadImageWithURL(url: imageURLs[1])
		self.imageView2.image = img2
		
		let img3 = Downloader.downloadImageWithURL(url: imageURLs[2])
		self.imageView3.image = img3
		
		let img4 = Downloader.downloadImageWithURL(url: imageURLs[3])
		self.imageView4.image = img4
	}
	
	func usingConcurrentDispatchQueues() {
		let concurrentQueue = DispatchQueue.global(qos: .default)
//		let concurrentQueue = DispatchQueue(label: "imagesQueue", qos: .default, attributes: .concurrent)
		
		concurrentQueue.async {
			let img1 = Downloader.downloadImageWithURL(url: imageURLs[0])
			DispatchQueue.main.async {
				self.imageView1.image = img1
			}
		}
		
		concurrentQueue.async {
			let img2 = Downloader.downloadImageWithURL(url: imageURLs[1])
			DispatchQueue.main.async {
				self.imageView2.image = img2
			}
		}
		
		concurrentQueue.async {
			let img3 = Downloader.downloadImageWithURL(url: imageURLs[2])
			DispatchQueue.main.async {
				self.imageView3.image = img3
			}
		}
		
		concurrentQueue.async {
			let img4 = Downloader.downloadImageWithURL(url: imageURLs[3])
			DispatchQueue.main.async {
				self.imageView4.image = img4
			}
		}
	}
	
	func usingSerialDispatchQueues() {
		let serialQueue = DispatchQueue(label: "imagesQueue")
		
		serialQueue.async {
			let img1 = Downloader.downloadImageWithURL(url: imageURLs[0])
			DispatchQueue.main.async {
				self.imageView1.image = img1
			}
		}
		
		serialQueue.async {
			let img2 = Downloader.downloadImageWithURL(url: imageURLs[1])
			DispatchQueue.main.async {
				self.imageView2.image = img2
			}
		}
		
		serialQueue.async {
			let img3 = Downloader.downloadImageWithURL(url: imageURLs[2])
			DispatchQueue.main.async {
				self.imageView3.image = img3
			}
		}
		
		serialQueue.async {
			let img4 = Downloader.downloadImageWithURL(url: imageURLs[3])
			DispatchQueue.main.async {
				self.imageView4.image = img4
			}
		}
	}
}

