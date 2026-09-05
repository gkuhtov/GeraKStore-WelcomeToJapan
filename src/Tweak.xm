#import <UIKit/UIKit.h>
#import "WelcomeManager.h"

%ctor {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            [[WelcomeManager sharedManager] startWelcomeIfNeeded];
        } else {
            [[NSNotificationCenter defaultCenter] addObserver:[WelcomeManager sharedManager]
                                                     selector:@selector(startWelcomeIfNeeded)
                                                         name:UIApplicationDidBecomeActiveNotification
                                                       object:nil];
        }
    });
}
