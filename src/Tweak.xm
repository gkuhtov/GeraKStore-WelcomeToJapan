#import <UIKit/UIKit.h>
#import "WelcomeViewController.h"

%hook UIWindow

- (void)makeKeyAndVisible {
    %orig;

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"GeraKWelcomeDismissed"]) {
        return;
    }

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIWindow *window = (UIWindow *)self;
            if (window.rootViewController) {
                WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
                welcomeVC.view.frame = window.bounds;
                welcomeVC.view.alpha = 0.0;
                [window addSubview:welcomeVC.view];
                [UIView animateWithDuration:0.4 animations:^{
                    welcomeVC.view.alpha = 1.0;
                }];
            }
        });
    });
}

%end
