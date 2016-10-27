//
//  WeahterDescriptionPageViewController.swift
//  WeatherApp
//
//  Created by Manish Sama on 10/26/16.
//  Copyright © 2016 manish. All rights reserved.
//

import UIKit

class WeahterDescriptionPageViewController: UIPageViewController {
    
    var placesArray = [City]()
    var selectedIndex = Int()
    var viewControllersForPageView = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dataSource = self
        delegate = self
        
        
        for each in placesArray {
            let weatherDescriptionVC = getWeatherDescriptionViewControllerForIndex(index: placesArray.index(of: each)!)
            viewControllersForPageView.append(weatherDescriptionVC)
        }
        
        let initialVC = viewControllersForPageView[self.selectedIndex] as! WeatherDescriptionViewController
        setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        view.backgroundColor = UIColor.darkGray
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  getWeatherDescriptionViewControllerForIndex(index: Int) -> UIViewController {
        
        let weatherDescriptionVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherDescriptionViewController") as! WeatherDescriptionViewController
        weatherDescriptionVC.selectedCity = placesArray[index]
        return weatherDescriptionVC
    }

}

extension WeahterDescriptionPageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = viewControllersForPageView.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = viewControllersForPageView.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return viewControllersForPageView[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = viewControllersForPageView.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard viewControllersForPageView.count > previousIndex else {
            return nil
        }
        
        return viewControllersForPageView[previousIndex]

    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return self.placesArray.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return self.selectedIndex
    }
}

extension WeahterDescriptionPageViewController : UIPageViewControllerDelegate {
    
}


