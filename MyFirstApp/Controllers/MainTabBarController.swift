//
//  MainTabBarController.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/21/22.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupItems()
        setDelegate()
    }
    
    private func setupTabBar() {
        
        tabBar.backgroundColor = .specialTabBar
        tabBar.tintColor = .specialDarkGreen
        tabBar.unselectedItemTintColor = .specialGray
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.specialLightBrown.cgColor
        
                
    }
    
    private func setDelegate() {
        delegate = self
    }
    
    
    private func setupItems() {
        let mainVC = MainViewController()
        let statisticVC = StatisticViewController()
        let profileVC = ProfileViewController()
        
        // Расстановка ссылок на экраны
        setViewControllers([mainVC,statisticVC,profileVC], animated: true)
        
        // Проверить что мы получили таб бар как экраны
        guard let items = tabBar.items else { return }
        
        
        items[0].title = "Main"
        items[1].title = "Statistic"
        items[2].title = "Profile"
        
        items[0].image = UIImage(named: "tabBarMain")
        items[1].image = UIImage(systemName: "waveform.path.ecg.rectangle")
        items[2].image = UIImage(named: "tabBarProfile")
        
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let removeSelectedBackground = {
            tabBar.subviews.filter({ $0.layer.name == "TabBackgroundView" }).first?.removeFromSuperview()
        }

        let addSelectedBackground = { (bgColour: UIColor) in
            let tabIndex = CGFloat(tabBar.items!.firstIndex(of: item)!)
            let tabWidth = tabBar.bounds.width / CGFloat(tabBar.items!.count)
            let bgView = UIView(frame: CGRect(x: tabWidth * tabIndex, y: 0, width: tabWidth, height: tabBar.bounds.height))
            bgView.backgroundColor = bgColour
            bgView.layer.name = "TabBackgroundView"
            tabBar.insertSubview(bgView, at: 0)
        }

        removeSelectedBackground()
        addSelectedBackground(.specialTabItem)
    }
}
