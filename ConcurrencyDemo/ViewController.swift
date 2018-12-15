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

Grand Central Dispatch (GCD) and Dispatch Queues in Swift 3 _ AppCoda
https://www.appcoda.com/grand-central-dispatch/

NSOperation - NSHipster
https://nshipster.com/nsoperation/
*/

import UIKit

let imageURLs = ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg"]

class Downloader {
    
    class func downloadImageWithURL(url: String) -> UIImage! {
        
		let data = NSData(contentsOf: NSURL(string: url)! as URL)
		return UIImage(data: data! as Data)
    }
	
	class func downloadImageWithURL(url: String, completion: (_ image: UIImage?) -> Void) {
		print("downloading")
		let data = NSData(contentsOf: NSURL(string: url)! as URL)
		let image = UIImage(data: data! as Data)
		
		completion(image)
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
		
		// Grand Central Dispatch (GCD)
		usingConcurrentDispatchQueues()
//		usingConcurrentDispatchQueues_WorkItem()
//		usingSerialDispatchQueues()
		
		// Operation Queue
//		usingConcurrentOperationQueues()
//		usingConcurrentOperationQueues2()
//		usingSerialOperationQueues()
		
		// Group
//		usingGroupConcurrentDispatchQueues()
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
	
	// MARK: - Dispatch Queue - Concurrent (GCD)
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
	
	// MARK: - Dispatch Queue - Concurrent (GCD) (WorkItem)
	func usingConcurrentDispatchQueues_WorkItem() {
		// 1
		var img1: UIImage?
		let workItem1 = DispatchWorkItem {
			img1 = Downloader.downloadImageWithURL(url: imageURLs[0])
		}
//		workItem1.perform()
		
		// 2
		var img2: UIImage?
		let workItem2 = DispatchWorkItem {
			img2 = Downloader.downloadImageWithURL(url: imageURLs[1])
		}
//		workItem2.perform()
		
		// 3
		var img3: UIImage?
		let workItem3 = DispatchWorkItem {
			img3 = Downloader.downloadImageWithURL(url: imageURLs[2])
		}
//		workItem3.perform()
		
		// 4
		var img4: UIImage?
		let workItem4 = DispatchWorkItem {
			img4 = Downloader.downloadImageWithURL(url: imageURLs[3])
		}
//		workItem4.perform()
		
		let concurrentQueue = DispatchQueue.global(qos: .default)
		concurrentQueue.async(execute: workItem1)
		concurrentQueue.async(execute: workItem2)
		concurrentQueue.async(execute: workItem3)
		concurrentQueue.async(execute: workItem4)
		
		/*
		concurrentQueue.async(execute: workItem1)
		
		concurrentQueue.async {
			workItem1.perform()
		}
		*/
		
		workItem1.notify(queue: DispatchQueue.main) {
			self.imageView1.image = img1
		}
		workItem2.notify(queue: DispatchQueue.main) {
			self.imageView2.image = img2
		}
		workItem3.notify(queue: DispatchQueue.main) {
			self.imageView3.image = img3
		}
		workItem4.notify(queue: DispatchQueue.main) {
			self.imageView4.image = img4
		}
	}
	
	// MARK: - Dispatch Queue - Serial (GCD)
	func usingSerialDispatchQueues() {
		let serialQueue = DispatchQueue(label: "imagesQueue")
//		let serialQueue = DispatchQueue(label: "imagesQueue", qos: .default)
		
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
	
	// MARK: - Operation Queue - Concurrent (high level abstraction)
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
	
	// MARK: - Operation Queue - Concurrent (high level abstraction)
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
	
	// MARK: - Operation Queue - Serial (high level abstraction)
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
	
	// MARK: - Group Dispatch Queue - Concurrent (GCD)
	func usingGroupConcurrentDispatchQueues() {
		let concurrentQueue = DispatchQueue(label: "imagesQueue", qos: .default, attributes: .concurrent)
		let group = DispatchGroup()
		
		var image1 = UIImage()
		var image2 = UIImage()
		var image3 = UIImage()
		var image4 = UIImage()
		
		concurrentQueue.async(group: group) {
//			group.enter()
			Downloader.downloadImageWithURL(url: imageURLs[0]) { (image) in
				image1 = image!
				print("downloaded image 1")
//				group.leave()
			}
		}
		
		concurrentQueue.async(group: group) {
//			group.enter()
			Downloader.downloadImageWithURL(url: imageURLs[1]) { (image) in
				image2 = image!
				print("downloaded image 2")
//				group.leave()
			}
		}
		
		concurrentQueue.async(group: group) {
//			group.enter()
			Downloader.downloadImageWithURL(url: imageURLs[2]) { (image) in
				image3 = image!
				print("downloaded image 3")
//				group.leave()
			}
		}
		
		concurrentQueue.async(group: group) {
//			group.enter()
			Downloader.downloadImageWithURL(url: imageURLs[3]) { (image) in
				image4 = image!
				print("downloaded image 4")
//				group.leave()
			}
		}
		
		group.notify(queue: DispatchQueue.main) {
			self.imageView1.image = image1
			self.imageView2.image = image2
			self.imageView3.image = image3
			self.imageView4.image = image4
		}
	}
}

