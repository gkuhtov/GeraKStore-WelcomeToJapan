#import "WelcomeAssets.h"

@implementation WelcomeAssets

+ (UIImage *)imageNamed:(NSString *)name {
    // Поиск ресурсов в бандле твика (.bundle) или общих ресурсах
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    if (!image) {
        image = [UIImage imageNamed:name];
    }
    return image;
}

@end
