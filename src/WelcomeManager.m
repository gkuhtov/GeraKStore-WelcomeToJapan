#import "WelcomeManager.h"
#import "WelcomeViewController.h"
#import "WelcomeConfig.h"

@interface WelcomeManager ()
@property (nonatomic, assign) BOOL welcomeShownThisSession;
@end

@implementation WelcomeManager

+ (instancetype)sharedManager {
    static WelcomeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _welcomeShownThisSession = NO;
    }
    return self;
}

- (BOOL)hasSeenWelcome {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"com.gkuhtov.WelcomeToJapan.hasSeenWelcome"];
}

- (void)startWelcomeIfNeeded {
    [self startWelcomeIfNeededOnWindow:nil];
}

- (void)startWelcomeIfNeededOnWindow:(UIWindow *)targetWindow {
    if (self.welcomeShownThisSession || [self hasSeenWelcome]) {
        return;
    }

    UIWindow *window = targetWindow;
    if (!window) {
        window = [self findKeyWindow];
    }

    if (!window || !window.rootViewController) {
        return;
    }

    UIViewController *topVC = [self topViewControllerFrom:window.rootViewController];
    if (!topVC || [topVC isKindOfClass:[WelcomeViewController class]]) {
        return;
    }

    // Фиксируем показ для текущей сессии
    self.welcomeShownThisSession = YES;

    WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
    welcomeVC.modalPresentationStyle = UIModalPresentationFullScreen;
    welcomeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [topVC presentViewController:welcomeVC animated:NO completion:nil];
}

- (UIWindow *)findKeyWindow {
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
    }

    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            return window;
        }
    }

    return [UIApplication sharedApplication].delegate.window;
}

- (UIViewController *)topViewControllerFrom:(UIViewController *)rootVC {
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)rootVC;
        return [self topViewControllerFrom:nav.visibleViewController];
    }

    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)rootVC;
        return [self topViewControllerFrom:tab.selectedViewController];
    }

    if (rootVC.presentedViewController && !rootVC.presentedViewController.isBeingDismissed) {
        return [self topViewControllerFrom:rootVC.presentedViewController];
    }

    return rootVC;
}

@end
