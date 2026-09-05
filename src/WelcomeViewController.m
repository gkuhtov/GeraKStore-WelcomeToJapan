#import "WelcomeViewController.h"
#import "WelcomeConfig.h"
#import <CoreMotion/CoreMotion.h>

@interface WelcomeViewController ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *treeView;
@property (nonatomic, strong) UIImageView *waveView;
@property (nonatomic, strong) UIView *leftPlaqueView;
@property (nonatomic, strong) UIView *rightPlaqueView;
@property (nonatomic, strong) UIView *modalCardView;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.containerView];
    
    [self setupLayers];
    [self setupPlaques];
    [self setupModalCard];
    [self apply3DParallax];
}

- (void)setupLayers {
    self.backgroundView = [[UIImageView alloc] initWithFrame:self.containerView.bounds];
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0.89 green:0.84 blue:0.76 alpha:1.0];
    [self.containerView addSubview:self.backgroundView];

    self.treeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * 0.45)];
    self.treeView.contentMode = UIViewContentModeScaleAspectFit;
    [self.containerView addSubview:self.treeView];

    CGFloat waveHeight = self.view.bounds.size.height * 0.4;
    self.waveView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - waveHeight, self.view.bounds.size.width, waveHeight)];
    self.waveView.contentMode = UIViewContentModeScaleAspectFill;
    [self.containerView addSubview:self.waveView];
}

- (UIView *)buildPlaqueWithText:(NSString *)text frame:(CGRect)frame {
    UIView *card = [[UIView alloc] initWithFrame:frame];
    card.backgroundColor = [UIColor colorWithRed:0.84 green:0.77 blue:0.67 alpha:0.9];
    card.layer.cornerRadius = 6.0;
    card.layer.borderWidth = 1.0;
    card.layer.borderColor = [UIColor colorWithRed:0.45 green:0.35 blue:0.25 alpha:0.5].CGColor;
    card.layer.shadowColor = [UIColor blackColor].CGColor;
    card.layer.shadowOffset = CGSizeMake(2, 4);
    card.layer.shadowOpacity = 0.3;
    card.layer.shadowRadius = 4.0;

    UILabel *lbl = [[UILabel alloc] initWithFrame:card.bounds];
    lbl.text = text;
    lbl.numberOfLines = 0;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont boldSystemFontOfSize:16];
    lbl.textColor = [UIColor colorWithRed:0.22 green:0.18 blue:0.14 alpha:1.0];
    [card addSubview:lbl];
    return card;
}

- (void)setupPlaques {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    CGFloat y = self.view.bounds.size.height * 0.35;
    
    self.leftPlaqueView = [self buildPlaqueWithText:cfg.leftPlaqueText frame:CGRectMake(16, y, 42, 260)];
    [self.containerView addSubview:self.leftPlaqueView];

    self.rightPlaqueView = [self buildPlaqueWithText:cfg.rightPlaqueText frame:CGRectMake(self.view.bounds.size.width - 58, y, 42, 260)];
    [self.containerView addSubview:self.rightPlaqueView];
}

- (void)setupModalCard {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    CGFloat w = self.view.bounds.size.width - 80;
    CGFloat y = self.view.bounds.size.height * 0.55;

    self.modalCardView = [[UIView alloc] initWithFrame:CGRectMake(40, y, w, 280)];
    [self.containerView addSubview:self.modalCardView];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, 32)];
    title.text = cfg.headlineText;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:22];
    title.textColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    [self.modalCardView addSubview:title];

    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, w, 36)];
    sub.text = cfg.sublineText;
    sub.textAlignment = NSTextAlignmentCenter;
    sub.numberOfLines = 2;
    sub.font = [UIFont systemFontOfSize:13];
    sub.textColor = [UIColor colorWithWhite:0.25 alpha:0.8];
    [self.modalCardView addSubview:sub];

    UIButton *tgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    tgBtn.frame = CGRectMake(0, 85, (w - 12)/2, 44);
    tgBtn.backgroundColor = [UIColor colorWithRed:0.16 green:0.13 blue:0.11 alpha:0.88];
    [tgBtn setTitle:@"Telegram" forState:UIControlStateNormal];
    [tgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tgBtn.layer.cornerRadius = 14;
    [tgBtn addTarget:self action:@selector(openTelegram) forControlEvents:UIControlEventTouchUpInside];
    [self.modalCardView addSubview:tgBtn];

    UIButton *ghBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    ghBtn.frame = CGRectMake((w - 12)/2 + 12, 85, (w - 12)/2, 44);
    ghBtn.backgroundColor = [UIColor colorWithRed:0.16 green:0.13 blue:0.11 alpha:0.88];
    [ghBtn setTitle:@"GitHub" forState:UIControlStateNormal];
    [ghBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ghBtn.layer.cornerRadius = 14;
    [ghBtn addTarget:self action:@selector(openGithub) forControlEvents:UIControlEventTouchUpInside];
    [self.modalCardView addSubview:ghBtn];

    UIButton *contBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    contBtn.frame = CGRectMake(0, 140, w, 46);
    contBtn.backgroundColor = [UIColor colorWithRed:0.16 green:0.13 blue:0.11 alpha:0.88];
    [contBtn setTitle:cfg.continueButtonText forState:UIControlStateNormal];
    [contBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    contBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    contBtn.layer.cornerRadius = 14;
    [contBtn addTarget:self action:@selector(dismissScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.modalCardView addSubview:contBtn];

    UIButton *neverBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    neverBtn.frame = CGRectMake(0, 198, w, 30);
    [neverBtn setTitle:cfg.neverShowText forState:UIControlStateNormal];
    [neverBtn setTitleColor:[UIColor colorWithWhite:0.2 alpha:0.8] forState:UIControlStateNormal];
    neverBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [neverBtn addTarget:self action:@selector(neverShowAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.modalCardView addSubview:neverBtn];
}

- (void)addMotionToView:(UIView *)targetView depth:(CGFloat)depth {
    UIInterpolatingMotionEffect *xEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xEffect.minimumRelativeValue = @(-depth);
    xEffect.maximumRelativeValue = @(depth);

    UIInterpolatingMotionEffect *yEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yEffect.minimumRelativeValue = @(-depth);
    yEffect.maximumRelativeValue = @(depth);

    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[xEffect, yEffect];
    [targetView addMotionEffect:group];
}

- (void)apply3DParallax {
    [self addMotionToView:self.backgroundView depth:6.0];
    [self addMotionToView:self.treeView depth:14.0];
    [self addMotionToView:self.waveView depth:26.0];
    [self addMotionToView:self.leftPlaqueView depth:38.0];
    [self addMotionToView:self.rightPlaqueView depth:38.0];
    [self addMotionToView:self.modalCardView depth:20.0];
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
