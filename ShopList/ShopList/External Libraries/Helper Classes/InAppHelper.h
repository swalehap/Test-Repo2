//
//  InAppHelper.h
//  LDS WedList
//
//  Created by Jignesh on 10/11/13.
//  Copyright (c) 2013 Jigs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

/*
#define INAPP_PRODUCT_ADMINACCESS   @"AdminAccess"
#define INAPP_PRODUCT_CREATEGROUP   @"CreateGroup"
*/

#define INAPP_PRODUCT_CREATEWARDGROUP       @"CreateWardGroup"//CreateGroup
#define INAPP_PRODUCT_UNLIMITED             @"UnlimitedAccess1"
//#define INAPP_PRODUCT_DONATE                @"donate"
#define INAPP_PRODUCT_DONATE10              @"Donate10"
#define INAPP_PRODUCT_DONATE25              @"Donate25"
#define INAPP_PRODUCT_DONATE5               @"Donate5"
#define INAPP_PRODUCT_DONATE50              @"Donate50"
#define INAPP_PRODUCT_PRESIDENCYTOOLS       @"PresidencyTools"//AdminAccess
#define INAPP_PRODUCT_DISTRICTLEADER        @"DLAccess"//DistrictLeaderAccess
#define INAPP_PRODUCT_REPORTS               @"Reports"

typedef enum {
    TransactionPurchasing=0,
    TransactionPurchased,
    TransactionRestored,
    TransactionFailed,
    TransactionNoProduct
} Transaction;

typedef void (^PurchaseResult)(Transaction result);
typedef void (^ProductResult)(BOOL result);

@interface InAppHelper : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProductsRequest *productsRequest;
    NSMutableDictionary *allValidProducts;
    BOOL isFetching;
    //blocks
    PurchaseResult dataBlock;
    ProductResult dataBlockProductResult;
}

+ (InAppHelper *)sharedObject;

- (void)fetchAvailableProducts;
-(void)fetchAvailableProductsWithBlock:(ProductResult)block;
-(void)purchaseProduct:(NSString *)productName withBlock:(PurchaseResult)block;

/*
- (BOOL)canMakePurchases;
- (void)purchaseMyProduct:(SKProduct*)product;
*/



@end
