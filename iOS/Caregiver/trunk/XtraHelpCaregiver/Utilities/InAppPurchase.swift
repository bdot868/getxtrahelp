//
//  InAppPurchase.swift
//  WalknTours
//
//  Created by mac on 31/10/18.
//  Copyright © 2018 WalknTours. All rights reserved.
//

import UIKit
import StoreKit
import SVProgressHUD

public typealias ProductIdentifier = String

class InAppPurchase: NSObject {

    //MARK: - varibales
    static let sharedInstance = InAppPurchase()
    fileprivate var productsRequest : SKProductsRequest?
    fileprivate var iapProducts = [SKProduct]()
    var product_id: NSString?
    var productArr : [String] = [String]()

    //MARK: - Init Method
    override init() {
        super.init()
        self.productsRequest = SKProductsRequest()
        SKPaymentQueue.default().add(self)
        
    }
    //MARK: - InAppPurchase Methods
    //verify All InAppPurchase Products
    func verifyAllAvailableProducts(){
        
        if SKPaymentQueue.canMakePayments() {
           /* for i in stride(from: 0, to: WalknTours.sharedInstance.IAPProductArr.count, by: 1) {
                let product = WalknTours.sharedInstance.IAPProductArr[i] as IAPProduct
                self.productArr.append(product.productionId)
            }*/
            if(self.productArr.count > 0) {
                let productIdentifiers = Set(self.productArr)
                //print(productIdentifiers)
                let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productIdentifiers )
                productsRequest.delegate = self
                productsRequest.start()
                //print("Fetching Products")
            }
        }
        else {
            print("Сan't make purchases")
        }
    }
    //Buy Products
    func buyProduct(_ product: SKProduct) {
        // Sending the Payment Request to Apple
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        SVProgressHUD.show()
    }
    // MARK: - RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func removeObserverforInAppp()
    {
        SKPaymentQueue.default().remove(self)
    }
}
//MARK: - Payment Transaction Delegates Methods
extension InAppPurchase : SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("Received Payment Transaction Response from Apple");
        
        for transaction: AnyObject in transactions {
            if let trans: SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    SVProgressHUD.dismiss()
                    self.generateReceiptUrl(transaction: trans)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                case .failed:
                    print("Purchased Failed")
                    SVProgressHUD.dismiss()
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                case .restored:
                    print("Product Restored")
                    SVProgressHUD.dismiss()
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default:
                    print("default")
                    //SVProgressHUD.dismiss()
                    break
                }
            }
            else {
                print("error")
            }
        }
    }
    
    //Generate Payment Receipt Data
    func generateReceiptUrl(transaction:SKPaymentTransaction){
        /*if let receiptURL = Bundle.main.appStoreReceiptURL {
            let receipt:Data = try! Data(contentsOf: receiptURL)
            let jsonObjectString : String!
            jsonObjectString = receipt.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            let strIdentifier:String!
            strIdentifier = transaction.transactionIdentifier!
            let pIdentifire : String!
            pIdentifire = transaction.payment.productIdentifier
        }*/
    }
    
}

//MARK: - SKProductsRequest Delegate Methods
extension InAppPurchase : SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Got the request from Apple")
        response.invalidProductIdentifiers.forEach() { id in
            //here is the part that could fail sometimes
            print(id)
        }
        let count: Int = response.products.count
        if count > 0 {
            //let myProduct = response.products
            //Fetch IAP Product Array
        }
        else {
            print("No products")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error %@ \(error)")
    }
}
