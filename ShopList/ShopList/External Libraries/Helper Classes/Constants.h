
typedef enum {
    ButtonClickedBack=0,
    ButtonClickedDasbord,
    ButtonClickedMsg,
    ButtonClickedSetting
} ButtonClicked;

//Api Url
//#define APIURL      @"http://hometeachingreporter.com/controller/controller.php"// OLD DATABASE
#define APIURL      @"http://home-teaching-reporter.com/app/mvc/controller.php"//NEW DATABASE
//#define APIURL      @"http://hometeachingreporter.com/test/controller/controller.php"//Test

//AppDelegate
#define APPDELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])
//UserDefault
#define USERDEFAULT [NSUserDefaults standardUserDefaults]

//Colors
#define COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define COLORBlue(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define ColorSliderRow [UIColor colorWithRed:(29.0/255) green:(110.0/255) blue:(185.0/255) alpha:1.0]
#define ColorSliderSection [UIColor colorWithRed:(20.0/255) green:(72.0/255) blue:(124.0/255) alpha:1.0]


#define ColorTaught [UIColor colorWithRed:(0.0/255) green:(255.0/255) blue:(0.0/255) alpha:1.0]
#define ColorNotTaught [UIColor colorWithRed:(255.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0]
#define ColorUnrepoted [UIColor colorWithRed:(170.0/255) green:(170.0/255) blue:(170.0/255) alpha:1.0]

#define Index @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"

#define HEADERINDEX [[NSArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil]

#define CHARTCOLOR [[NSArray alloc] initWithObjects:ColorTaught,ColorNotTaught,ColorUnrepoted, nil]

//iPhone5 helper
#define isiPhone5 ([UIScreen mainScreen].bounds.size.height == 568.0)
#define ASSET_BY_SCREEN_HEIGHT(regular) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : [regular stringByAppendingString:@"-568h"])

//#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )

//iPhone Or iPad
#define IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define SET_XIB(regular) (IS_IPHONE ? regular : [regular stringByAppendingString:@"_iPad"])

//iOS7 Or less
#define ISIOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)

//Api Methods
#define POST_METHOD             @"POST"
#define GET_METHOD              @"GET"
#define PUT_METHOD              @"PUT"

//DateFormate
#define DateFormat  @"yyyy-mm-dd HH:MM:SS"//"2013-09-13 14:02:49"

#define DATE_MONTH @"y-MM-dd"

//Log helper
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif


//Font Helper
#define FONT_CELL_BOLD [UIFont boldSystemFontOfSize:(IS_IPHONE)?12.0:20.0]
#define FONT_CELL_REGULAR [UIFont systemFontOfSize:(IS_IPHONE)?12.0:20.0]

//User Default Helper
extern NSString *const UD_USERID;
extern NSString *const UD_PASSWORD;
extern NSString *const UD_GROUPID;
extern NSString *const UD_FIRSTNAME;
extern NSString *const UD_LASTNAME;
extern NSString *const UD_OWNER;
extern NSString *const UD_ADMIN;
extern NSString *const UD_REPORTTOOLS;
extern NSString *const UD_EMAIL;
extern NSString *const UD_PHONE;

