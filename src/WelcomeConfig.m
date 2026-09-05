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

        _plaqueSize = CGSizeMake(44, 210);
        _leftPlaqueOrigin = CGPointMake(16, 0.40);
        _rightPlaqueOrigin = CGPointMake(16, 0.41);
        _plaqueParallaxDepth = 18.0;
    }
    return self;
}

@end
