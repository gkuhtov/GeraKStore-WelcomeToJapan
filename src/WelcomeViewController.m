#import "WelcomeViewController.h"
#import "WelcomeConfig.h"
#import "WelcomeAssets.h"
#import <CoreGraphics/CoreGraphics.h>

@interface WelcomeViewController ()
@property (nonatomic, strong) UIView *sceneContainer;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *plaquesLayer;
@property (nonatomic, strong) UIView *interactiveLayer;
@property (nonatomic, strong) UIImageView *metalLogoView;
@end

@implementation WelcomeViewController

- (UIImage *)imageFromBase64:(NSString *)base64Str {
    if (!base64Str || base64Str.length == 0) return nil;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

- (UIImage *)removeBlackBackground:(UIImage *)image {
    if (!image) return nil;
    CGImageRef rawRef = image.CGImage;
    const CGFloat maskColors[6] = {0, 25, 0, 25, 0, 25};
    CGImageRef maskedRef = CGImageCreateWithMaskingColors(rawRef, maskColors);
    if (!maskedRef) return image;
    UIImage *cleanImage = [UIImage imageWithCGImage:maskedRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(maskedRef);
    return cleanImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    self.sceneContainer = [[UIView alloc] initWithFrame:CGRectInset(self.view.bounds, -30, -30)];
    self.sceneContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.sceneContainer];

    [self setupBackground];
    [self setupPlaques];
    [self setupControlsAndLogo];
    [self applyMultiDepthParallax];
}

- (void)setupBackground {
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.sceneContainer.bounds];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    UIImage *bg = [self imageFromBase64:kWelcomeBackgroundBase64];
    if (!bg) bg = [UIImage imageNamed:@"welcome_bg.jpg"];
    self.backgroundImageView.image = bg;
    [self.sceneContainer addSubview:self.backgroundImageView];
}

- (void)setupPlaques {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    CGFloat screenW = self.view.bounds.size.width;
    CGFloat screenH = self.view.bounds.size.height;

    self.plaquesLayer = [[UIView alloc] initWithFrame:self.sceneContainer.bounds];
    [self.sceneContainer addSubview:self.plaquesLayer];

    UIImage *plaqueImg = [self imageFromBase64:kPlaquesBase64];
    if (!plaqueImg) plaqueImg = [UIImage imageNamed:@"plaques.png"];

    CGFloat leftX = cfg.leftPlaqueOrigin.x + 30;
    CGFloat leftY = (screenH * cfg.leftPlaqueOrigin.y) + 30;
    UIView *leftPlaque = [self buildPlaqueViewWithImage:plaqueImg
                                                  text:cfg.leftPlaqueText
                                                 frame:CGRectMake(leftX, leftY, cfg.plaqueSize.width, cfg.plaqueSize.height)
                                               isRight:NO];
    [self.plaquesLayer addSubview:leftPlaque];

    CGFloat rightX = screenW - cfg.rightPlaqueOrigin.x - cfg.plaqueSize.width + 30;
    CGFloat rightY = (screenH * cfg.rightPlaqueOrigin.y) + 30;
    UIView *rightPlaque = [self buildPlaqueViewWithImage:plaqueImg
                                                   text:cfg.rightPlaqueText
                                                  frame:CGRectMake(rightX, rightY, cfg.plaqueSize.width, cfg.plaqueSize.height)
                                                isRight:YES];
    [self.plaquesLayer addSubview:rightPlaque];
}

- (UIView *)buildPlaqueViewWithImage:(UIImage *)sheetImage text:(NSString *)text frame:(CGRect)frame isRight:(BOOL)isRight {
    UIView *container = [[UIView alloc] initWithFrame:frame];

    UIImageView *plaqueBg = [[UIImageView alloc] initWithFrame:container.bounds];
    plaqueBg.contentMode = UIViewContentModeScaleToFill;
    plaqueBg.image = sheetImage;
    plaqueBg.layer.shadowColor = [UIColor blackColor].CGColor;
    plaqueBg.layer.shadowOpacity = 0.45;
    plaqueBg.layer.shadowRadius = 8.0;
    plaqueBg.layer.shadowOffset = CGSizeMake(isRight ? -4 : 4, 6);
    [container addSubview:plaqueBg];

    UILabel *lbl = [[UILabel alloc] initWithFrame:container.bounds];
    lbl.text = text;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.numberOfLines = 0;
    lbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    lbl.textColor = [UIColor colorWithRed:0.20 green:0.12 blue:0.07 alpha:0.95];
    lbl.layer.shadowColor = [UIColor colorWithRed:0.95 green:0.90 blue:0.82 alpha:0.6].CGColor;
    lbl.layer.shadowOpacity = 1.0;
    lbl.layer.shadowRadius = 0.5;
    lbl.layer.shadowOffset = CGSizeMake(0, 1);
    [container addSubview:lbl];

    return container;
}

- (void)setupControlsAndLogo {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    CGFloat screenW = self.view.bounds.size.width;
    CGFloat screenH = self.view.bounds.size.height;

    CGFloat contentW = screenW - 140;
    CGFloat contentH = 320;
    CGFloat startY = screenH * 0.43;

    self.interactiveLayer = [[UIView alloc] initWithFrame:CGRectMake((screenW - contentW) / 2.0 + 30, startY + 30, contentW, contentH)];
    [self.sceneContainer addSubview:self.interactiveLayer];

    UIImage *rawLogo = [self imageFromBase64:kStoreLogoBase64];
    if (!rawLogo) rawLogo = [UIImage imageNamed:@"store_logo.png"];
    UIImage *cleanLogo = [self removeBlackBackground:rawLogo];

    self.metalLogoView = [[UIImageView alloc] initWithFrame:CGRectMake((contentW - 170) / 2.0, -55, 170, 85)];
    self.metalLogoView.contentMode = UIViewContentModeScaleAspectFit;
    self.metalLogoView.image = cleanLogo;
    self.metalLogoView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.metalLogoView.layer.shadowOpacity = 0.6;
    self.metalLogoView.layer.shadowRadius = 12.0;
    self.metalLogoView.layer.shadowOffset = CGSizeMake(0, 7);
    [self.interactiveLayer addSubview:self.metalLogoView];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, contentW, 28)];
    title.text = cfg.headlineText;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:21];
    title.textColor = [UIColor colorWithRed:0.18 green:0.12 blue:0.08 alpha:1.0];
    [self.interactiveLayer addSubview:title];

    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(0, 72, contentW, 30)];
    sub.text = cfg.sublineText;
    sub.textAlignment = NSTextAlignmentCenter;
    sub.numberOfLines = 2;
    sub.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    sub.textColor = [UIColor colorWithRed:0.32 green:0.25 blue:0.18 alpha:0.85];
    [self.interactiveLayer addSubview:sub];

    CGFloat btnW = (contentW - 10) / 2.0;
    UIButton *tgBtn = [self createThemeButton:@"Telegram" frame:CGRectMake(0, 112, btnW, 44)];
    [tgBtn addTarget:self action:@selector(openTelegram) forControlEvents:UIControlEventTouchUpInside];
    [self.interactiveLayer addSubview:tgBtn];

    UIButton *ghBtn = [self createThemeButton:@"GitHub" frame:CGRectMake(btnW + 10, 112, btnW, 44)];
    [ghBtn addTarget:self action:@selector(openGithub) forControlEvents:UIControlEventTouchUpInside];
    [self.interactiveLayer addSubview:ghBtn];

    UIButton *contBtn = [self createThemeButton:cfg.continueButtonText frame:CGRectMake(0, 166, contentW, 46)];
    [contBtn addTarget:self action:@selector(dismissScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.interactiveLayer addSubview:contBtn];

    UIButton *neverBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    neverBtn.frame = CGRectMake(0, 222, contentW, 28);
    [neverBtn setTitle:cfg.neverShowText forState:UIControlStateNormal];
    [neverBtn setTitleColor:[UIColor colorWithRed:0.25 green:0.18 blue:0.12 alpha:0.75] forState:UIControlStateNormal];
    neverBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [neverBtn addTarget:self action:@selector(neverShowAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.interactiveLayer addSubview:neverBtn];
}

- (UIButton *)createThemeButton:(NSString *)title frame:(CGRect)frame {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    btn.backgroundColor = [UIColor colorWithRed:0.16 green:0.11 blue:0.08 alpha:0.92];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    btn.layer.cornerRadius = 13.0;
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    btn.layer.shadowOpacity = 0.35;
    btn.layer.shadowRadius = 4.0;
    btn.layer.shadowOffset = CGSizeMake(0, 3);
    return btn;
}

- (void)addParallaxEffectToView:(UIView *)target depth:(CGFloat)depth {
    UIInterpolatingMotionEffect *x = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    x.minimumRelativeValue = @(-depth);
    x.maximumRelativeValue = @(depth);

    UIInterpolatingMotionEffect *y = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    y.minimumRelativeValue = @(-depth);
    y.maximumRelativeValue = @(depth);

    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[x, y];
    [target addMotionEffect:group];
}

- (void)applyMultiDepthParallax {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    [self addParallaxEffectToView:self.backgroundImageView depth:6.0];
    [self addParallaxEffectToView:self.plaquesLayer depth:cfg.plaqueParallaxDepth];
    [self addParallaxEffectToView:self.interactiveLayer depth:26.0];
    [self addParallaxEffectToView:self.metalLogoView depth:48.0];
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
