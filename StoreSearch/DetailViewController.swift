//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Erik Uecke on 9/27/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
        
    }
    
    var searchResult: SearchResult!
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        popupView.layer.cornerRadius = 10
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
 
        if searchResult != nil {
            upDateUI()
        }
        
        view.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
        
    }
    
    deinit {
        print("deinit\(self)")
        downloadTask?.cancel()
    }
    
    // MARK: Update UI
    func upDateUI() {
        nameLabel.text = searchResult.name
        if searchResult.artistName.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = searchResult.artistName
        }
        kindLabel.text = searchResult.type
        genreLabel.text = searchResult.genre
        
        // Show price
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency
        let priceText: String
        if searchResult.price == 0 {
            priceText = "Free"
            
        } else if let text = formatter.string(from: searchResult.price as NSNumber) {
            priceText = text
            
        } else {
            priceText = ""
            
        }
        priceButton.setTitle(priceText, for: .normal)
        // Get image
        if let largeURL = URL(string: searchResult.imageLarge) {
            downloadTask = artworkImageView.loadImage(url: largeURL)
            
        }
    }
    
    @IBAction func openInStore() {
        if let url = URL(string: searchResult.storeURL) {
        print(url)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        }
        
    }

}

// Extention Presentation Controller
extension DetailViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideOutAnimationController()
        
    }
    
    
}
// Geusture Recognizer outside of screen.
extension DetailViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer( _ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
        
    }
    
    
}




