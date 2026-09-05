#import "WelcomeViewController.h"
#import "WelcomeConfig.h"

@interface WelcomeViewController ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *backgroundLayer;
@property (nonatomic, strong) UIView *treeLayer;
@property (nonatomic, strong) UIView *waveLayer;
@property (nonatomic, strong) UIView *leftPlaqueView;
@property (nonatomic, strong) UIView *rightPlaqueView;
@property (nonatomic, strong) UIView *cardView;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.containerView];

    [self renderBackground];
    [self renderBonsaiTree];
    [self renderHokusaiWave];
    [self renderPlaques];
    [self renderCenterCard];
    [self applyMultiLayerParallax];
}

- (void)renderBackground {
    self.backgroundLayer = [[UIView alloc] initWithFrame:self.containerView.bounds];
    CAGradientLayer *paper = [CAGradientLayer layer];
    paper.frame = self.backgroundLayer.bounds;
    paper.colors = @[
        (id)[UIColor colorWithRed:0.91 green:0.87 blue:0.80 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.85 green:0.80 blue:0.72 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.80 green:0.74 blue:0.65 alpha:1.0].CGColor
    ];
    paper.locations = @[@0.0, @0.5, @1.0];
    [self.backgroundLayer.layer addSublayer:paper];
    [self.containerView addSubview:self.backgroundLayer];
}

- (void)renderBonsaiTree {
    CGFloat w = self.view.bounds.size.width;
    self.treeLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 20, w, 280)];
    
    // Ствол бонсая
    UIBezierPath *trunk = [UIBezierPath bezierPath];
    [trunk moveToPoint:CGPointMake(w + 30, 200)];
    [trunk addCurveToPoint:CGPointMake(w * 0.55, 110) controlPoint1:CGPointMake(w * 0.85, 160) controlPoint2:CGPointMake(w * 0.7, 120)];
    [trunk addCurveToPoint:CGPointMake(w * 0.15, 140) controlPoint1:CGPointMake(w * 0.4, 100) controlPoint2:CGPointMake(w * 0.25, 125)];
    [trunk addLineToPoint:CGPointMake(w * 0.12, 148)];
    [trunk addCurveToPoint:CGPointMake(w * 0.58, 125) controlPoint1:CGPointMake(w * 0.26, 138) controlPoint2:CGPointMake(w * 0.42, 118)];
    [trunk addCurveToPoint:CGPointMake(w + 40, 240) controlPoint1:CGPointMake(w * 0.72, 138) controlPoint2:CGPointMake(w * 0.88, 185)];
    [trunk closePath];

    CAShapeLayer *trunkLayer = [CAShapeLayer layer];
    trunkLayer.path = trunk.CGPath;
    trunkLayer.fillColor = [UIColor colorWithRed:0.32 green:0.18 blue:0.12 alpha:1.0].CGColor;
    trunkLayer.shadowColor = [UIColor blackColor].CGColor;
    trunkLayer.shadowOpacity = 0.35;
    trunkLayer.shadowRadius = 4;
    [self.treeLayer.layer addSublayer:trunkLayer];

    // Кроны бонсая (хвойные шапки)
    NSArray *clusters = @[
        [NSValue valueWithCGRect:CGRectMake(w * 0.08, 115, 110, 48)],
        [NSValue valueWithCGRect:CGRectMake(w * 0.35, 75, 125, 52)],
        [NSValue valueWithCGRect:CGRectMake(w * 0.62, 50, 130, 56)],
        [NSValue valueWithCGRect:CGRectMake(w * 0.75, 110, 95, 42)]
    ];

    for (NSValue *val in clusters) {
        CGRect r = [val CGRectValue];
        UIView *cloud = [[UIView alloc] initWithFrame:r];
        cloud.backgroundColor = [UIColor colorWithRed:0.12 green:0.24 blue:0.18 alpha:0.95];
        cloud.layer.cornerRadius = r.size.height / 2.0;
        cloud.layer.borderWidth = 2.5;
        cloud.layer.borderColor = [UIColor colorWithRed:0.07 green:0.16 blue:0.11 alpha:1.0].CGColor;
        cloud.layer.shadowColor = [UIColor blackColor].CGColor;
        cloud.layer.shadowOpacity = 0.4;
        cloud.layer.shadowRadius = 5;
        cloud.layer.shadowOffset = CGSizeMake(0, 4);
        [self.treeLayer addSubview:cloud];
    }

    // Золотые цветы сакуры
    NSArray *flowers = @[
        [NSValue valueWithCGPoint:CGPointMake(w * 0.36, 140)],
        [NSValue valueWithCGPoint:CGPointMake(w * 0.66, 115)]
    ];
    for (NSValue *pt in flowers) {
        CGPoint p = [pt CGPointValue];
        UILabel *fl = [[UILabel alloc] initWithFrame:CGRectMake(p.x, p.y, 28, 28)];
        fl.text = @"❀";
        fl.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
        fl.textColor = [UIColor colorWithRed:0.86 green:0.70 blue:0.35 alpha:1.0];
        fl.layer.shadowColor = [UIColor colorWithRed:0.95 green:0.82 blue:0.4 alpha:0.8].CGColor;
        fl.layer.shadowOpacity = 0.8;
        fl.layer.shadowRadius = 6;
        [self.treeLayer addSubview:fl];
    }

    [self.containerView addSubview:self.treeLayer];
}

- (void)renderHokusaiWave {
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    CGFloat waveH = h * 0.42;
    
    self.waveLayer = [[UIView alloc] initWithFrame:CGRectMake(0, h - waveH, w, waveH)];

    // Главный гребень волны
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    [wavePath moveToPoint:CGPointMake(0, waveH)];
    [wavePath addLineToPoint:CGPointMake(0, waveH * 0.35)];
    [wavePath addCurveToPoint:CGPointMake(w * 0.6, waveH * 0.25)
                controlPoint1:CGPointMake(w * 0.15, 0)
                controlPoint2:CGPointMake(w * 0.45, waveH * 0.65)];
    [wavePath addCurveToPoint:CGPointMake(w, waveH * 0.1)
                controlPoint1:CGPointMake(w * 0.75, waveH * -0.15)
                controlPoint2:CGPointMake(w * 0.9, waveH * 0.4)];
    [wavePath addLineToPoint:CGPointMake(w, waveH)];
    [wavePath closePath];

    CAShapeLayer *wave = [CAShapeLayer layer];
    wave.path = wavePath.CGPath;
    wave.fillColor = [UIColor colorWithRed:0.11 green:0.22 blue:0.38 alpha:0.95].CGColor;
    wave.strokeColor = [UIColor colorWithRed:0.92 green:0.94 blue:0.96 alpha:1.0].CGColor;
    wave.lineWidth = 4.0;
    wave.shadowColor = [UIColor blackColor].CGColor;
    wave.shadowOpacity = 0.5;
    wave.shadowRadius = 8;
    [self.waveLayer.layer addSublayer:wave];

    // Пена и брызги
    UIBezierPath *foamPath = [UIBezierPath bezierPath];
    [foamPath moveToPoint:CGPointMake(0, waveH * 0.38)];
    [foamPath addCurveToPoint:CGPointMake(w * 0.55, waveH * 0.28)
                controlPoint1:CGPointMake(w * 0.18, waveH * 0.05)
                controlPoint2:CGPointMake(w * 0.42, waveH * 0.7)];
    CAShapeLayer *foam = [CAShapeLayer layer];
    foam.path = foamPath.CGPath;
    foam.strokeColor = [UIColor colorWithWhite:1.0 alpha:0.85].CGColor;
    foam.fillColor = [UIColor clearColor].CGColor;
    foam.lineWidth = 3.0;
    foam.lineDashPattern = @[@8, @6];
    [self.waveLayer.layer addSublayer:foam];

    [self.containerView addSubview:self.waveLayer];
}

- (UIView *)createWoodenPlaque:(NSString *)text frame:(CGRect)frame {
    UIView *plaque = [[UIView alloc] initWithFrame:frame];
    
    // Текстура деревянной плашки (градиент под светлое дерево)
    CAGradientLayer *wood = [CAGradientLayer layer];
    wood.frame = plaque.bounds;
    wood.colors = @[
        (id)[UIColor colorWithRed:0.88 green:0.82 blue:0.72 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.80 green:0.72 blue:0.61 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.86 green:0.79 blue:0.68 alpha:1.0].CGColor
    ];
    wood.startPoint = CGPointMake(0, 0);
    wood.endPoint = CGPointMake(1, 0);
    wood.cornerRadius = 6;
    [plaque.layer addSublayer:wood];

    // Фаска и объемная 3D-тень
    plaque.layer.cornerRadius = 6;
    plaque.layer.borderWidth = 1.5;
    plaque.layer.borderColor = [UIColor colorWithRed:0.56 green:0.46 blue:0.35 alpha:0.85].CGColor;
    plaque.layer.shadowColor = [UIColor blackColor].CGColor;
    plaque.layer.shadowOpacity = 0.38;
    plaque.layer.shadowRadius = 6;
    plaque.layer.shadowOffset = CGSizeMake(3, 5);

    // Вертикальный текст с эффектом гравировки
    UILabel *label = [[UILabel alloc] initWithFrame:plaque.bounds];
    label.text = text;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Hiragino Mincho ProN" size:16] ?: [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor colorWithRed:0.25 green:0.18 blue:0.13 alpha:1.0];
    label.layer.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.6].CGColor;
    label.layer.shadowOffset = CGSizeMake(0.5, 1.0);
    label.layer.shadowRadius = 0;
    label.layer.shadowOpacity = 1.0;
    [plaque addSubview:label];

    return plaque;
}

- (void)renderPlaques {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    CGFloat y = self.view.bounds.size.height * 0.34;

    self.leftPlaqueView = [self createWoodenPlaque:cfg.leftPlaqueText frame:CGRectMake(16, y, 44, 250)];
    [self.containerView addSubview:self.leftPlaqueView];

    self.rightPlaqueView = [self createWoodenPlaque:cfg.rightPlaqueText frame:CGRectMake(self.view.bounds.size.width - 60, y, 44, 250)];
    [self.containerView addSubview:self.rightPlaqueView];
}

- (void)renderCenterCard {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    CGFloat w = self.view.bounds.size.width - 80;
    CGFloat h = 260;
    CGFloat y = self.view.bounds.size.height * 0.56;

    self.cardView = [[UIView alloc] initWithFrame:CGRectMake(40, y, w, h)];
    [self.containerView addSubview:self.cardView];

    // Металлический шильдик GeraK STORE
    UIView *badge = [[UIView alloc] initWithFrame:CGRectMake((w - 150) / 2.0, -48, 150, 42)];
    CAGradientLayer *metal = [CAGradientLayer layer];
    metal.frame = badge.bounds;
    metal.colors = @[
        (id)[UIColor colorWithRed:0.46 green:0.23 blue:0.56 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.28 green:0.12 blue:0.38 alpha:1.0].CGColor
    ];
    metal.cornerRadius = 12;
    [badge.layer addSublayer:metal];
    badge.layer.cornerRadius = 12;
    badge.layer.borderWidth = 2.0;
    badge.layer.borderColor = [UIColor colorWithRed:0.86 green:0.74 blue:0.52 alpha:1.0].CGColor;
    badge.layer.shadowColor = [UIColor blackColor].CGColor;
    badge.layer.shadowOpacity = 0.5;
    badge.layer.shadowRadius = 6;
    badge.layer.shadowOffset = CGSizeMake(0, 3);

    UILabel *badgeText = [[UILabel alloc] initWithFrame:badge.bounds];
    badgeText.text = @"GeraK STORE";
    badgeText.textAlignment = NSTextAlignmentCenter;
    badgeText.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:15] ?: [UIFont boldSystemFontOfSize:15];
    badgeText.textColor = [UIColor colorWithRed:0.96 green:0.89 blue:0.75 alpha:1.0];
    [badge addSubview:badgeText];
    [self.cardView addSubview:badge];

    // Заголовок
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, w, 30)];
    title.text = cfg.headlineText;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:22];
    title.textColor = [UIColor colorWithRed:0.18 green:0.14 blue:0.11 alpha:1.0];
    [self.cardView addSubview:title];

    // Подзаголовок
    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, w, 36)];
    sub.text = cfg.sublineText;
    sub.textAlignment = NSTextAlignmentCenter;
    sub.numberOfLines = 2;
    sub.font = [UIFont systemFontOfSize:13];
    sub.textColor = [UIColor colorWithRed:0.32 green:0.27 blue:0.22 alpha:0.85];
    [self.cardView addSubview:sub];

    // Кнопки соцсетей
    UIButton *tgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    tgBtn.frame = CGRectMake(0, 84, (w - 12) / 2.0, 44);
    tgBtn.backgroundColor = [UIColor colorWithRed:0.16 green:0.12 blue:0.10 alpha:0.9];
    [tgBtn setTitle:@"Telegram" forState:UIControlStateNormal];
    [tgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tgBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    tgBtn.layer.cornerRadius = 14;
    [tgBtn addTarget:self action:@selector(openTelegram) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:tgBtn];

    UIButton *ghBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    ghBtn.frame = CGRectMake((w - 12) / 2.0 + 12, 84, (w - 12) / 2.0, 44);
    ghBtn.backgroundColor = [UIColor colorWithRed:0.16 green:0.12 blue:0.10 alpha:0.9];
    [ghBtn setTitle:@"GitHub" forState:UIControlStateNormal];
    [ghBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ghBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    ghBtn.layer.cornerRadius = 14;
    [ghBtn addTarget:self action:@selector(openGithub) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:ghBtn];

    // Кнопка Продолжить
    UIButton *contBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    contBtn.frame = CGRectMake(0, 138, w, 46);
    contBtn.backgroundColor = [UIColor colorWithRed:0.16 green:0.12 blue:0.10 alpha:0.9];
    [contBtn setTitle:cfg.continueButtonText forState:UIControlStateNormal];
    [contBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    contBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    contBtn.layer.cornerRadius = 14;
    [contBtn addTarget:self action:@selector(dismissScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:contBtn];

    // Кнопка Больше не показывать
    UIButton *neverBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    neverBtn.frame = CGRectMake(0, 194, w, 32);
    [neverBtn setTitle:cfg.neverShowText forState:UIControlStateNormal];
    [neverBtn setTitleColor:[UIColor colorWithRed:0.25 green:0.20 blue:0.16 alpha:0.75] forState:UIControlStateNormal];
    neverBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [neverBtn addTarget:self action:@selector(neverShowAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:neverBtn];
}

- (void)addTiltToView:(UIView *)target depth:(CGFloat)depth {
    UIInterpolatingMotionEffect *tiltX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    tiltX.minimumRelativeValue = @(-depth);
    tiltX.maximumRelativeValue = @(depth);

    UIInterpolatingMotionEffect *tiltY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    tiltY.minimumRelativeValue = @(-depth);
    tiltY.maximumRelativeValue = @(depth);

    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[tiltX, tiltY];
    [target addMotionEffect:group];
}

- (void)applyMultiLayerParallax {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    [self addTiltToView:self.backgroundLayer depth:cfg.bgTiltDepth];
    [self addTiltToView:self.treeLayer depth:cfg.treeTiltDepth];
    [self addTiltToView:self.waveLayer depth:cfg.waveTiltDepth];
    [self addTiltToView:self.cardView depth:cfg.cardTiltDepth];
    [self addTiltToView:self.leftPlaqueView depth:cfg.plaqueTiltDepth];
    [self addTiltToView:self.rightPlaqueView depth:cfg.plaqueTiltDepth];
}

- (void)openTelegram {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WelcomeConfig sharedConfig].telegramUrl] options:@{} completionHandler:nil];
}

- (void)openGithub {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WelcomeConfig sharedConfig].githubUrl] options:@{} completionHandler:nil];
}

- (void)dismissScreen {
    [UIView animateWithDuration:0.35 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)neverShowAgain {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GeraKWelcomeDismissed"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissScreen];
}

@end
