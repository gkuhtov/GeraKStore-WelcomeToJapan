#import "WelcomeViewController.h"
#import "WelcomeConfig.h"
#import "WelcomeAssets.h"
#import <CoreGraphics/CoreGraphics.h>

@interface WelcomeViewController ()
@property (nonatomic, strong) UIView *sceneContainer;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *plaquesLayer;
@property (nonatomic, strong) UIView *headerInfoLayer;
@property (nonatomic, strong) UIView *bottomActionsLayer;
@property (nonatomic, strong) UIImageView *metalLogoView;
@end

@implementation WelcomeViewController

- (UIImage *)imageFromBase64:(NSString *)base64Str {
    if (!base64Str || base64Str.length == 0) return nil;
    @try {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
        if (data) return [UIImage imageWithData:data];
    } @catch (NSException *e) {
        NSLog(@"[WelcomeToJapan] Base64 decode error: %@", e);
    }
    return nil;
}

- (UIImage *)removeBlackBackground:(UIImage *)image {
    if (!image) return nil;
    CGImageRef rawRef = image.CGImage;
    if (!rawRef) return image;
    
    const CGFloat maskColors[6] = {0, 30, 0, 30, 0, 30};
    CGImageRef maskedRef = CGImageCreateWithMaskingColors(rawRef, maskColors);
    if (!maskedRef) return image;
    
    UIImage *cleanImage = [UIImage imageWithCGImage:maskedRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(maskedRef);
    return cleanImage ?: image;
}

- (UIImage *)extractSinglePlaque:(UIImage *)sourceImage {
    if (!sourceImage) return nil;
    CGImageRef cgImg = sourceImage.CGImage;
    if (!cgImg) return sourceImage;
    
    size_t fullW = CGImageGetWidth(cgImg);
    size_t fullH = CGImageGetHeight(cgImg);
    if (fullW == 0 || fullH == 0) return sourceImage;
    
    CGRect cropRect = CGRectMake(0, 0, (CGFloat)fullW * 0.48, (CGFloat)fullH);
    CGImageRef croppedRef = CGImageCreateWithImageInRect(cgImg, cropRect);
    if (!croppedRef) return sourceImage;
    
    UIImage *plaque = [UIImage imageWithCGImage:croppedRef scale:sourceImage.scale orientation:sourceImage.imageOrientation];
    CGImageRelease(croppedRef);
    return plaque ?: sourceImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    self.sceneContainer = [[UIView alloc] initWithFrame:CGRectInset(self.view.bounds, -30, -30)];
    self.sceneContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.sceneContainer];

    [self setupBackground];
    [self setupPlaques];
    [self setupHeaderInfo];
    [self setupBottomActions];
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

    UIImage *rawPlaques = [self imageFromBase64:kPlaquesBase64];
    if (!rawPlaques) rawPlaques = [UIImage imageNamed:@"plaques.png"];
    UIImage *singlePlaque = [self extractSinglePlaque:rawPlaques];

    CGFloat leftX = cfg.leftPlaqueOrigin.x + 30;
    CGFloat leftY = (screenH * cfg.leftPlaqueOrigin.y) + 30;
    UIView *leftPlaque = [self buildPlaqueViewWithImage:singlePlaque
                                                  text:cfg.leftPlaqueText
                                                 frame:CGRectMake(leftX, leftY, cfg.plaqueSize.width, cfg.plaqueSize.height)
                                               isRight:NO];
    [self.plaquesLayer addSubview:leftPlaque];

    CGFloat rightX = screenW - cfg.rightPlaqueOrigin.x - cfg.plaqueSize.width + 30;
    CGFloat rightY = (screenH * cfg.rightPlaqueOrigin.y) + 30;
    UIView *rightPlaque = [self buildPlaqueViewWithImage:singlePlaque
                                                   text:cfg.rightPlaqueText
                                                  frame:CGRectMake(rightX, rightY, cfg.plaqueSize.width, cfg.plaqueSize.height)
                                                isRight:YES];
    [self.plaquesLayer addSubview:rightPlaque];
}

- (UIView *)buildPlaqueViewWithImage:(UIImage *)plaqueImage text:(NSString *)text frame:(CGRect)frame isRight:(BOOL)isRight {
    UIView *container = [[UIView alloc] initWithFrame:frame];

    UIImageView *plaqueBg = [[UIImageView alloc] initWithFrame:container.bounds];
    plaqueBg.contentMode = UIViewContentModeScaleToFill;
    plaqueBg.image = plaqueImage;
    plaqueBg.layer.shadowColor = [UIColor blackColor].CGColor;
    plaqueBg.layer.shadowOpacity = 0.55;
    plaqueBg.layer.shadowRadius = 10.0;
    plaqueBg.layer.shadowOffset = CGSizeMake(isRight ? -4 : 4, 7);
    [container addSubview:plaqueBg];

    CGFloat topPadding = 28.0;
    CGFloat bottomPadding = 26.0;
    CGFloat innerW = frame.size.width - 12.0;
    CGFloat innerH = frame.size.height - topPadding - bottomPadding;

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(6.0, topPadding, innerW, innerH)];
    lbl.text = text;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.numberOfLines = 0;
    lbl.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
    lbl.textColor = [UIColor colorWithRed:0.20 green:0.11 blue:0.06 alpha:0.98];
    
    lbl.layer.shadowColor = [UIColor colorWithRed:0.98 green:0.93 blue:0.86 alpha:0.85].CGColor;
    lbl.layer.shadowOpacity = 1.0;
    lbl.layer.shadowRadius = 0.6;
    lbl.layer.shadowOffset = CGSizeMake(0, 1.0);
    [container addSubview:lbl];

    return container;
}

- (void)setupHeaderInfo {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    CGFloat screenW = self.view.bounds.size.width;
    CGFloat screenH = self.view.bounds.size.height;

    CGFloat headerW = screenW - 130;
    CGFloat headerH = 240;
    CGFloat startY = screenH * 0.39;

    self.headerInfoLayer = [[UIView alloc] initWithFrame:CGRectMake((screenW - headerW) / 2.0 + 30, startY + 30, headerW, headerH)];
    [self.sceneContainer addSubview:self.headerInfoLayer];

    // Металлический шильдик
    UIImage *rawLogo = [self imageFromBase64:kStoreLogoBase64];
    if (!rawLogo) rawLogo = [UIImage imageNamed:@"store_logo.png"];
    UIImage *cleanLogo = [self removeBlackBackground:rawLogo];

    CGFloat logoW = 245.0;
    CGFloat logoH = 122.0;
    self.metalLogoView = [[UIImageView alloc] initWithFrame:CGRectMake((headerW - logoW) / 2.0, -8, logoW, logoH)];
    self.metalLogoView.contentMode = UIViewContentModeScaleAspectFit;
    self.metalLogoView.image = cleanLogo;
    self.metalLogoView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.metalLogoView.layer.shadowOpacity = 0.65;
    self.metalLogoView.layer.shadowRadius = 14.0;
    self.metalLogoView.layer.shadowOffset = CGSizeMake(0, 8);
    [self.headerInfoLayer addSubview:self.metalLogoView];

    // Заголовок "Добро пожаловать" (Serif)
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 122, headerW, 32)];
    title.text = cfg.headlineText;
    title.textAlignment = NSTextAlignmentCenter;
    UIFont *serifFont = [UIFont fontWithName:@"Georgia-Bold" size:24];
    if (!serifFont) serifFont = [UIFont boldSystemFontOfSize:23];
    title.font = serifFont;
    title.textColor = [UIColor colorWithRed:0.16 green:0.10 blue:0.06 alpha:1.0];
    [self.headerInfoLayer addSubview:title];

    // Подзаголовок: Строка 1 ("Подготовлено и распространяется через")
    UILabel *subLine1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 158, headerW, 20)];
    subLine1.text = cfg.sublineText;
    subLine1.textAlignment = NSTextAlignmentCenter;
    subLine1.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    subLine1.textColor = [UIColor colorWithRed:0.22 green:0.13 blue:0.08 alpha:0.90];
    [self.headerInfoLayer addSubview:subLine1];

    // Подзаголовок: Строка 2 ("GeraKStore" — смещена вправо для визуального баланса)
    UILabel *subLine2 = [[UILabel alloc] initWithFrame:CGRectMake(24, 178, headerW, 22)];
    subLine2.text = @"GeraKStore";
    subLine2.textAlignment = NSTextAlignmentCenter;
    subLine2.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    subLine2.textColor = [UIColor colorWithRed:0.15 green:0.09 blue:0.05 alpha:1.0];
    [self.headerInfoLayer addSubview:subLine2];
}

- (void)setupBottomActions {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    CGFloat screenW = self.view.bounds.size.width;
    CGFloat screenH = self.view.bounds.size.height;

    CGFloat actionsW = screenW - 80;
    CGFloat actionsH = 160;
    // Позиция кнопок сохранена ровно на твоих координатах
    CGFloat bottomY = screenH * 0.77;

    self.bottomActionsLayer = [[UIView alloc] initWithFrame:CGRectMake((screenW - actionsW) / 2.0 + 30, bottomY + 30, actionsW, actionsH)];
    [self.sceneContainer addSubview:self.bottomActionsLayer];

    CGFloat btnSpacing = 12.0;
    CGFloat btnW = (actionsW - btnSpacing) / 2.0;
    UIButton *tgBtn = [self createThemeButton:@"Telegram" frame:CGRectMake(0, 0, btnW, 46)];
    [tgBtn addTarget:self action:@selector(openTelegram) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomActionsLayer addSubview:tgBtn];

    UIButton *ghBtn = [self createThemeButton:@"GitHub" frame:CGRectMake(btnW + btnSpacing, 0, btnW, 46)];
    [ghBtn addTarget:self action:@selector(openGithub) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomActionsLayer addSubview:ghBtn];

    UIButton *contBtn = [self createThemeButton:cfg.continueButtonText frame:CGRectMake(0, 56, actionsW, 48)];
    [contBtn addTarget:self action:@selector(dismissScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomActionsLayer addSubview:contBtn];

    UIButton *neverBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    neverBtn.frame = CGRectMake(0, 114, actionsW, 26);
    [neverBtn setTitle:cfg.neverShowText forState:UIControlStateNormal];
    [neverBtn setTitleColor:[UIColor colorWithRed:0.95 green:0.92 blue:0.85 alpha:0.85] forState:UIControlStateNormal];
    neverBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    [neverBtn addTarget:self action:@selector(neverShowAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomActionsLayer addSubview:neverBtn];
}

- (UIButton *)createThemeButton:(NSString *)title frame:(CGRect)frame {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    btn.backgroundColor = [UIColor colorWithRed:0.16 green:0.11 blue:0.08 alpha:0.95];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    btn.layer.cornerRadius = 14.0;
    
    btn.layer.borderWidth = 0.8;
    btn.layer.borderColor = [UIColor colorWithRed:0.42 green:0.32 blue:0.22 alpha:0.55].CGColor;
    
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    btn.layer.shadowOpacity = 0.35;
    btn.layer.shadowRadius = 5.0;
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
    [self addParallaxEffectToView:self.headerInfoLayer depth:24.0];
    [self addParallaxEffectToView:self.metalLogoView depth:48.0];
    [self addParallaxEffectToView:self.bottomActionsLayer depth:20.0];
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
