

#import "HttpHelper.h"
#import "JSON.h"
#import "Reachability.h"


@implementation HttpHelper

@synthesize strReqMethod;

#pragma mark -
#pragma mark - init methods

- (id) initWithRequestMethod:(NSString *)method
{   
	if ((self = [super init])) {
        self.strReqMethod=method;
    }
	return self;
}

#pragma mark -
#pragma mark - ASIFormDataRequest

-(void)getDataFromURL:(NSString *)url withBody:(NSMutableDictionary *)dictBody withBlock:(RequestCompletionBlock)block
{
    if(![self connected])
    {
        [APPDELEGATE hideHUDLoadingView];
        UIAlertView *connectionAlert = [[UIAlertView alloc] initWithTitle:@"Information !" message:@"App requires an internet connection, Please connect with wifi or internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [connectionAlert show];
        [connectionAlert release];
        return;
    }
    
    [ASIFormDataRequest clearSession];
    NSURL *aURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIrequest = [ASIFormDataRequest requestWithURL:aURL];
    [ASIrequest setTimeOutSeconds:3000];
    //[ASIrequest setPostFormat:ASIURLEncodedPostFormat];
    [ASIrequest setRequestMethod:self.strReqMethod];
    
    [ASIrequest setUseCookiePersistence:NO];
    [ASIrequest setUseSessionPersistence:NO];
    [ASIrequest setShouldAttemptPersistentConnection:NO];
    
    if (block) {
        dataBlock=[block copy];
    }
    [ASIrequest addRequestHeader:@"Accept" value:@"application/json"];
    //[ASIrequest addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
    
    if (dictBody) {
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *jsonString = [jsonWriter stringWithObject:dictBody];
        [jsonWriter release];
        [ASIrequest setPostBody:[NSMutableData dataWithData:[jsonString  dataUsingEncoding:NSUTF8StringEncoding]]];
        NSLog(@"Post Body %@",jsonString);
    }
    
    [ASIrequest setDelegate:self];
    [ASIrequest startAsynchronous];
}

-(void)getDataFromURL:(NSString *)url withParamData:(NSMutableDictionary *)dictParam withBlock:(RequestCompletionBlock)block
{
    if(![self connected])
    {
        [APPDELEGATE hideHUDLoadingView];
        UIAlertView *connectionAlert = [[UIAlertView alloc] initWithTitle:@"Information !" message:@"App requires an internet connection, Please connect with wifi or internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [connectionAlert show];
        [connectionAlert release];
        return;
    }
    
    if (block) {
        dataBlock=[block copy];
    }
    
    [ASIFormDataRequest clearSession];
    NSURL *aURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIrequest = [ASIFormDataRequest requestWithURL:aURL];
    [ASIrequest setTimeOutSeconds:3000];
    [ASIrequest setPostFormat:ASIURLEncodedPostFormat];
    [ASIrequest setRequestMethod:self.strReqMethod];
    
    [ASIrequest setUseCookiePersistence:NO];
    [ASIrequest setUseSessionPersistence:NO];
    [ASIrequest setShouldAttemptPersistentConnection:NO];
    
    if(dictParam != nil) {
        NSArray *allKey = [dictParam allKeys];
        for(int i=0; i<[allKey count]; i++) {
            NSString *key = [allKey objectAtIndex:i];
            NSString *value =[dictParam valueForKey:key];
            
            [ASIrequest setPostValue:value forKey:key];
        }
    }
    [ASIrequest setDelegate:self];
    [ASIrequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	
	NSString *receivedString = [request responseString];
    //receivedString=[NSString stringWithFormat:@"[%@]",receivedString];
    receivedString=[receivedString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
    DLog(@"requestFinished >> receivedString >> %@",receivedString);
    
    SBJSON *jsonParser = [[SBJSON alloc] init];
    id responceObject=[jsonParser objectWithString:receivedString error:nil];
    
    if (responceObject==nil && receivedString!=nil) {
        responceObject=receivedString;
    }
    
    if ([receivedString rangeOfString:@"<html>"].location!=NSNotFound)
    {
        NSLog(@"<html> Found");
        
        [[AppDelegate sharedAppDelegate]showToastMessage:@"Server is down! not able to take request at this time!"];
    }
    
    if(dataBlock)
    {
        dataBlock(responceObject,nil);
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
	
    if (dataBlock) {
        dataBlock(nil,request.error);
    }
}

#pragma mark -
#pragma mark - Internet Availability

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

#pragma mark -
#pragma mark - Memory Mgmt

- (void)dealloc
{
    [super dealloc];
}

@end


/* //for image upload
 //if ([arrImages count] > 0) {
 NSData *dataImage = UIImageJPEGRepresentation([UIImage imageNamed:@""],1);
 
 NSString *strURL = @"Write Your URL Here.";
 ASIrequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
 
 [ASIrequest setTimeOutSeconds:3000];
 [ASIrequest setRequestMethod:@"POST"];
 [ASIrequest setUseCookiePersistence:NO];
 [ASIrequest setUseSessionPersistence:NO];
 [ASIrequest setShouldAttemptPersistentConnection:NO];
 
 [ASIrequest setDelegate:self];
 
 
 [ASIrequest setPostValue:@"This is sample text..." forKey:@"text"];
 
 
 //for (int i = 0; i < [arrImages count]; i++) {
 [ASIrequest addData:dataImage withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:@"image"];
 //}
 [ASIrequest startAsynchronous];
 //}
 
 */

/*
 
 -(void)getDataFromURL:(NSString *)url
 withReqData:(NSMutableDictionary *)dictReqData
 loginSuccess:(DataBlock)success
 loginFail:(DataBlock)fail
 {
 NSURL *aURL = [NSURL URLWithString:url];
 ASIrequest = [ASIFormDataRequest requestWithURL:aURL];
 [ASIrequest setTimeOutSeconds:3000];
 //    [requestMain setPostFormat:ASIMultipartFormDataPostFormat];
 [ASIrequest setRequestMethod:self.strReqMethod];
 [ASIrequest setUseCookiePersistence:NO];
 [ASIrequest setUseSessionPersistence:NO];
 [ASIrequest setShouldAttemptPersistentConnection:NO];
 
 if(dictReqData != nil) {
 NSString *newData=[NSString stringWithFormat:@"data=%@",[dictReqData JSONRepresentation]];
 NSMutableData *requestData = [NSMutableData dataWithBytes:[newData UTF8String] length:[newData length]];
 [ASIrequest setPostBody:requestData];
 }
 
 [ASIrequest setDelegate:self];
 [ASIrequest startAsynchronous];
 
 if(success)
 {
 dataSuccessHandler = [success copy];
 }
 if(fail)
 {
 dataFailHandler = [fail copy];
 }
 
 }
 */

