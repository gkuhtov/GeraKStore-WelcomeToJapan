#import <Foundation/Foundation.h>

@interface WelcomeConfig : NSObject

@property (nonatomic, copy) NSString *headlineText;
@property (nonatomic, copy) NSString *sublineText;
@property (nonatomic, copy) NSString *leftPlaqueText;
@property (nonatomic, copy) NSString *rightPlaqueText;
@property (nonatomic, copy) NSString *continueButtonText;
@property (nonatomic, copy) NSString *neverShowText;
@property (nonatomic, copy) NSString *telegramUrl;
@property (nonatomic, copy) NSString *githubUrl;

+ (instancetype)sharedConfig;

@end
