#import "WelcomeViewController.h"
#import "WelcomeConfig.h"
#import "WelcomeAssets.h"
#import <CoreGraphics/CoreGraphics.h>

@interface WelcomeViewController ()
@property (nonatomic, strong) UIView *parallaxContainer;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *contentCard;
@property (nonatomic, strong) UIImageView *logoView;
@end

@implementation WelcomeViewController

- (UIImage *)imageFromBase64:(NSString *)base64Str {
    if (!base64Str || base64Str.length == 0) return nil;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

// Удаление светлого/белого фона у металлического логотипа
- (UIImage *)transparentLogoFromImage:(UIImage *)image {
    if (!image) return nil;
    CGImageRef rawImageRef = image.CGImage;
    // Диапазон маскировки для белых и почти белых пикселей (R, G, B: 225 - 255)
    const CGFloat colorMasking[6] = {225, 255, 225, 255, 225, 255};
    CGImageRef maskedImageRef = CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    if (!maskedImageRef) return image;
    UIImage *result = [UIImage imageWithCGImage:maskedImageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(maskedImageRef);
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.91 green:0.87 blue:0.80 alpha:1.0];

    // Контейнер с запасом под наклон гироскопа
    self.parallaxContainer = [[UIView alloc] initWithFrame:CGRectInset(self.view.bounds, -35, -35)];
    self.parallaxContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.parallaxContainer];

    [self setupBackgroundLayer];
    [self setupInteractiveLayer];
    [self applyParallaxMotion];
}

- (void)setupBackgroundLayer {
    self.backgroundView = [[UIImageView alloc] initWithFrame:self.parallaxContainer.bounds];
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundView.clipsToBounds = YES;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    UIImage *bg = [self imageFromBase64:kWelcomeBackgroundBase64];
    if (!bg) {
        bg = [UIImage imageNamed:@"welcome_bg.jpg"];
    }
    self.backgroundView.image = bg;
    [self.parallaxContainer addSubview:self.backgroundView];
}

- (void)setupInteractiveLayer {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    CGFloat screenW = self.view.bounds.size.width;
    CGFloat screenH = self.view.bounds.size.height;

    CGFloat cardW = screenW - 74;
    CGFloat cardH = 340;
    CGFloat cardY = screenH * 0.44;

    // Карточка-подложка: перекрывает старый нарисованный текст и служит платформой для кнопок
    self.contentCard = [[UIView alloc] initWithFrame:CGRectMake((screenW - cardW) / 2.0 + 35, cardY + 35, cardW, cardH)];
    self.contentCard.backgroundColor = [UIColor colorWithRed:0.93 green:0.89 blue:0.82 alpha:0.96];
    self.contentCard.layer.cornerRadius = 24.0;
    self.contentCard.layer.borderWidth = 1.2;
    self.contentCard.layer.borderColor = [UIColor colorWithRed:0.75 green:0.65 blue:0.50 alpha:0.65].CGColor;
    self.contentCard.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentCard.layer.shadowOpacity = 0.28;
    self.contentCard.layer.shadowRadius = 14.0;
    self.contentCard.layer.shadowOffset = CGSizeMake(0, 8);
    [self.parallaxContainer addSubview:self.contentCard];

    // Вырезанный металлический шильдик GeraK STORE
    UIImage *rawLogo = [self imageFromBase64:kStoreLogoBase64];
    if (!rawLogo) {
        rawLogo = [UIImage imageNamed:@"store_logo.jpg"];
    }
    UIImage *cleanLogo = [self transparentLogoFromImage:rawLogo];

    self.logoView = [[UIImageView alloc] initWithFrame:CGRectMake((cardW - 190) / 2.0, -52, 190, 95)];
    self.logoView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoView.image = cleanLogo;
    self.logoView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.logoView.layer.shadowOpacity = 0.6;
    self.logoView.layer.shadowRadius = 12.0;
    self.logoView.layer.shadowOffset = CGSizeMake(0, 8);
    [self.contentCard addSubview:self.logoView];

    // Заголовок
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 50, cardW - 24, 30)];
    title.text = cfg.headlineText;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:22];
    title.textColor = [UIColor colorWithRed:0.18 green:0.13 blue:0.09 alpha:1.0];
    [self.contentCard addSubview:title];

    // Подзаголовок
    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(16, 82, cardW - 32, 34)];
    sub.text = cfg.sublineText;
    sub.textAlignment = NSTextAlignmentCenter;
    sub.numberOfLines = 2;
    sub.font = [UIFont systemFontOfSize:13];
    sub.textColor = [UIColor colorWithRed:0.35 green:0.28 blue:0.22 alpha:0.9];
    [self.contentCard addSubview:sub];

    // Кнопки соцсетей
    CGFloat btnW = (cardW - 44) / 2.0;
    UIButton *tgBtn = [self createDarkButton:@"Telegram" frame:CGRectMake(16, 126, btnW, 46)];
    [tgBtn addTarget:self action:@selector(openTelegram) forControlEvents:UIControlEventTouchUpInside];
    [self.contentCard addSubview:tgBtn];

    UIButton *ghBtn = [self createDarkButton:@"GitHub" frame:CGRectMake(btnW + 28, 126, btnW, 46)];
    [ghBtn addTarget:self action:@selector(openGithub) forControlEvents:UIControlEventTouchUpInside];
    [self.contentCard addSubview:ghBtn];

    // Кнопка Продолжить
    UIButton *contBtn = [self createDarkButton:cfg.continueButtonText frame:CGRectMake(16, 184, cardW - 32, 48)];
    [contBtn addTarget:self action:@selector(dismissScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.contentCard addSubview:contBtn];

    // Кнопка Больше не показывать
    UIButton *neverBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    neverBtn.frame = CGRectMake(16, 240, cardW - 32, 32);
    [neverBtn setTitle:cfg.neverShowText forState:UIControlStateNormal];
    [neverBtn setTitleColor:[UIColor colorWithRed:0.32 green:0.25 blue:0.20 alpha:0.8] forState:UIControlStateNormal];
    neverBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [neverBtn addTarget:self action:@selector(neverShowAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.contentCard addSubview:neverBtn];
}

- (UIButton *)createDarkButton:(NSString *)title frame:(CGRect)frame {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    btn.backgroundColor = [UIColor colorWithRed:0.18 green:0.13 blue:0.10 alpha:0.94];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    btn.layer.cornerRadius = 14.0;
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    btn.layer.shadowOpacity = 0.3;
    btn.layer.shadowRadius = 4.0;
    btn.layer.shadowOffset = CGSizeMake(0, 3);
    return btn;
}

- (void)addParallaxToView:(UIView *)target depth:(CGFloat)depth {
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

- (void)applyParallaxMotion {
    // 1. Фон (дальний план)
    [self addParallaxToView:self.backgroundView depth:10.0];

    // 2. Подложка с кнопками (средний план)
    [self addParallaxToView:self.contentCard depth:30.0];

    // 3. Металлический шильдик (парит выше всех)
    [self addParallaxToView:self.logoView depth:50.0];
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
