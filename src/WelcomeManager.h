#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WelcomeManager : NSObject

+ (instancetype)sharedManager;
- (void)startWelcomeIfNeeded;
- (void)startWelcomeIfNeededOnWindow:(UIWindow *)window;

@end
