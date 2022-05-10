import UIKit

final class HomeViewController: UIViewController {
    
    private var homeViewModel: HomeViewModel?
    
    convenience init(homeViewModel: HomeViewModel) {
        self.init()
        self.homeViewModel = homeViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }    
}
