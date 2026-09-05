#import "WelcomeManager.h"
#import "WelcomeViewController.h"

@interface WelcomeManager ()
@property (nonatomic, assign) BOOL isPresenting;
@end

@implementation WelcomeManager

+ (instancetype)sharedManager {
    static WelcomeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WelcomeManager alloc] init];
    });
    return manager;
}

- (void)startWelcomeIfNeeded {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"com.gkuhtov.WelcomeToJapan.hasSeenWelcome"]) {
        return;
    }
    if (self.isPresenting) {
        return;
    }
    [self presentWithRetryCount:0];
}

- (void)presentWithRetryCount:(NSInteger)retries {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = nil;
        for (UIWindow *win in [UIApplication sharedApplication].windows) {
            if (win.isKeyWindow) {
                keyWindow = win;
                break;
            }
        }
        if (!keyWindow && [UIApplication sharedApplication].windows.count > 0) {
            keyWindow = [UIApplication sharedApplication].windows.firstObject;
        }

        UIViewController *topVC = keyWindow.rootViewController;
        while (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }

        if (!topVC || !topVC.isViewLoaded || topVC.view.window == nil) {
            if (retries < 15) {
                [self presentWithRetryCount:retries + 1];
            }
            return;
        }

        self.isPresenting = YES;
        WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
        welcomeVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        welcomeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

        [topVC presentViewController:welcomeVC animated:YES completion:^{
            self.isPresenting = NO;
        }];
    });
}

@end
