@class ParseStarterProjectViewController;

static NSInteger _badgeValue = 0;

@interface AppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet ParseStarterProjectViewController *viewController;

+ (void) setShoppingCartTabBadgeValue:(NSInteger) value;
+ (NSString *) getBadgeValue;
@end
