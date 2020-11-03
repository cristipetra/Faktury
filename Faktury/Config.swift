//
//  Config.swift
//  Faktury
//
//  Created by Factury co Test on 15/07/2017.
//  Copyright © 2017 Test Project. All rights reserved.
//

import Foundation

class Config {

    static let activityIndicatorAnimationSpeed = 1.0
    static let transitionAnimationSpeed = 0.09

    static let urlsWithoutTransitions: [String] = [
        // Strona główna
        "about:blank",
        "https://www.faktury.co/polityka-prywatnosci[?]modal=[0-9]",
        "https://www.faktury.co/regulamin[?]modal=[0-9]",

        // Okno logowania
        "https://www.faktury.co/faktury/site/logout",
        "https://www.faktury.co/faktury/site/login[?]password-remind=[0-9]",
        "https://www.faktury.co/faktury/site/login[?]registration=1",
        "https://www.faktury.co/faktury/site/login[?]activated=1",

        // Faktury
        "https://www.faktury.co/faktury/invoice",
        "https://www.faktury.co/faktury/invoice/create/type/([0-9])+",
        "https://www.faktury.co/faktury/invoice/summary/id/([0-9])+",
        "https://www.faktury.co/faktury/invoice/update/id/([0-9])+",
        "https://www.faktury.co/faktury/invoice/delete/id/([0-9])+",
        "https://www.faktury.co/faktury/invoice/copy/id/([0-9])+",
        "https://www.faktury.co/faktury/invoice/exportToPDF/id/([0-9])+",
        "https://www.faktury.co/faktury/invoice/raportPdf",
        "https://www.faktury.co/faktury/invoice/submitByEmail/id/([0-9])+",
        "https://www.faktury.co/faktury/invoice[?]q=",
        "https://www.faktury.co/faktury/invoice[?]period=[0-9]{0,4}[-]?[0-9]{0,2}&type=[0-9]?&status=*",
        "https://www.faktury.co/faktury/invoice/updateStatus/id/([0-9])+",

        // Faktura na podstawie WZ
        "https://www.faktury.co/faktury/invoice/createFromWZ/type/([0-9])+/contractorId/([0-9])+/documents/([0-9])+",
        "https://www.faktury.co/faktury/invoice/updateFromWz/id/([0-9])+",

        // Faktura końcowa
        "https://www.faktury.co/faktury/invoiceFinal/prepare/type/12",
        "https://www.faktury.co/faktury/invoiceFinal/create/type/12[?]contractor_id=([0-9])+",
        "https://www.faktury.co/faktury/invoiceFinal/summary/id/([0-9])+",
        "https://www.faktury.co/faktury/invoiceFinal/update/id/([0-9])+",
        "https://www.faktury.co/faktury/invoiceFinal/submitByEmail/id/([0-9])+",
        "https://www.faktury.co/faktury/invoiceFinal/exportToPDF/id/([0-9])+",
        "https://www.faktury.co/faktury/invoiceFinal/delete/id/([0-9])+",

        // Faktura korygująca
        "https://www.faktury.co/faktury/invoiceCorrection/create/type/([0-9])+[?]correctedInvoiceId=([0-9])+",
        "https://www.faktury.co/faktury/invoiceCorrection/update/id/([0-9])+",
        "https://www.faktury.co/faktury/invoiceCorrection/summary/id/([0-9])+",
        "https://www.faktury.co/faktury/invoiceCorrection/delete/id/([0-9])+",
        "https://www.faktury.co/faktury/invoiceCorrection/exportToPDF/id/([0-9])+",
        "https://www.faktury.co/faktury/invoiceCorrection/submitByEmail/id/([0-9])+",

        // WZ
        "https://www.faktury.co/faktury/wz",
        "https://www.faktury.co/faktury/wz/create",
        "https://www.faktury.co/faktury/wz/update/id/([0-9])+",
        "https://www.faktury.co/faktury/wz/exportToPDF/id/([0-9])+",
        "https://www.faktury.co/faktury/wz/prepareInvoice",
        "https://www.faktury.co/faktury/wz/submitByEmail/id/([0-9])+",
        "https://www.faktury.co/faktury/wz/summary/id/([0-9])+",
        "https://www.faktury.co/faktury/wz/delete/id/([0-9])+",
        "https://www.faktury.co/faktury/wz[?]period=&q=",
        "https://www.faktury.co/faktury/wz[?]period=[0-9]{0,4}[-]?[0-9]{0,2}&q=",

        // Magazyn
        "https://www.faktury.co/faktury/product",
        "https://www.faktury.co/faktury/product/create",
        "https://www.faktury.co/faktury/product/update/id/([0-9])+",
        "https://www.faktury.co/faktury/product/delete/id/([0-9])+",
        "https://www.faktury.co/faktury/product[?]q=",

        // Kontrehenci
        "https://www.faktury.co/faktury/contractor",
        "https://www.faktury.co/faktury/contractor/create",
        "https://www.faktury.co/faktury/contractor/update/id/([0-9])+",
        "https://www.faktury.co/faktury/contractor/delete/id/([0-9])+",
        "https://www.faktury.co/faktury/contractor[?]q=",

        // Ustawienia
        "https://www.faktury.co/faktury/settings",
    ]

    static let urlsWithActivityIndicator: [String] = [
        "https://www.faktury.co/faktury/invoice/exportToPDF/id/([0-9])+",
        "https://www.faktury.co/faktury/invoiceCorrection/exportToPDF/id/([0-9])+",
        "https://www.faktury.co/faktury/wz/exportToPDF/id/([0-9])+",
        "https://www.faktury.co/faktury/invoice/raportPdf",
        "https://www.faktury.co/faktury/product/raportPdf",
        "https://www.faktury.co/faktury/invoiceFinal/exportToPDF/id/([0-9])+",
        "https://www.faktury.co/faktury/invoicePartPayment/exportToPDF[?]id=[0-9]",
    ]

    static let urlsWithoutBackGesture: [String] = [
        "https://www.faktury.co/faktury/site/logout",

        // Rejestracja
        "https://www.faktury.co/rejestracja",
        "https://www.faktury.co/polityka-prywatnosci[?]modal=[0-9]",
        "https://www.faktury.co/regulamin[?]modal=[0-9]",

        // Ustawienia konta
        "https://www.faktury.co/faktury/settings",

        // Faktury
        "https://www.faktury.co/faktury/invoice/create/type/([0-9])+",
        "https://www.faktury.co/faktury/invoice/update/id/([0-9])+",
        "https://www.faktury.co/faktury/invoice/copy/id/([0-9])+",

        // Faktura końcowa
        "https://www.faktury.co/faktury/invoiceFinal/prepare/type/12",
        "https://www.faktury.co/faktury/invoiceFinal/update/id/([0-9])+",
        "https://www.faktury.co/faktury/invoiceFinal/create/type/12[?]contractor_id=([0-9])+",

        // Faktura korygująca
        "https://www.faktury.co/faktury/invoiceCorrection/create/type/([0-9])+[?]correctedInvoiceId=([0-9])+",
        "https://www.faktury.co/faktury/invoiceCorrection/update/id/([0-9])+",

        // WZ
        "https://www.faktury.co/faktury/wz/create",
        "https://www.faktury.co/faktury/wz/update/id/([0-9])+",
        "https://www.faktury.co/faktury/wz/prepareInvoice",
        "https://www.faktury.co/faktury/wz/prepareInvoice/contractorId/([0-9])+",
        "https://www.faktury.co/faktury/invoice/createFromWZ/type/([0-9])+/contractorId/([0-9])+/documents/([0-9])+",

        // Kontrahent
        "https://www.faktury.co/faktury/contractor/create",
        "https://www.faktury.co/faktury/contractor/update/id/([0-9])+",

        // Magazyn
        "https://www.faktury.co/faktury/product/create",
        "https://www.faktury.co/faktury/product/update/id/([0-9])+",
    ]
}
