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
        _sublineText = @"Подготовлено и распространяется\nчерез GeraKStore";
        _continueButtonText = @"Продолжить";
        _neverShowText = @"Больше не показывать";
        _telegramUrl = @"https://t.me/GeraKStore";
        _githubUrl = @"https://github.com/gkuhtov";

        _leftPlaqueText = @"У\nД\nА\nЛ\nИ\nЛ\nИ\n?";
        _rightPlaqueText = @"Я\n\nВ\nЕ\nР\nН\nУ\nЛ";

        // Увеличенные солидные дощечки
        _plaqueSize = CGSizeMake(62, 265);
        _leftPlaqueOrigin = CGPointMake(12, 0.44);   // плотнее к краю и чуть ниже
        _rightPlaqueOrigin = CGPointMake(12, 0.44);
        _plaqueParallaxDepth = 16.0;
    }
    return self;
}

@end
