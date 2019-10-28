//
//  PageVC.swift
//  WeatherGift
//
//  Created by Anastasia on 10/11/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {

    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var pageControl: UIPageControl!
    var listButton: UIButton!
    var aboutButton: UIButton!
    var barbuttonWidth: CGFloat = 44
    var barbuttonHeight: CGFloat = 44
    var aboutButtonSize:CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        let newLocation = WeatherLocation(name: "", coordinates: "")
        locationsArray.append(newLocation)
        loadLocations()
        
        setViewControllers([createDetailVC(forpage: 0)], direction: .forward, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configurePageControl()
        configureListButton()
        configureAboutButton()
    }
    
    func loadLocations(){
        guard let locationsEnabled = UserDefaults.standard.value(forKey: "locationsArray") as? Data else{
            print("ERROR: Couldn't read in data from defaults for UserDefaults.")
            return
        }
        let decoder = JSONDecoder()
        if let locationsArray = try? decoder.decode(Array.self, from: locationsEnabled) as [WeatherLocation]{
            self.locationsArray = locationsArray
        } else{
            print("ERROR: Couldn't decode data from UserDefaults.")
        }
    }
    
    //MARK:- UI Configuration Methods
    
    func configurePageControl(){
        let pageControlHeight: CGFloat = barbuttonHeight
        let pageControlWidth: CGFloat = view.frame.height - (barbuttonWidth * 2)
        
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth) / 2, y: safeHeight - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        pageControl.backgroundColor = UIColor.white
        pageControl.addTarget(self, action: #selector(pageControlPressed), for: .touchUpInside)
        view.addSubview(pageControl)
        
    }
    
    func configureListButton(){
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        listButton = UIButton(frame: CGRect(x: view.frame.width - barbuttonWidth, y: safeHeight - barbuttonHeight, width: barbuttonWidth, height: barbuttonHeight))
        
        listButton.setBackgroundImage(UIImage(named: "listButton"), for: .normal)
        listButton.setBackgroundImage(UIImage(named: "listButton-highlighted"), for: .highlighted)
        listButton.addTarget(self, action: #selector(segueToLocationVC), for: .touchUpInside)
        view.addSubview(listButton)
    }
    
    func configureAboutButton(){
        let aboutButtonText = "About..."
        let aboutButtonFont = UIFont.systemFont(ofSize: 15)
        let fontAttributes = [NSAttributedString.Key.font: aboutButtonFont]
        aboutButtonSize = aboutButtonText.size(withAttributes: fontAttributes)
        
        aboutButtonSize.height +=  16
        aboutButtonSize.width += 16
        
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        aboutButton = UIButton(frame: CGRect(x: 8, y: (safeHeight - 8) - aboutButtonSize.height, width: aboutButtonSize.width, height: aboutButtonSize.height))
        
        aboutButton.setTitle(aboutButtonText, for: .normal)
        aboutButton.setTitleColor(UIColor.darkText, for: .normal)
        aboutButton.titleLabel?.font = aboutButtonFont
        aboutButton.addTarget(self, action: #selector(segueToAboutVC), for: .touchUpInside)
        view.addSubview(aboutButton)
    }
    
    //MARK:- Segues
    @objc func segueToAboutVC(){
        performSegue(withIdentifier: "ToAboutVC", sender: nil)
    }

    
    @objc func segueToLocationVC(){
        performSegue(withIdentifier: "ToListVC", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentViewController = self.viewControllers?[0] as? DetailVC else {return}
        locationsArray = currentViewController.locationsArray
        if segue.identifier  == "ToListVC"{
            let destination = segue.destination as! ListVC
            destination.locationsArray = locationsArray
            destination.currentPage = currentPage
            
        }
    }
    
    @IBAction func unwindFromListVC(sender: UIStoryboardSegue){
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        
        setViewControllers([createDetailVC(forpage: currentPage)], direction: .forward, animated: false, completion: nil)
    }
    
    //MARK:- Create View Controller or UIPageViewController
    func createDetailVC(forpage page: Int)->DetailVC{
        
        currentPage = min(max(0, page), locationsArray.count - 1)
        
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        detailVC.locationsArray = locationsArray
        detailVC.currentPage = currentPage
        
        return detailVC
    }
}

extension PageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVC{
            if currentViewController.currentPage < locationsArray.count - 1 {
                return createDetailVC(forpage: currentViewController.currentPage + 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVC{
            if currentViewController.currentPage > 0 {
                return createDetailVC(forpage: currentViewController.currentPage - 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers? [0] as? DetailVC{
            pageControl.currentPage = currentViewController.currentPage
            
        }
    }
    
    @objc func pageControlPressed() {
        guard let currentViewController = self.viewControllers?[0] as? DetailVC else {return}
            currentPage = currentViewController.currentPage
            if pageControl.currentPage < currentPage{
                setViewControllers([createDetailVC(forpage: pageControl.currentPage)], direction: .reverse, animated: true, completion: nil)
            } else if pageControl.currentPage > currentPage {
                setViewControllers([createDetailVC(forpage: pageControl.currentPage)], direction: .forward, animated: true, completion: nil)
            }
        }
    
}
