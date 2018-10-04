//
//  ViewController.swift
//  QatarMuseum
//
//  Created by Exalture on 06/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {

    var pageViewController = UIPageViewController()
    
    @IBOutlet weak var contentView: UIView!
    var pageImages = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        pageImages = ["exhibition","artifactimg","001_MIA_MW.146_005","coming_soon_2","coming_soon_1"]
        pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewControllerId") as! UIPageViewController
        self.pageViewController.dataSource = self;
        let startingViewController: PreviewContentViewController = self.viewControllerAtIndex(index: 0)!
        let viewControllers = [startingViewController]
        
        self.pageViewController.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        
        
        self.pageViewController.view.frame = contentView.frame
        self.addChildViewController(pageViewController)
        self.contentView.addSubview((pageViewController.view)!)
        self.pageViewController.didMove(toParentViewController: self)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        
        var index: Int? = (viewController as? PreviewContentViewController)?.pageIndex
        if ((index == 0) || (index == NSNotFound)) {
            return nil
        }
        index = index! - 1
        return self.viewControllerAtIndex(index: index!)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        
        var index: Int? = (viewController as? PreviewContentViewController)?.pageIndex
        if (index == NSNotFound) {
            return nil
        }
        index = index! + 1
        if (index == self.pageImages.count) {
            return nil
        }
        return self.viewControllerAtIndex(index: index!)
    }
    func viewControllerAtIndex(index : Int) -> PreviewContentViewController? {
        
        if ((self.pageImages.count == 0) || (index > self.pageImages.count)){
            return nil
        }
        
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewControllerId") as! PreviewContentViewController
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

