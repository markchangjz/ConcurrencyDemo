//
//  ViewController.swift
//  ConcurrencyDemo
//
//  Created by Hossam Ghareeb on 11/15/15.
//  Copyright © 2015 Hossam Ghareeb. All rights reserved.
//

/*
iOS Concurrency_ Getting Started with NSOperation and Dispatch Queues _ AppCoda
https://www.appcoda.com/ios-concurrency/

NSOperation - NSHipster
https://nshipster.com/nsoperation/
*/

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
		
//		usingConcurrentDispatchQueues()
//		usingSerialDispatchQueues()
		
//		usingConcurrentOperationQueues()
//		usingConcurrentOperationQueues2()
		usingSerialOperationQueues()
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
	
	// Dispatch Queue - Concurrent (GCD)
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
	
	// Dispatch Queue - Serial (GCD)
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
	
	// Operation Queue - Concurrent (high level abstraction)
	func usingConcurrentOperationQueues() {
		let concurrentQueue = OperationQueue()
		
		concurrentQueue.addOperation {
			let img1 = Downloader.downloadImageWithURL(url: imageURLs[0])
			OperationQueue.main.addOperation {
				self.imageView1.image = img1
			}
		}
		
		concurrentQueue.addOperation {
			let img2 = Downloader.downloadImageWithURL(url: imageURLs[1])
			OperationQueue.main.addOperation {
				self.imageView2.image = img2
			}
		}
		
		concurrentQueue.addOperation {
			let img3 = Downloader.downloadImageWithURL(url: imageURLs[2])
			OperationQueue.main.addOperation {
				self.imageView3.image = img3
			}
		}
		
		concurrentQueue.addOperation {
			let img4 = Downloader.downloadImageWithURL(url: imageURLs[3])
			OperationQueue.main.addOperation {
				self.imageView4.image = img4
			}
		}
	}
	
	// Operation Queue - Concurrent (high level abstraction)
	func usingConcurrentOperationQueues2() {
		let concurrentQueue = OperationQueue()
		
		// 1
		let operation1 = BlockOperation {
			let img1 = Downloader.downloadImageWithURL(url: imageURLs[0])
			OperationQueue.main.addOperation {
				self.imageView1.image = img1
			}
		}
		operation1.queuePriority = .normal
		operation1.completionBlock = {
			print("Operation 1 completed")
		}
		concurrentQueue.addOperation(operation1)
		
		// 2
		let operation2 = BlockOperation {
			let img2 = Downloader.downloadImageWithURL(url: imageURLs[1])
			OperationQueue.main.addOperation {
				self.imageView2.image = img2
			}
		}
		operation2.queuePriority = .normal
		operation2.completionBlock = {
			print("Operation 2 completed")
		}
		concurrentQueue.addOperation(operation2)
		
		// 3
		let operation3 = BlockOperation {
			let img3 = Downloader.downloadImageWithURL(url: imageURLs[2])
			OperationQueue.main.addOperation {
				self.imageView3.image = img3
			}
		}
		operation3.queuePriority = .normal
		operation3.completionBlock = {
			print("Operation 3 completed")
		}
		concurrentQueue.addOperation(operation3)
		
		// 4
		let operation4 = BlockOperation {
			let img4 = Downloader.downloadImageWithURL(url: imageURLs[3])
			OperationQueue.main.addOperation {
				self.imageView4.image = img4
			}
		}
		operation4.queuePriority = .normal
		operation4.completionBlock = {
			print("Operation 4 completed")
		}
		concurrentQueue.addOperation(operation4)
	}
	
	// Operation Queue - Serial (high level abstraction)
	func usingSerialOperationQueues() {
		let serialQueue = OperationQueue()
		
		// 1
		let operation1 = BlockOperation {
			let img1 = Downloader.downloadImageWithURL(url: imageURLs[0])
			OperationQueue.main.addOperation {
				self.imageView1.image = img1
			}
		}
		
		// 2
		let operation2 = BlockOperation {
			let img2 = Downloader.downloadImageWithURL(url: imageURLs[1])
			OperationQueue.main.addOperation {
				self.imageView2.image = img2
			}
		}
		
		// 3
		let operation3 = BlockOperation {
			let img3 = Downloader.downloadImageWithURL(url: imageURLs[2])
			OperationQueue.main.addOperation {
				self.imageView3.image = img3
			}
		}
		
		// 4
		let operation4 = BlockOperation {
			let img4 = Downloader.downloadImageWithURL(url: imageURLs[3])
			OperationQueue.main.addOperation {
				self.imageView4.image = img4
			}
		}

		operation2.addDependency(operation1)
		operation3.addDependency(operation2)
		operation4.addDependency(operation3)
		serialQueue.addOperations([operation1, operation2, operation3, operation4], waitUntilFinished: false)
	}
}

