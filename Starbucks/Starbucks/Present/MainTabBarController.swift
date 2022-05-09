import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let homeView = HomeViewController()
        let orderView = OrderViewController()

        homeView.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: nil)
        orderView.tabBarItem = UITabBarItem(title: "Order", image: UIImage(systemName: "cup.and.saucer"), selectedImage: nil)
        tabBar.backgroundColor = UIColor(named: "gray_tabbar")
        
        setViewControllers([homeView,orderView], animated: false)
    }


}

