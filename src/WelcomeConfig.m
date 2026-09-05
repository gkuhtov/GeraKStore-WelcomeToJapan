#import "WelcomeConfig.h"

@implementation WelcomeConfig

+ (instancetype)sharedConfig {
    static WelcomeConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[WelcomeConfig alloc] init];
        config.headlineText = @"Добро пожаловать";
        config.sublineText = @"Подготовлено и распространяется через GeraKStore";
        config.leftPlaqueText = @"У\nД\nА\nЛ\nИ\nЛ\nИ\n?";
        config.rightPlaqueText = @"Я\n\nВ\nЕ\nР\nН\nУ\nЛ";
        config.continueButtonText = @"Продолжить";
        config.neverShowText = @"Больше не показывать";
        config.telegramUrl = @"https://t.me/your_telegram";
        config.githubUrl = @"https://github.com/gkuhtov";
    });
    return config;
}

@end
