//
//  L10n.swift
//  Buyza App
//

import Foundation

enum L10n: String, CaseIterable {
    // Common
    case ok
    case error
    case cancel
    case remove
    case delete
    case clear
    case clearAll
    case apply
    case reset
    case change
    case save
    case saveChanges
    case next
    case getStarted
    case active
    case items
    case any
    case allTypes
    case allBrands
    case filters
    case defaultLabel

    // Tabs & navigation
    case home
    case favorites
    case orders
    case settings
    case search

    // Auth
    case welcomeBack
    case signInSubtitle
    case emailAddress
    case password
    case forgotPassword
    case signIn
    case signOut
    case newToBuyza
    case createAccount
    case or
    case continueWithGoogle
    case continueAsGuest
    case signUp
    case joinBuyza
    case alreadyHaveAccount
    case fullName
    case confirmPassword
    case registrationIssue
    case checkYourEmail
    case verificationEmailSent
    case authenticationIssue
    case resetPassword
    case resetPasswordSubtitle
    case sendResetLink
    case emailSent
    case passwordResetSent

    // Home
    case buyza
    case categories
    case brands
    case featuredProducts
    case searchPlaceholder

    // Favorites
    case noFavoritesYet
    case removeFromFavorites
    case removeFromFavoritesMessage

    // Search & collections
    case searchProducts
    case searchIn
    case allProducts
    case noProductsFound
    case noProductsMatchSearch
    case noProductsMatchFilters
    case categoryFilter
    case brandFilter

    // Cart
    case shoppingCart
    case clearCart
    case clearCartMessage
    case removeItem
    case removeItemMessage
    case emptyCart
    case emptyCartSubtitle
    case startShopping
    case subtotal
    case shipping
    case total
    case proceedToPayment
    case calculatedAtCheckout
    case addedToCart

    // Product detail
    case addToCart
    case buyNow
    case secureCheckout
    case selectSize
    case colorLabel
    case productInformation
    case shippingReturns
    case careInstructions

    // Guest prompts
    case signInRequired
    case signInRequiredMessage
    case signInRequiredFavoritesMessage
    case signInRequiredGuestMessage

    // Orders
    case myOrders
    case noOrders
    case noOrdersSubtitle
    case orderItemsSingular
    case orderItemsPlural
    case noItems
    case moreItems

    // Payment
    case checkout
    case placeOrder
    case paymentMethod
    case deliveryAddress
    case orderSummary
    case promoCode
    case couponApplied
    case paymentSuccessful
    case orderConfirmed
    case orderPlaced
    case codMessage
    case cashOnDelivery
    case exactChange
    case continueShopping

    // Addresses
    case selectAddress
    case addNewAddress
    case noSavedAddresses
    case noSavedAddressesSubtitle
    case addFirstAddress
    case deliveryAddressTitle
    case deliveryAddressSubtitle
    case addAddress
    case editAddress
    case editAddressSubtitle
    case saveAddress
    case addressSaved
    case addressUpdated
    case addressSavedMessage
    case addressUpdatedMessage
    case deleteAddress
    case deleteAddressMessage
    case country
    case city
    case state
    case province
    case setAsDefault
    case defaultAddressHint
    case streetAddress
    case unitedStates
    case canada
    case continueToPayment

    // Settings & profile
    case editProfile
    case language
    case logout
    case logoutConfirmation
    case logoutMessage
    case firstName
    case lastName
    case email
    case phone
    case profileUpdated
    case loadingProfile
    case firstNameRequired

    // Onboarding
    case onboarding1Title
    case onboarding1Description
    case onboarding2Title
    case onboarding2Description
    case onboarding3Title
    case onboarding3Description

    // Ads / Events
    case event1Title
    case event1Subtitle
    case event1Button
    case event2Title
    case event2Subtitle
    case event2Button
    case event3Title
    case event3Subtitle
    case event3Button
    case event4Title
    case event4Subtitle
    case event4Button

    // Filters
    case productType
    case brandVendor
    case priceRange
    case minPrice
    case maxPrice
    case availability
    case published
    case status
    case sortBy
    case recommended
    case priceLowToHigh
    case priceHighToLow
    case titleAZ
    case publishedAny
    case publishedPublished
    case publishedUnpublished
    case statusActive
    case statusArchived
    case statusDraft

    // Additional
    case orderNumber
    case discount
    case postalCode
    case zipCode
    case failedUpdateFavorites
    case failedRemoveFavorites
    case passwordsDoNotMatch
    case invalidCouponCode
    case checkoutNotReady
    case failedPlaceOrder
    case paymentNotCompleted
    case paymentCancelled
    case couldNotVerifyPayment
    case creditDebitCard

    func text(for language: AppLanguage) -> String {
        L10nTranslations.value(for: self, language: language)
    }
}
