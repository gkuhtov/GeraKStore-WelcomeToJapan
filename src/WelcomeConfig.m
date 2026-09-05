#import "WelcomeConfig.h"

@implementation WelcomeConfig

+ (instancetype)sharedConfig {
    static WelcomeConfig *cfg = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cfg = [[self alloc] init];
    });
    return cfg;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _headlineText = @"Добро пожаловать";
        _sublineText = @"Подготовлено и распространяется через";
        _storeSubtitleText = @"GeraKStore";
        _continueButtonText = @"Продолжить";
        _neverShowText = @"Больше не показывать";
        _telegramUrl = @"https://t.me/GeraKStore";
        _githubUrl = @"https://github.com/gkuhtov";

        _leftPlaqueText = @"У\nД\nА\nЛ\nИ\nЛ\nИ\n?";
        _rightPlaqueText = @"Я\n\nВ\nЕ\nР\nН\nУ\nЛ";

        // Крупные, массивные дощечки для любого экрана
        _plaqueSize = CGSizeMake(88, 340);
        _leftPlaqueOrigin = CGPointMake(12, 0.38);
        _rightPlaqueOrigin = CGPointMake(12, 0.38);
        _plaqueParallaxDepth = 16.0;

        _pulseEnabled = YES;
        _pulseScale = 1.06;
        _hapticEnabled = YES;
    }
    return self;
}

@end
