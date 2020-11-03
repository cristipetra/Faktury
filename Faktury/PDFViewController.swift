////  PDFViewController.swift
//  Faktury
//
//  Created by Pawel Stachurski on 6/2/20.
//  Copyright © 2020 DKSH . All rights reserved.
//

import UIKit
import WebKit

class PDFViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var loaderView: UIActivityIndicatorView!
    @IBOutlet var exportButton: UIBarButtonItem!
    @IBOutlet var dismissButton: UIBarButtonItem!
    @IBOutlet var printButton: UIBarButtonItem!
    
    var fileURL: URL?
    var downloadDocFileURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.downloadPDFFileFromServer()
    }
    
    fileprivate func downloadPDFFileFromServer() {
        guard let fileURL = self.fileURL else {
            self.hideLoader(enable: false)
            return
        }
        self.showLoader(enable: false)
        Netowrk.downloadFileFromServer(downloadFileURL: fileURL, filename: fileURL.lastPathComponent, extension: "pdf") { [weak self] (pdfFileURL, error) in
            guard let self = self else {return}
            if let error = error {
                self.hideLoader(enable: false)
                print(error)
                return
            }
            guard let pdfFileURL = pdfFileURL else {
                self.hideLoader(enable: false)
                print("Invalid or corrupted file")
                return
            }
            self.downloadDocFileURL = pdfFileURL
            self.webView.load(URLRequest(url: pdfFileURL))
            self.hideLoader(enable: true)
        }
    }
    
    fileprivate func showLoader(enable: Bool) {
        self.exportButton.isEnabled = enable
        self.printButton.isEnabled = enable
        self.loaderView.startAnimating()
        self.webView.isHidden = !enable
    }
    
    fileprivate func hideLoader(enable: Bool) {
        self.exportButton.isEnabled = enable
        self.printButton.isEnabled = enable
        self.loaderView.stopAnimating()
        self.webView.isHidden = !enable
    }
    
    fileprivate func showPrintPreview() {
        guard let fileURL = self.downloadDocFileURL else {return}
        if UIPrintInteractionController.canPrint(fileURL) {
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = fileURL.lastPathComponent
            printInfo.outputType = .general
            
            let printController = UIPrintInteractionController.shared
            printController.printInfo = printInfo
            printController.showsNumberOfCopies = true
            printController.printingItem = fileURL
            
            printController.present(animated: true, completionHandler: nil)
        }
    }
    
    fileprivate func showExportPDFView() {
        guard let fileURL = self.downloadDocFileURL else {return}
        let exportVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        self.present(exportVC, animated: true, completion: nil)
    }

    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exportAction(_ sender: Any) {
        self.showExportPDFView()
    }
    
    @IBAction func printAction(_ sender: Any) {
        self.showPrintPreview()
    }
    
    deinit {
        print("PDFViewController deinit")
    }
}
