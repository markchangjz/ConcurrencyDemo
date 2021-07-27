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

enum FetchError: Error {
    case badImage
    case unreachable
}

let imageURLs = [
    "http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg",
    "http://goole.com",
    "http://goole.com",
    "http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg"]

class Downloader {
	
    class func downloadImageWithURL(url: String, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            
            if error != nil {
                completion(nil, error)
                return
            }


            if let data = data, let image = UIImage(data: data) {
                completion(image, nil)
            } else {
                completion(nil, FetchError.badImage)
            }
        }
        
        dataTask.resume()
	}
    
    class func fetchImage(url: String) async throws -> UIImage {
        
        let request = URLRequest(url: URL(string: url)!)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.unreachable }
        
        if let image = UIImage(data: data) {
            return image
        } else {
            return UIImage(named: "empty")!
        }
        
        
        // https://wwdcbysundell.com/2021/wrapping-completion-handlers-into-async-apis/
//        return try await withCheckedThrowingContinuation { continuation in
//
//            fetchImageData(url: url) { result in
//                switch result {
//                case .success(let value):
//                    continuation.resume(returning: value)
//                case .failure(let error):
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
    }
    
    class func fetchImageData(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        let request = URLRequest(url: URL(string: url)!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.success(UIImage(named: "empty")!))
            }
        }.resume()
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
//        usingBlock()
        
        Task {
            usingAsync()
        }
	}

	@IBAction func sliderValueChanged(_ sender: UISlider) {
		self.sliderValueLabel.text = "\(sender.value * 100.0)"
	}
}


extension ViewController {
    
	func usingBlock() {
        
        Downloader.downloadImageWithURL(url: imageURLs[0]) { (image, error) in
            OperationQueue.main.addOperation {
                if error != nil {
                    self.imageView1.image = UIImage(named: "empty")
                } else {
                    self.imageView1.image = image
                }
                
            }
        }
        
        Downloader.downloadImageWithURL(url: imageURLs[1]) { (image, error) in
            OperationQueue.main.addOperation {
                if error != nil {
                    self.imageView2.image = UIImage(named: "empty")
                } else {
                    self.imageView2.image = image
                }
            }
        }
        
        Downloader.downloadImageWithURL(url: imageURLs[2]) { (image, error) in
            OperationQueue.main.addOperation {
                if error != nil {
                    self.imageView3.image = UIImage(named: "empty")
                } else {
                    self.imageView3.image = image
                }
            }
        }
        
        Downloader.downloadImageWithURL(url: imageURLs[3]) { (image, error) in
            OperationQueue.main.addOperation {
                if error != nil {
                    self.imageView4.image = UIImage(named: "empty")
                } else {
                    self.imageView4.image = image
                }
            }
        }
	}
    
    func usingAsync() {

        Task {
            self.imageView1.image = try? await Downloader.fetchImage(url: imageURLs[0])
            self.imageView2.image = try? await Downloader.fetchImage(url: imageURLs[1])
            self.imageView3.image = try? await Downloader.fetchImage(url: imageURLs[2])
            self.imageView4.image = try? await Downloader.fetchImage(url: imageURLs[3])
        }
        
        
        // 依序執行
//        let img1 = try! await Downloader.fetchImage(url: imageURLs[0])
//        let img2 = try! await Downloader.fetchImage(url: imageURLs[1])
//        let img3 = try! await Downloader.fetchImage(url: imageURLs[2])
//        let img4 = try! await Downloader.fetchImage(url: imageURLs[3])
//        let photos = [img1, img2, img3, img4]
//        show(photos)
        
        
        // 並行執行
//        async let img1 = try! Downloader.fetchImage(url: imageURLs[0])
//        async let img2 = try! Downloader.fetchImage(url: imageURLs[1])
//        async let img3 = try! Downloader.fetchImage(url: imageURLs[2])
//        async let img4 = try! Downloader.fetchImage(url: imageURLs[3])
//        let photos = await [img1, img2, img3, img4]
//        show(photos)
    }
    
    private func show(_ photos: [UIImage]) {
        OperationQueue.main.addOperation {
            self.imageView1.image = photos[0]
            self.imageView2.image = photos[1]
            self.imageView3.image = photos[2]
            self.imageView4.image = photos[3]
        }
    }
}

