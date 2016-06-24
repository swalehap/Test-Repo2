
#import "UIView+NibLoading.h"

@implementation UIView (NibLoading)

+(UIView*) loadInstanceFromNib:(id)fileOwner { 
    
    UIView *result = nil; 
    //NSLog(@"[self class] >>>> %@",NSStringFromClass([self class]));
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:fileOwner options: nil]; 
    for (id anObject in elements) { 
        if ([anObject isKindOfClass:[self class]]) { 
            result = anObject;
            break;
        } 
    }
    return result;
}

@end