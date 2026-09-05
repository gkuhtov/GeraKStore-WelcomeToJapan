#import <UIKit/UIKit.h>
#import "WelcomeManager.h"

%hook UIWindow

- (void)makeKeyAndVisible {
    %orig;
    
    // Как только окно становится ключевым и видимым, инициируем показ
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[WelcomeManager sharedManager] startWelcomeIfNeededOnWindow:self];
        });
    });
}

%end

%ctor {
    // Страховочный слушатель на случай, если окно уже было создано до загрузки твика
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
        [[WelcomeManager sharedManager] startWelcomeIfNeeded];
    }];
}
