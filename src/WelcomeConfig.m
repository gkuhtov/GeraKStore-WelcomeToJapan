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
        [self applyDefaults];
        [self loadFromJson];
    }
    return self;
}

- (void)applyDefaults {
    _headlineText = @"Добро пожаловать";
    _sublineText = @"Подготовлено и распространяется через";
    _storeSubtitleText = @"GeraKStore";
    _continueButtonText = @"Продолжить";
    _neverShowText = @"Больше не показывать";
    _telegramUrl = @"https://t.me/GeraKStore";
    _githubUrl = @"https://github.com/gkuhtov";

    _leftPlaqueText = @"У\nД\nА\nЛ\nИ\nЛ\nИ\n?";
    _rightPlaqueText = @"Я\n\nВ\nЕ\nР\nН\nУ\nЛ";

    _plaqueSize = CGSizeMake(88, 340);
    _leftPlaqueOrigin = CGPointMake(12, 0.38);
    _rightPlaqueOrigin = CGPointMake(12, 0.38);
    _plaqueParallaxDepth = 18.0;

    _pulseEnabled = YES;
    _pulseScale = 1.08;
    _hapticEnabled = YES;
}

- (void)reloadConfig {
    [self loadFromJson];
}

- (void)loadFromJson {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"config" ofType:@"json"];
    if (!path) {
        path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"json"];
    }
    if (!path) {
        path = @"/Library/Application Support/WelcomeToJapan/config.json";
    }

    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return;
    }

    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) return;

    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error || ![json isKindOfClass:[NSDictionary class]]) return;

    NSDictionary *texts = json[@"texts"];
    if ([texts isKindOfClass:[NSDictionary class]]) {
        if (texts[@"headline"]) _headlineText = [texts[@"headline"] copy];
        if (texts[@"subline"]) _sublineText = [texts[@"subline"] copy];
        if (texts[@"storeSubtitle"]) _storeSubtitleText = [texts[@"storeSubtitle"] copy];
        if (texts[@"continueButton"]) _continueButtonText = [texts[@"continueButton"] copy];
        if (texts[@"neverShow"]) _neverShowText = [texts[@"neverShow"] copy];
        if (texts[@"leftPlaque"]) _leftPlaqueText = [texts[@"leftPlaque"] copy];
        if (texts[@"rightPlaque"]) _rightPlaqueText = [texts[@"rightPlaque"] copy];
    }

    NSDictionary *links = json[@"links"];
    if ([links isKindOfClass:[NSDictionary class]]) {
        if (links[@"telegram"]) _telegramUrl = [links[@"telegram"] copy];
        if (links[@"github"]) _githubUrl = [links[@"github"] copy];
    }

    NSDictionary *plaques = json[@"plaques"];
    if ([plaques isKindOfClass:[NSDictionary class]]) {
        CGFloat w = plaques[@"width"] ? [plaques[@"width"] doubleValue] : _plaqueSize.width;
        CGFloat h = plaques[@"height"] ? [plaques[@"height"] doubleValue] : _plaqueSize.height;
        _plaqueSize = CGSizeMake(w, h);

        CGFloat lx = plaques[@"leftOriginX"] ? [plaques[@"leftOriginX"] doubleValue] : _leftPlaqueOrigin.x;
        CGFloat ly = plaques[@"leftOriginYRatio"] ? [plaques[@"leftOriginYRatio"] doubleValue] : _leftPlaqueOrigin.y;
        _leftPlaqueOrigin = CGPointMake(lx, ly);

        CGFloat rx = plaques[@"rightOriginX"] ? [plaques[@"rightOriginX"] doubleValue] : _rightPlaqueOrigin.x;
        CGFloat ry = plaques[@"rightOriginYRatio"] ? [plaques[@"rightOriginYRatio"] doubleValue] : _rightPlaqueOrigin.y;
        _rightPlaqueOrigin = CGPointMake(rx, ry);

        if (plaques[@"parallaxDepth"]) {
            _plaqueParallaxDepth = [plaques[@"parallaxDepth"] doubleValue];
        }
    }

    NSDictionary *pulse = json[@"pulse"];
    if ([pulse isKindOfClass:[NSDictionary class]]) {
        if (pulse[@"enabled"]) _pulseEnabled = [pulse[@"enabled"] boolValue];
        if (pulse[@"scale"]) _pulseScale = [pulse[@"scale"] doubleValue];
        if (pulse[@"hapticEnabled"]) _hapticEnabled = [pulse[@"hapticEnabled"] boolValue];
    }
}

@end
