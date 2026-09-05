#import <UIKit/UIKit.h>
#import "WelcomeManager.h"

__attribute__((constructor))
static void WelcomeToJapanInit(void) {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
        [[WelcomeManager sharedManager] startWelcomeIfNeeded];
    }];
}
