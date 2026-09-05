#import "WelcomeViewController.h"
#import "WelcomeConfig.h"
#import "WelcomeAssets.h"

@interface WelcomeViewController ()
@property (nonatomic, strong) UIView *parallaxContainer;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIView *interactiveCard;
@end

@implementation WelcomeViewController

- (UIImage *)imageFromBase64:(NSString *)base64Str {
    if (!base64Str || base64Str.length == 0) return nil;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    // Контейнер с запасом под наклон гироскопа
    self.parallaxContainer = [[UIView alloc] initWithFrame:CGRectInset(self.view.bounds, -30, -30)];
    self.parallaxContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.parallaxContainer];

    [self setupBackground];
    [self setupCardAndLogo];
    [self apply3DParallax];
}

- (void)setupBackground {
    self.backgroundView = [[UIImageView alloc] initWithFrame:self.parallaxContainer.bounds];
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundView.clipsToBounds = YES;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    UIImage *bgImg = [self imageFromBase64:kWelcomeBackgroundBase64];
    if (!bgImg) {
        bgImg = [UIImage imageNamed:@"welcome_bg.jpg"];
    }
    self.backgroundView.image = bgImg;
    [self.parallaxContainer addSubview:self.backgroundView];
}

- (void)setupCardAndLogo {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    CGFloat screenW = self.view.bounds.size.width;
    CGFloat screenH = self.view.bounds.size.height;

    CGFloat cardW = screenW - 84;
    CGFloat cardH = 340;
    CGFloat cardY = screenH * 0.44;

    self.interactiveCard = [[UIView alloc] initWithFrame:CGRectMake((screenW - cardW) / 2.0 + 30, cardY + 30, cardW, cardH)];
    [self.parallaxContainer addSubview:self.interactiveCard];

    // 1. Металлический шильдик GeraK STORE
    self.logoView = [[UIImageView alloc] initWithFrame:CGRectMake((cardW - 190) / 2.0, 0, 190, 85)];
    self.logoView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *logoImg = [self imageFromBase64:kStoreLogoBase64];
    if (!logoImg) {
        logoImg = [UIImage imageNamed:@"store_logo.png"];
    }
    self.logoView.image = logoImg;
    self.logoView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.logoView.layer.shadowOpacity = 0.55;
    self.logoView.layer.shadowRadius = 10.0;
    self.logoView.layer.shadowOffset = CGSizeMake(0, 6);
    [self.interactiveCard addSubview:self.logoView];

    // 2. Заголовок "Добро пожаловать"
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, cardW, 30)];
    title.text = cfg.headlineText;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:22];
    title.textColor = [UIColor colorWithRed:0.18 green:0.13 blue:0.09 alpha:1.0];
    [self.interactiveCard addSubview:title];

    // 3. Подзаголовок
    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(0, 127, cardW, 34)];
    sub.text = cfg.sublineText;
    sub.textAlignment = NSTextAlignmentCenter;
    sub.numberOfLines = 2;
    sub.font = [UIFont systemFontOfSize:13];
    sub.textColor = [UIColor colorWithRed:0.28 green:0.22 blue:0.17 alpha:0.85];
    [self.interactiveCard addSubview:sub];

    // 4. Кнопки Telegram / GitHub
    CGFloat btnW = (cardW - 12) / 2.0;
    UIButton *tgBtn = [self createDarkButton:@"Telegram" frame:CGRectMake(0, 172, btnW, 46)];
    [tgBtn addTarget:self action:@selector(openTelegram) forControlEvents:UIControlEventTouchUpInside];
    [self.interactiveCard addSubview:tgBtn];

    UIButton *ghBtn = [self createDarkButton:@"GitHub" frame:CGRectMake(btnW + 12, 172, btnW, 46)];
    [ghBtn addTarget:self action:@selector(openGithub) forControlEvents:UIControlEventTouchUpInside];
    [self.interactiveCard addSubview:ghBtn];

    // 5. Кнопка "Продолжить"
    UIButton *contBtn = [self createDarkButton:cfg.continueButtonText frame:CGRectMake(0, 228, cardW, 48)];
    [contBtn addTarget:self action:@selector(dismissScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.interactiveCard addSubview:contBtn];

    // 6. "Больше не показывать"
    UIButton *neverBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    neverBtn.frame = CGRectMake(0, 286, cardW, 32);
    [neverBtn setTitle:cfg.neverShowText forState:UIControlStateNormal];
    [neverBtn setTitleColor:[UIColor colorWithRed:0.22 green:0.16 blue:0.12 alpha:0.75] forState:UIControlStateNormal];
    neverBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [neverBtn addTarget:self action:@selector(neverShowAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.interactiveCard addSubview:neverBtn];
}

- (UIButton *)createDarkButton:(NSString *)title frame:(CGRect)frame {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    btn.backgroundColor = [UIColor colorWithRed:0.16 green:0.12 blue:0.09 alpha:0.92];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    btn.layer.cornerRadius = 14;
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    btn.layer.shadowOpacity = 0.3;
    btn.layer.shadowRadius = 4;
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

- (void)apply3DParallax {
    // Фон слегка смещается вглубь
    [self addParallaxToView:self.backgroundView depth:12.0];

    // Интерактивная карточка и кнопки парят на среднем плане
    [self addParallaxToView:self.interactiveCard depth:35.0];

    // Металлический шильдик выдвинут ближе всего к экрану
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
