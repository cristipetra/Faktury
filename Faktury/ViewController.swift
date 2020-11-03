//
//  ViewController.swift
//  Faktury
//
//  Created by Factury co Test on 15/07/2017.
//  Copyright © 2017 Test Project. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, UIWebViewDelegate {

    @IBOutlet weak var logoNavigationItem: UIBarButtonItem!
    @IBOutlet weak var pdfNavigationBar: UINavigationBar!
    @IBOutlet weak var myWebView: wkweb!
    @IBOutlet weak var myWebView2: UIWebView!
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicatorImageView: UIImageView!
    
    @IBOutlet weak var myWebViewTop: NSLayoutConstraint!
    @IBOutlet weak var myWebViewTop2: NSLayoutConstraint!
    
    var visibleWebView: UIWebView?
    var hiddenWebView: UIWebView?
    var loadingWebView: UIWebView?
    var history: [URL] = []
    
    var frameOutside: CGRect?
    var frameInside: CGRect?
    
    var isPrintStarted = false
    var isFirstRequest = true
    
    var domCompletionTimer: Timer?
    
    var navigationBarFix: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareNavigationBar()
        self.prepareWebView(myWebView2, isFirst: false)
        self.prepareWebView(myWebView, isFirst: true)
        self.prepareActivityIndicatorView()
        self.addDoubleTapGesture(to: myWebView)
        self.addDoubleTapGesture(to: myWebView2)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setActivityIndicatorImageViewFrame()
        self.createFrames()
        self.resetBounces()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func showPDFView(fileURL: URL) {
        if let controller: PDFViewController = UIViewController.instantiateController(from: .main) {
            controller.fileURL = fileURL
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        let url = request.url!
        
        print("===\(url.absoluteString)")
        
        if navigationType == .formSubmitted || navigationType == .formResubmitted {
            self.saveUserData(webView)
        }
        
        if self.isFirstRequest {
            self.history.append(url)
            self.addAnimationToActivityIndicator()
            self.activityIndicatorView.isHidden = false
            return true
        }
        
        self.resetBounces()
        
        if url.absoluteString.contains("/exportToPDF/id/") {
//            self.showPdfNavigationBar(webView)
            self.showPDFView(fileURL: url)
            return false
        }
        if url.absoluteString.contains("/raportPdf") {
            self.showPdfNavigationBar(webView)
        }
        if url.absoluteString.contains("/exportToPDF") {
            self.showPdfNavigationBar(webView)
        }
        
        let isTheSameUrlAsBefore = !self.history.isEmpty && self.history.last!.absoluteString == url.absoluteString
        if webView == self.visibleWebView && !isTheSameUrlAsBefore {
            
            if url.absoluteString != "about:blank" {
                self.history.append(url)
            }
            
            if url.isUrlWithTransition() {
                if url.isUrlWithActivityIndicator() {
                    self.addAnimationToActivityIndicator()
                    self.activityIndicatorView.isHidden = false
                }
                
                self.hiddenWebView!.loadRequest(request)
                
                return false
            }
        }
        
        if url.isUrlWithActivityIndicator() {
            self.addAnimationToActivityIndicator()
            self.activityIndicatorView.isHidden = false
        }
        
        return true
    }
    
    private func saveUserData(_ webView: UIWebView) {
        if let username = webView.stringByEvaluatingJavaScript(from: "document.getElementById('LoginForm_username').value") {
            if !username.isEmpty {
                _ = KeychainWrapper.standard.set(username, forKey: "username")
            }
        }
        
        if let password = webView.stringByEvaluatingJavaScript(from: "document.getElementById('LoginForm_password').value") {
            if !password.isEmpty {
                _ = KeychainWrapper.standard.set(password, forKey: "password")
            }
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadingWebView = webView
        
        self.removeShadow(webView)
        
        if self.isFirstRequest {
            self.startDOMCompletionPolling()
            return
        } else if webView == self.hiddenWebView {
            if self.navigationBarFix == 1 {
                self.navigationBarFix = 0
                webView.reload()
            } else {
                self.startTransitionAnimation()
            }
        }
        
        self.stopSpinning()
    }
    
    private func removeShadow(_ webView: UIWebView) {
        for subview: UIView in webView.scrollView.subviews {
            subview.layer.shadowOpacity = 0.0
            for subview in subview.subviews {
                subview.layer.shadowOpacity = 0.0
            }
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.loadingWebView = webView
        
        self.stopSpinning()
    }
    
    private func startDOMCompletionPolling() {
        if let timer = self.domCompletionTimer  {
            timer.invalidate()
        }
        
        self.domCompletionTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.checkDOMCompletion), userInfo: nil, repeats: true)
    }
    
    @objc func checkDOMCompletion() {
        if let readyState = self.loadingWebView!.stringByEvaluatingJavaScript(from: "document.readyState") {
            if !readyState.isEmpty && readyState == "loading" {
                return
            }
        }
        
        self.domCompletionTimer!.invalidate()
        self.stopSpinning()
        
        if self.isFirstRequest {
            self.isFirstRequest = false
            self.visibleWebView!.isHidden = false
            self.loadUserData(visibleWebView!)
        }
    }
    
    fileprivate func loadUserData(_ webView: UIWebView) {
        if let username = KeychainWrapper.standard.string(forKey: "username") {
            _ = webView.stringByEvaluatingJavaScript(from: "document.getElementById('LoginForm_username').value='\(username)'")
        }
        
        if let password = KeychainWrapper.standard.string(forKey: "password")  {
            _ = webView.stringByEvaluatingJavaScript(from: "document.getElementById('LoginForm_password').value='\(password)'")
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer.state == .ended {
            let currentUrl = self.visibleWebView!.request!.mainDocumentURL!
            if currentUrl.isPdf() && !self.isPrintStarted {
                self.isPrintStarted = true
                self.removeAnimationOfActivityIndicator()
                self.activityIndicatorView.isHidden = true
                
                self.openPrintController(url: currentUrl)
                return false
            }
        }
        
        return true
    }
    
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        if self.history.count > 1 {
            self.processMultipleHistory(sender)
        } else if self.history.count == 1 && self.history[0].absoluteString != self.visibleWebView!.request!.url!.absoluteString {
            self.processSingleHistory()
        }
    }
    
    private func processMultipleHistory(_ sender: UISwipeGestureRecognizer) {
        var url = self.history.last!
        if !url.isUrlWithBackGesture() {
            return
        }
        
        if isModalOpened() {
            return
        }
        
        self.history.removeLast()
        url = self.history.last!
        if Netowrk.checkStatusCode(for: url) == 500 {
            rightSwipe(sender)
            return
        }
        self.hiddenWebView!.loadRequest(URLRequest(url: url))
    }
    
    private func processSingleHistory() {
        let url = self.history[0]
        if !url.isUrlWithBackGesture() {
            return
        }
        
        if isModalOpened() {
            return
        }
        
        if Netowrk.checkStatusCode(for: url) == 500 {
            return
        }
        self.hiddenWebView!.loadRequest(URLRequest(url: url))
    }
    
    private func isModalOpened() -> Bool {
        guard let webView = visibleWebView else {
            return false
        }
        
        let result = webView.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('modal in').length;")
        if let countString = result {
            if let count = Int(countString) {
                return count > 0
            }
        }
        
        return false
    }
    
    private func openPrintController(url: URL) {
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = "Faktura"
        printInfo.outputType = .general
        
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.showsNumberOfCopies = true
        printController.printingItem = url
    
        printController.present(animated: true, completionHandler: { (controller, success, error) in
            self.stopPrintIndicating()
        })
    }
    
    private func stopSpinning() {
        self.removeAnimationOfActivityIndicator()
        self.activityIndicatorView.isHidden = true
    }
    
    private func stopPrintIndicating() {
        self.isPrintStarted = false
    }
    
    private func showPdfNavigationBar(_ webView: UIWebView) {
        self.pdfNavigationBar.isHidden = false
        
        self.visibleWebView?.backgroundColor = UIColor.white
        self.hiddenWebView?.backgroundColor = UIColor.white
        
        if webView == self.myWebView {
            self.myWebViewTop.constant = self.pdfNavigationBar.bounds.height
        } else if webView == self.myWebView2 {
            self.myWebViewTop2.constant = self.pdfNavigationBar.bounds.height
        }
    }
    
    private func hidePdfNavigationBar() {
        self.pdfNavigationBar.isHidden = true
        
        self.visibleWebView?.backgroundColor = UIColor.clear
        self.hiddenWebView?.backgroundColor = UIColor.clear
        
        self.myWebViewTop.constant = 0.0
        self.myWebViewTop2.constant = 0.0
    }
    
    @IBAction func sharePressed(_ sender: UIBarButtonItem) {
        let currentUrl = self.visibleWebView!.request!.mainDocumentURL!
        if currentUrl.isPdf() {
            if let fileData = NSData(contentsOf: currentUrl) {
                
                let tmpDirURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
                let fileURL = tmpDirURL.appendingPathComponent("faktura").appendingPathExtension("pdf")
                let path = fileURL.absoluteString
                
                do {
                    let fileManager = FileManager.default
                    
                    if fileManager.fileExists(atPath: path) {
                        try fileManager.removeItem(atPath: path)
                    }
                    
                    try fileData.write(to: fileURL, options: .atomic)
                    
                    let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                    
                    if #available(iOS 11.0, *) {
                        activityViewController.excludedActivityTypes = [
                            .markupAsPDF,
                            .copyToPasteboard,
                            .airDrop
                        ]
                    } else {
                        activityViewController.excludedActivityTypes = [
                            
                        ]
                    }
                    
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    
                    self.present(activityViewController, animated: true, completion: nil)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension ViewController {
    
    fileprivate func prepareNavigationBar() {
        self.pdfNavigationBar.setValue(true, forKey: "hidesShadow")
        
        self.logoNavigationItem.image = UIImage(named: "logo-panel-mobile")?.withRenderingMode(.alwaysOriginal)
        
        self.hidePdfNavigationBar()
    }
    
    fileprivate func prepareWebView(_ webView: UIWebView, isFirst: Bool) {
        webView.delegate = self
        
        if isFirst {
            let urlRequest = URLRequest(url: URL(string: "https://www.faktury.co/faktury/site/login")!)
            webView.loadRequest(urlRequest)
            self.visibleWebView = webView
        } else {
            self.hiddenWebView = webView
        }
    }
    
    fileprivate func prepareActivityIndicatorView() {
        self.activityIndicatorView.layer.masksToBounds = true;
    }
    
    fileprivate func addAnimationToActivityIndicator() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = Config.activityIndicatorAnimationSpeed
        rotateAnimation.repeatCount = Float.greatestFiniteMagnitude;
        self.activityIndicatorImageView.layer.add(rotateAnimation, forKey: "anim")
    }
    
    fileprivate func removeAnimationOfActivityIndicator() {
        self.activityIndicatorImageView.layer.removeAnimation(forKey: "anim")
    }
    
    fileprivate func addDoubleTapGesture(to: UIWebView) {
        let tap = UITapGestureRecognizer()
        tap.delegate = self
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 2
        to.addGestureRecognizer(tap)
    }
    
    fileprivate func setActivityIndicatorImageViewFrame() {
        let size = self.activityIndicatorImageView.frame.size
        self.activityIndicatorImageView.frame.size = CGSize(width: size.height, height: size.height)
    }
    
    fileprivate func createFrames() {
        self.frameOutside = CGRect(x: -self.view.frame.width, y: self.myWebView.frame.origin.y, width: self.myWebView.frame.size.width, height: self.myWebView.frame.size.height)
        
        self.frameInside = CGRect(x: self.myWebView.frame.origin.x, y: self.myWebView.frame.origin.y, width: self.myWebView.frame.size.width, height: self.myWebView.frame.size.height)
    }
    
    fileprivate func reorganizeHierarchy() {
        self.view.bringSubviewToFront(self.hiddenWebView!)
        self.view.bringSubviewToFront(self.visibleWebView!)
        self.view.bringSubviewToFront(self.activityIndicatorView)
    }
    
    fileprivate func startTransitionAnimation() {
        self.visibleWebView!.isHidden = false
        self.hiddenWebView!.isHidden = false
        
        swap(&self.visibleWebView, &self.hiddenWebView)
        
        self.visibleWebView!.frame = self.frameOutside!
        self.hiddenWebView!.frame = self.frameInside!
        
        self.reorganizeHierarchy()
        
        UIView.animate(withDuration: Config.transitionAnimationSpeed, animations: {
            self.visibleWebView!.frame = self.frameInside!
            
        }, completion: { finished in
            self.visibleWebView!.isHidden = false
            self.hiddenWebView!.isHidden = true
            
            self.reorganizeHierarchy()
            
            if let url = self.hiddenWebView?.request?.url {
                if url.absoluteString.contains("/exportToPDF/id/") {
                    self.hidePdfNavigationBar()
                    self.navigationBarFix = 1
                }
                if url.absoluteString.contains("/raportPdf") {
                    self.hidePdfNavigationBar()
                    self.navigationBarFix = 1
                }
                if url.absoluteString.contains("/exportToPDF") {
                    self.hidePdfNavigationBar()
                    self.navigationBarFix = 1
                }
            }
            
            if self.visibleWebView?.request?.url?.absoluteString == "https://www.faktury.co/faktury/site/login" {
                self.loadUserData(self.visibleWebView!)
            }
        })
    }
    
    fileprivate func resetBounces() {
        self.myWebView.scrollView.bounces = false
        self.myWebView2.scrollView.bounces = false
    }
}
