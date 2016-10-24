//
//  DetailsViewController.swift
//  Yelp
//

import UIKit

import CircularSpinner

class DetailsViewController: UIViewController {
    
    var business: Business?

    @IBOutlet weak var businessWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CircularSpinner.trackBgColor = UIColor.red
        CircularSpinner.trackPgColor = UIColor.lightGray
        businessWebView.delegate = self
        
        if let myBusiness = business {
            if let mobileUrl = myBusiness.businessMobileURL {
                businessWebView.loadRequest(URLRequest(url: mobileUrl))
            } else if let fullUrl = myBusiness.businessURL {
                businessWebView.loadRequest(URLRequest(url: fullUrl))
            }
            self.title = myBusiness.name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailsViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        CircularSpinner.show(animated: true, type: CircularSpinnerType.indeterminate, showDismissButton: false, delegate: nil)
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView) {
        CircularSpinner.hide()
    }
    
}
