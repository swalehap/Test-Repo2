
#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void (^RequestCompletionBlock)(id response, NSError *error);


@interface HttpHelper : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *webData;

    //for ASIRequest
    ASIFormDataRequest *ASIrequest;
    
    NSString *strReqMethod;
    
    //blocks
    RequestCompletionBlock dataBlock;
    
}
@property(nonatomic,copy)NSString *strReqMethod;

- (id) initWithRequestMethod:(NSString *)method;

-(void)getDataFromURL:(NSString *)url withBody:(NSMutableDictionary *)dictBody withBlock:(RequestCompletionBlock)block;

-(void)getDataFromURL:(NSString *)url withParamData:(NSMutableDictionary *)dictParam withBlock:(RequestCompletionBlock)block;

@end