#import <UIKit/UIKit.h>

@interface WelcomeManager : NSObject
+ (instancetype)sharedManager;
- (void)startWelcomeIfNeeded;
@end
