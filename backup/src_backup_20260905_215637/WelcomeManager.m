#import "WelcomeManager.h"
#import "WelcomeViewController.h"

@interface WelcomeManager ()
@property (nonatomic, assign) BOOL isPresenting;
@property (nonatomic, assign) BOOL welcomeShownThisSession;
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
    if (self.welcomeShownThisSession || self.isPresenting) {
        return;
    }
    [self presentWelcomeWithRetry:0];
}

- (UIViewController *)topViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self topViewControllerFrom:[(UINavigationController *)vc visibleViewController]];
    }
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topViewControllerFrom:[(UITabBarController *)vc selectedViewController]];
    }
    if (vc.presentedViewController) {
        return [self topViewControllerFrom:vc.presentedViewController];
    }
    return vc;
}

- (void)presentWelcomeWithRetry:(NSInteger)retryCount {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
            if (retryCount < 20) {
                [self presentWelcomeWithRetry:retryCount + 1];
            }
            return;
        }

        UIWindow *targetWindow = nil;
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *win in windowScene.windows) {
                    if (win.isKeyWindow || (win.rootViewController && !win.hidden)) {
                        targetWindow = win;
                        break;
                    }
                }
            }
            if (targetWindow) break;
        }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if (!targetWindow) {
            for (UIWindow *win in [UIApplication sharedApplication].windows) {
                if (win.isKeyWindow || (win.rootViewController && !win.hidden)) {
                    targetWindow = win;
                    break;
                }
            }
        }
#pragma clang diagnostic pop

        UIViewController *rootVC = targetWindow.rootViewController;
        UIViewController *topVC = [self topViewControllerFrom:rootVC];

        if (!topVC || !topVC.isViewLoaded || topVC.view.window == nil) {
            if (retryCount < 20) {
                [self presentWelcomeWithRetry:retryCount + 1];
            }
            return;
        }

        self.isPresenting = YES;
        self.welcomeShownThisSession = YES;

        WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
        welcomeVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        welcomeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

        [topVC presentViewController:welcomeVC animated:YES completion:^{
            self.isPresenting = NO;
        }];
    });
}

@end
