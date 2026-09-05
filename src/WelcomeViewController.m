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
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
        (id)[UIColor colorWithRed:0.92 green:0.88 blue:0.81 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.86 green:0.81 blue:0.73 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.81 green:0.75 blue:0.66 alpha:1.0].CGColor
    ];
    paper.locations = @[@0.0, @0.5, @1.0];
    [self.backgroundLayer.layer addSublayer:paper];
    [self.containerView addSubview:self.backgroundLayer];
}

- (void)renderBonsaiTree {
    CGFloat w = self.view.bounds.size.width;
    self.treeLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 30, w, 260)];

    UIBezierPath *trunk = [UIBezierPath bezierPath];
    [trunk moveToPoint:CGPointMake(w + 20, 180)];
    [trunk addCurveToPoint:CGPointMake(w * 0.55, 95) controlPoint1:CGPointMake(w * 0.85, 145) controlPoint2:CGPointMake(w * 0.7, 105)];
    [trunk addCurveToPoint:CGPointMake(w * 0.15, 125) controlPoint1:CGPointMake(w * 0.4, 85) controlPoint2:CGPointMake(w * 0.25, 110)];
    [trunk addLineToPoint:CGPointMake(w * 0.12, 135)];
    [trunk addCurveToPoint:CGPointMake(w * 0.58, 110) controlPoint1:CGPointMake(w * 0.26, 125) controlPoint2:CGPointMake(w * 0.42, 105)];
    [trunk addCurveToPoint:CGPointMake(w + 30, 210) controlPoint1:CGPointMake(w * 0.72, 125) controlPoint2:CGPointMake(w * 0.88, 170)];
    [trunk closePath];

    CAShapeLayer *trunkLayer = [CAShapeLayer layer];
    trunkLayer.path = trunk.CGPath;
    trunkLayer.fillColor = [UIColor colorWithRed:0.33 green:0.20 blue:0.13 alpha:1.0].CGColor;
    trunkLayer.shadowColor = [UIColor blackColor].CGColor;
    trunkLayer.shadowOpacity = 0.35;
    trunkLayer.shadowRadius = 4;
    [self.treeLayer.layer addSublayer:trunkLayer];

    NSArray *clouds = @[
        [NSValue valueWithCGRect:CGRectMake(w * 0.07, 100, 105, 45)],
        [NSValue valueWithCGRect:CGRectMake(w * 0.34, 65, 120, 48)],
        [NSValue valueWithCGRect:CGRectMake(w * 0.60, 40, 125, 52)],
        [NSValue valueWithCGRect:CGRectMake(w * 0.74, 95, 90, 38)]
    ];

    for (NSValue *val in clouds) {
        CGRect r = [val CGRectValue];
        UIView *cloud = [[UIView alloc] initWithFrame:r];
        cloud.backgroundColor = [UIColor colorWithRed:0.13 green:0.25 blue:0.19 alpha:0.95];
        cloud.layer.cornerRadius = r.size.height / 2.0;
        cloud.layer.borderWidth = 2.0;
        cloud.layer.borderColor = [UIColor colorWithRed:0.08 green:0.17 blue:0.12 alpha:1.0].CGColor;
        cloud.layer.shadowColor = [UIColor blackColor].CGColor;
        cloud.layer.shadowOpacity = 0.35;
        cloud.layer.shadowRadius = 4;
        cloud.layer.shadowOffset = CGSizeMake(0, 3);
        [self.treeLayer addSubview:cloud];
    }

    NSArray *flowers = @[
        [NSValue valueWithCGPoint:CGPointMake(w * 0.35, 125)],
        [NSValue valueWithCGPoint:CGPointMake(w * 0.65, 100)]
    ];
    for (NSValue *pt in flowers) {
        CGPoint p = [pt CGPointValue];
        UILabel *fl = [[UILabel alloc] initWithFrame:CGRectMake(p.x, p.y, 26, 26)];
        fl.text = @"❀";
        fl.font = [UIFont boldSystemFontOfSize:22];
        fl.textColor = [UIColor colorWithRed:0.86 green:0.71 blue:0.36 alpha:1.0];
        [self.treeLayer addSubview:fl];
    }

    [self.containerView addSubview:self.treeLayer];
}

- (void)renderHokusaiWave {
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    CGFloat waveH = h * 0.38;

    self.waveLayer = [[UIView alloc] initWithFrame:CGRectMake(0, h - waveH, w, waveH)];

    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    [wavePath moveToPoint:CGPointMake(0, waveH)];
    [wavePath addLineToPoint:CGPointMake(0, waveH * 0.3)];
    [wavePath addCurveToPoint:CGPointMake(w * 0.6, waveH * 0.22)
                controlPoint1:CGPointMake(w * 0.15, 0)
                controlPoint2:CGPointMake(w * 0.45, waveH * 0.6)];
    [wavePath addCurveToPoint:CGPointMake(w, waveH * 0.08)
                controlPoint1:CGPointMake(w * 0.75, waveH * -0.1)
                controlPoint2:CGPointMake(w * 0.9, waveH * 0.35)];
    [wavePath addLineToPoint:CGPointMake(w, waveH)];
    [wavePath closePath];

    CAShapeLayer *wave = [CAShapeLayer layer];
    wave.path = wavePath.CGPath;
    wave.fillColor = [UIColor colorWithRed:0.12 green:0.23 blue:0.39 alpha:0.95].CGColor;
    wave.strokeColor = [UIColor colorWithWhite:1.0 alpha:0.9].CGColor;
    wave.lineWidth = 3.5;
    [self.waveLayer.layer addSublayer:wave];

    [self.containerView addSubview:self.waveLayer];
}

- (UIView *)createWoodenPlaque:(NSString *)text frame:(CGRect)frame {
    UIView *plaque = [[UIView alloc] initWithFrame:frame];

    CAGradientLayer *wood = [CAGradientLayer layer];
    wood.frame = plaque.bounds;
    wood.colors = @[
        (id)[UIColor colorWithRed:0.88 green:0.81 blue:0.71 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.79 green:0.71 blue:0.60 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.85 green:0.78 blue:0.67 alpha:1.0].CGColor
    ];
    wood.startPoint = CGPointMake(0, 0);
    wood.endPoint = CGPointMake(1, 0);
    wood.cornerRadius = 6;
    [plaque.layer addSublayer:wood];

    plaque.layer.cornerRadius = 6;
    plaque.layer.borderWidth = 1.5;
    plaque.layer.borderColor = [UIColor colorWithRed:0.55 green:0.45 blue:0.34 alpha:0.85].CGColor;
    plaque.layer.shadowColor = [UIColor blackColor].CGColor;
    plaque.layer.shadowOpacity = 0.35;
    plaque.layer.shadowRadius = 5;
    plaque.layer.shadowOffset = CGSizeMake(2, 4);

    UILabel *label = [[UILabel alloc] initWithFrame:plaque.bounds];
    label.text = text;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:0.24 green:0.17 blue:0.12 alpha:1.0];
    [plaque addSubview:label];

    return plaque;
}

- (void)renderPlaques {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    CGFloat y = self.view.bounds.size.height * 0.32;

    self.leftPlaqueView = [self createWoodenPlaque:cfg.leftPlaqueText frame:CGRectMake(14, y, 42, 250)];
    [self.containerView addSubview:self.leftPlaqueView];

    self.rightPlaqueView = [self createWoodenPlaque:cfg.rightPlaqueText frame:CGRectMake(self.view.bounds.size.width - 56, y, 42, 250)];
    [self.containerView addSubview:self.rightPlaqueView];
}

- (void)renderCenterCard {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    CGFloat w = self.view.bounds.size.width - 76;
    CGFloat h = 260;
    CGFloat y = self.view.bounds.size.height * 0.55;

    self.cardView = [[UIView alloc] initWithFrame:CGRectMake(38, y, w, h)];
    [self.containerView addSubview:self.cardView];

    UIView *badge = [[UIView alloc] initWithFrame:CGRectMake((w - 150) / 2.0, -46, 150, 40)];
    CAGradientLayer *metal = [CAGradientLayer layer];
    metal.frame = badge.bounds;
    metal.colors = @[
        (id)[UIColor colorWithRed:0.46 green:0.22 blue:0.56 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.27 green:0.11 blue:0.38 alpha:1.0].CGColor
    ];
    metal.cornerRadius = 12;
    [badge.layer addSublayer:metal];
    badge.layer.cornerRadius = 12;
    badge.layer.borderWidth = 1.8;
    badge.layer.borderColor = [UIColor colorWithRed:0.86 green:0.74 blue:0.52 alpha:1.0].CGColor;
    badge.layer.shadowColor = [UIColor blackColor].CGColor;
    badge.layer.shadowOpacity = 0.45;
    badge.layer.shadowRadius = 5;

    UILabel *badgeText = [[UILabel alloc] initWithFrame:badge.bounds];
    badgeText.text = @"GeraK STORE";
    badgeText.textAlignment = NSTextAlignmentCenter;
    badgeText.font = [UIFont boldSystemFontOfSize:15];
    badgeText.textColor = [UIColor colorWithRed:0.96 green:0.89 blue:0.75 alpha:1.0];
    [badge addSubview:badgeText];
    [self.cardView addSubview:badge];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, w, 30)];
    title.text = cfg.headlineText;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:22];
    title.textColor = [UIColor colorWithRed:0.18 green:0.14 blue:0.11 alpha:1.0];
    [self.cardView addSubview:title];

    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, w, 36)];
    sub.text = cfg.sublineText;
    sub.textAlignment = NSTextAlignmentCenter;
    sub.numberOfLines = 2;
    sub.font = [UIFont systemFontOfSize:13];
    sub.textColor = [UIColor colorWithRed:0.32 green:0.27 blue:0.22 alpha:0.85];
    [self.cardView addSubview:sub];

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

    UIButton *contBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    contBtn.frame = CGRectMake(0, 138, w, 46);
    contBtn.backgroundColor = [UIColor colorWithRed:0.16 green:0.12 blue:0.10 alpha:0.9];
    [contBtn setTitle:cfg.continueButtonText forState:UIControlStateNormal];
    [contBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    contBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    contBtn.layer.cornerRadius = 14;
    [contBtn addTarget:self action:@selector(dismissScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:contBtn];

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)neverShowAgain {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"com.gkuhtov.WelcomeToJapan.hasSeenWelcome"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissScreen];
}

@end
