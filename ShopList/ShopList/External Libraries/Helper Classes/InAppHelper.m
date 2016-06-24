//
//  InAppHelper.m
//  LDS WedList
//
//  Created by Jignesh on 10/11/13.
//  Copyright (c) 2013 Jigs. All rights reserved.
//

#import "InAppHelper.h"


@implementation InAppHelper

#pragma mark -
#pragma mark - Init

-(id)init
{
    self=[super init];
    if (self) {
        allValidProducts=[[NSMutableDictionary alloc]init];
        [self fetchAvailableProducts];
    }
    return self;
}

+ (InAppHelper *)sharedObject
{
    static InAppHelper *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[InAppHelper alloc] init];
    });
    return object;
}

#pragma mark -
#pragma mark - GetAll Product

-(void)fetchAvailableProducts
{
    isFetching=TRUE;
    NSSet *productIdentifiers = [NSSet
                                 setWithObjects:INAPP_PRODUCT_CREATEWARDGROUP,
                                 INAPP_PRODUCT_UNLIMITED,
                                 //INAPP_PRODUCT_DONATE,
                                 INAPP_PRODUCT_DONATE10,
                                 INAPP_PRODUCT_DONATE25,
                                 INAPP_PRODUCT_DONATE5,
                                 INAPP_PRODUCT_DONATE50,
                                 INAPP_PRODUCT_PRESIDENCYTOOLS,
                                 INAPP_PRODUCT_DISTRICTLEADER,
                                 INAPP_PRODUCT_REPORTS,
                                 nil];
    productsRequest = [[SKProductsRequest alloc]
                       initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

-(void)fetchAvailableProductsWithBlock:(ProductResult)block
{
    dataBlockProductResult=[block copy];
    if (!isFetching) {
        [self fetchAvailableProducts];
    }
}

-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response
{
    int count = [response.products count];
    if (count>0) {
        
        for (NSString *key in [allValidProducts allKeys]) {
            [allValidProducts removeObjectForKey:key];
        }
        
        for (int i=0; i<response.products.count; i++)
        {
            SKProduct *validProduct = [response.products objectAtIndex:i];
            [allValidProducts setObject:validProduct forKey:validProduct.productIdentifier];
        }
        if (dataBlockProductResult) {
            dataBlockProductResult(TRUE);
        }
    }
    else {
        if (dataBlockProductResult) {
            dataBlockProductResult(FALSE);
        }
        DLog(@"No products to purchase");
    }
    isFetching=FALSE;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    DLog(@"request failed: %@,  %@", request, error);
    if (dataBlockProductResult) {
        dataBlockProductResult(FALSE);
    }
    isFetching=FALSE;
}

#pragma mark -
#pragma mark - PurcheseProduct

-(void)purchaseProduct:(NSString *)productName withBlock:(PurchaseResult)block
{
    dataBlock=[block copy];
    if ([allValidProducts objectForKey:productName]!=nil) {
        [self purchaseMyProduct:[allValidProducts objectForKey:productName]];
    }
    else{
        if (dataBlock) {
            dataBlock(TransactionNoProduct);
        }
    }
}

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseMyProduct:(SKProduct*)product
{
    if ([self canMakePurchases]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Purchases are disabled in your device" message:nil delegate:
                                  self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}

#pragma mark -
#pragma mark - StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                DLog(@"Purchasing");
                if (dataBlock) {
                    dataBlock(TransactionPurchasing);
                }
                break;
            case SKPaymentTransactionStatePurchased:
                /*
                if ([transaction.payment.productIdentifier
                     isEqualToString:INAPP_PRODUCT_CREATEGROUP])
                {
                    DLog(@"Purchased ");
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Purchase is completed succesfully" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }
                 */
                if (dataBlock) {
                    dataBlock(TransactionPurchased);
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                DLog(@"Restored ");
                if (dataBlock) {
                    dataBlock(TransactionRestored);
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                DLog(@"Purchase failed ");
                if (dataBlock) {
                    dataBlock(TransactionFailed);
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            default:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}



@end
