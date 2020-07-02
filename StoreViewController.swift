//
//  StoreViewController.swift
//  Meditation Color Timer
//
//  Created by Joe Martin on 04/01/2019.
//  Copyright © 2019 Joe Martin. All rights reserved.
//

import UIKit
import StoreKit

class StoreViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {




	@IBOutlet weak var inAppPurchaseLabel: UILabel!
	@IBOutlet weak var productTitle: UILabel!
	@IBOutlet weak var productDescription: UITextView!
	@IBOutlet weak var purchaseButton: UIButton!
	@IBOutlet weak var restoreButton: UIButton!
	@IBOutlet weak var dismissButton: UIButton!
	@IBOutlet weak var purchaseScreenLogo: UIImageView!


	let save = UserDefaults.standard

	var product: SKProduct?

	var productID = "meditationCTIAPFEB2019"

	override func viewDidLoad() {
		super.viewDidLoad()

		purchaseScreenLogo.layer.cornerRadius = 10

		getPurchaseInfo()

		if save.value(forKey: "Purchase") == nil {

			purchaseButton.isEnabled = true
			purchaseButton.isHidden = false
			purchaseButton.alpha = 1
			restoreButton.isEnabled = true
			restoreButton.isHidden = false
			restoreButton.alpha = 1

		} else {

			purchaseButton.isEnabled = false
			purchaseButton.isHidden = true
			purchaseButton.alpha = 0
			restoreButton.isEnabled = false
			restoreButton.isHidden = true
			restoreButton.alpha = 0
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		SKPaymentQueue.default().add(self)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		SKPaymentQueue.default().remove(self)
	}

	@IBAction func dismissView(_ sender: Any) {

		self.dismiss(animated: true, completion: nil)
	}

	func getPurchaseInfo() {

		if SKPaymentQueue.canMakePayments() {
			let request = SKProductsRequest(productIdentifiers: NSSet(objects: self.productID) as! Set<String>)
			request.delegate = self
			request.start()
		} else {
			productTitle.text = "Restrictions Enabled"
			productDescription.text = "Go to Settings > General > Restrictions \n to allow In-App Purchases."
		}
	}

	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {

		var products = response.products
		if (products.count == 0) {
			productTitle.text = "Sorry"
			productDescription.text = "This product is currently not available on the App Store."
			purchaseButton.isHidden = true
			purchaseButton.isEnabled = false
			purchaseButton.alpha = 0
			restoreButton.isHidden = true
			restoreButton.isEnabled = false
			restoreButton.alpha = 0
		} else {
			product = products[0]
			productTitle.text = product!.localizedTitle
			productDescription.text = product!.localizedDescription
			restoreButton.isHidden = false
			restoreButton.isEnabled = true
			restoreButton.alpha = 1
		}

		let invalids = response.invalidProductIdentifiers
		for product in invalids {
			print("product not found: \(product)")
		}
	}

	private func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct){

		let payment = SKPayment(product: product)
		SKPaymentQueue.default().add(payment)
	}

	@IBAction func purchase(_ sender: Any) {

		let payment = SKPayment(product: product!)

		purchaseButton.isHidden = true
		SKPaymentQueue.default().add(payment)
	}

	@IBAction func restore(_ sender: Any) {

		restoreButton.isHidden = true
		SKPaymentQueue.default().restoreCompletedTransactions()
	}

	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {

		for transaction in transactions {

			switch transaction.transactionState {

			case SKPaymentTransactionState.purchasing:
				productTitle.text = "Please Wait"
				productDescription.text = "Your In-App Purchase is currently being processed by the App Store."

			case SKPaymentTransactionState.purchased:
				SKPaymentQueue.default().finishTransaction(transaction)
				productTitle.text = "Thank You"
				productDescription.text = "Your In-App Purchase was successful"

				let save = UserDefaults.standard
				save.set(true, forKey: "Purchase")
				save.synchronize()

			case SKPaymentTransactionState.restored:
				SKPaymentQueue.default().finishTransaction(transaction)
				productTitle.text = "Thank you"
				productDescription.text = "Your In-App Purchase has been restored"

				let save = UserDefaults.standard
				save.set(true, forKey: "Purchase")
				save.synchronize()

			case SKPaymentTransactionState.deferred:
				productTitle.text = "Further Action Needed"
				productDescription.text = "You are not allowed to make In-App Purchases. Please alert an account holder to proceed"

			case SKPaymentTransactionState.failed:

				guard let error = transaction.error as? SKError else {return}

				switch error.code {

				case SKError.Code.paymentCancelled:
					productTitle.text = "In-App Purchase Cancelled"
					productDescription.text = " User cancelled the transaction. No payment has been made"

					purchaseButton.isEnabled = true
					purchaseButton.isHidden = false
					restoreButton.isHidden = false

					SKPaymentQueue.default().finishTransaction(transaction)
					SKPaymentQueue.default().remove(self)

				case SKError.Code.clientInvalid:
					productTitle.text = "Error: Invalid Client"
					productDescription.text = "You are not permitted to authorize In-App Purchases from this device. No payment has been made"

					purchaseButton.isEnabled = true
					purchaseButton.isHidden = false
					restoreButton.isHidden = false

					SKPaymentQueue.default().finishTransaction(transaction)
					SKPaymentQueue.default().remove(self)

				case SKError.Code.paymentInvalid:
					productTitle.text = "Error: Payment Invalid"
					productDescription.text = "Your payment details were incomplete. No payment has been made"

					purchaseButton.isEnabled = true
					purchaseButton.isHidden = false
					restoreButton.isHidden = false

					SKPaymentQueue.default().finishTransaction(transaction)
					SKPaymentQueue.default().remove(self)

				case SKError.Code.paymentNotAllowed:
					productTitle.text = "Error: Purchase Failed"
					productDescription.text = "In-App Purchases are not permitted from this device. No payment has been made"

					purchaseButton.isEnabled = true
					purchaseButton.isHidden = false
					restoreButton.isHidden = false

					SKPaymentQueue.default().finishTransaction(transaction)
					SKPaymentQueue.default().remove(self)

				case SKError.Code.storeProductNotAvailable:
					productTitle.text = "App Store Product Unavailable"
					productDescription.text = "This product is currently unavailable on the App Store. Please download the free app and use the 'In-App Purchase' within the app."

					purchaseButton.isEnabled = true
					purchaseButton.isHidden = false
					restoreButton.isHidden = false

					SKPaymentQueue.default().finishTransaction(transaction)
					SKPaymentQueue.default().remove(self)

				case SKError.Code.unknown:
					productTitle.text = "Error: Purchase Failed"
					productDescription.text = "Error code: \(String(describing: transaction.error)). No payment has been made"

					purchaseButton.isEnabled = true
					purchaseButton.isHidden = false
					restoreButton.isHidden = false

					SKPaymentQueue.default().finishTransaction(transaction)
					SKPaymentQueue.default().remove(self)

				default:
					break
				}
            @unknown default:
                break
              
            }
		}
	}
}
