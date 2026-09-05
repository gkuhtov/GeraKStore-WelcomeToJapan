#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface WelcomeConfig : NSObject

@property (nonatomic, copy) NSString *headlineText;
@property (nonatomic, copy) NSString *sublineText;
@property (nonatomic, copy) NSString *storeSubtitleText;
@property (nonatomic, copy) NSString *continueButtonText;
@property (nonatomic, copy) NSString *neverShowText;
@property (nonatomic, copy) NSString *telegramUrl;
@property (nonatomic, copy) NSString *githubUrl;

@property (nonatomic, copy) NSString *leftPlaqueText;
@property (nonatomic, copy) NSString *rightPlaqueText;
@property (nonatomic, assign) CGSize plaqueSize;
@property (nonatomic, assign) CGPoint leftPlaqueOrigin;
@property (nonatomic, assign) CGPoint rightPlaqueOrigin;
@property (nonatomic, assign) CGFloat plaqueParallaxDepth;

@property (nonatomic, assign) BOOL pulseEnabled;
@property (nonatomic, assign) CGFloat pulseScale;
@property (nonatomic, assign) BOOL hapticEnabled;

+ (instancetype)sharedConfig;
- (void)reloadConfig;

@end
