import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    fileprivate func presentViewController(_ alert: UIAlertController, animated flag: Bool, completion: (() -> Void)?) -> Void {
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: flag, completion: completion)
    }
    
    
    
    func createAlert(_ title : String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title : "OK", style: .default) { (action) in
            
            
        }
        
        
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated : true, completion: nil)
        
        
    }
    
    func createAlert2(_ title : String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Nastavenia", style: .default) { (_) -> Void in
            let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsURL {
                UIApplication.shared.openURL(url)
            }
        }
        
        let cancelAction = UIAlertAction(title : "Zrusit", style: .default) { (action) in
            
            
        }
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated : true, completion: nil)
        
        
    }
    
}
