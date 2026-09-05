#import <UIKit/UIKit.h>

@interface WelcomeConfig : NSObject

@property (nonatomic, copy) NSString *headlineText;
@property (nonatomic, copy) NSString *sublineText;
@property (nonatomic, copy) NSString *leftPlaqueText;
@property (nonatomic, copy) NSString *rightPlaqueText;
@property (nonatomic, copy) NSString *continueButtonText;
@property (nonatomic, copy) NSString *neverShowText;
@property (nonatomic, copy) NSString *telegramUrl;
@property (nonatomic, copy) NSString *githubUrl;

// Настройки 3D-параллакса (амплитуда смещения слоев)
@property (nonatomic, assign) CGFloat bgTiltDepth;
@property (nonatomic, assign) CGFloat treeTiltDepth;
@property (nonatomic, assign) CGFloat waveTiltDepth;
@property (nonatomic, assign) CGFloat plaqueTiltDepth;
@property (nonatomic, assign) CGFloat cardTiltDepth;

+ (instancetype)sharedConfig;

@end
