#import "WelcomeConfig.h"

@implementation WelcomeConfig

+ (instancetype)sharedConfig {
    static WelcomeConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[WelcomeConfig alloc] init];
        
        // Тексты
        config.headlineText = @"Добро пожаловать";
        config.sublineText = @"Подготовлено и распространяется через GeraKStore";
        config.leftPlaqueText = @"У\nД\nА\nЛ\nИ\nЛ\nИ\n?";
        config.rightPlaqueText = @"Я\n\nВ\nЕ\nР\nН\nУ\nЛ";
        config.continueButtonText = @"Продолжить";
        config.neverShowText = @"Больше не показывать";
        
        // Ссылки
        config.telegramUrl = @"https://t.me/your_store";
        config.githubUrl = @"https://github.com/gkuhtov";
        
        // Глубина параллакса для каждого слоя
        config.bgTiltDepth = 8.0;
        config.treeTiltDepth = 18.0;
        config.waveTiltDepth = 32.0;
        config.cardTiltDepth = 22.0;
        config.plaqueTiltDepth = 45.0; // Таблички двигаются сильнее всего
    });
    return config;
}

@end
