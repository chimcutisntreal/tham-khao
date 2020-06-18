//
//  BannerCollectionViewCell.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/15/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell,UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    
    var homeVC = HomeViewController()
    
    var banner : [BannerDetail]? {
        didSet {
            requestBanner()
        }
    }
    // MARK: Init Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.delegate = self
    }
    
    func requestBanner(){
        var images = [UIImage]()
        for i in banner ?? [] {
   
            ImageService.getImage(withURL: URLToRequest.init(string: i.image).urlImage) { image in
                images.append(image ?? UIImage(named: "error_loading")!)
                self.configure(images: images)
            }
        }
    }
    
    // MARK: Configure Methods
    func configure(images: [UIImage]) {
        
        // Get the scrollView width and height
        let scrollViewWidth: CGFloat = contentView.frame.width
        let scrollViewHeight: CGFloat = contentView.frame.height
        // Loop through all of the images and add them all to the scrollView
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(frame: CGRect(x: scrollViewWidth * CGFloat(index),
                                                      y: 0,
                                                      width: scrollViewWidth,
                                                      height: scrollViewHeight))
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            scrollView.addSubview(imageView)
        }
        
        // Set the scrollView contentSize
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(images.count),
                                        height: 1)
        // Ensure that the pageControl knows the number of pages
        pageControl.numberOfPages = images.count
    }
    
    @IBAction func pageControlTap(_ sender: Any?) {
        guard let pageControl: UIPageControl = sender as? UIPageControl else {
            return
        }
        scrollToIndex(index: pageControl.currentPage)
    }
    
    func scrollToIndex(index: Int) {
        let pageWidth: CGFloat = scrollView.frame.width
        let slideToX: CGFloat = CGFloat(index) * pageWidth
        
        scrollView.scrollRectToVisible(CGRect(x: slideToX, y:0, width:pageWidth, height:scrollView.frame.height), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        pageControl.currentPage = Int(currentPage)
    }
}


