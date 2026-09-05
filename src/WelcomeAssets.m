#import "WelcomeAssets.h"

@implementation WelcomeAssets

+ (UIImage *)imageNamed:(NSString *)name {
    // 1. Проверяем установленный каталог ресурсов твика
    NSString *tweakResPath = [@"/Library/Application Support/WelcomeToJapan" stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:tweakResPath]) {
        return [UIImage imageWithContentsOfFile:tweakResPath];
    }
    
    // 2. Проверяем бандл приложения (для инжекта в IPA)
    NSString *mainBundlePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    if (mainBundlePath && [[NSFileManager defaultManager] fileExistsAtPath:mainBundlePath]) {
        return [UIImage imageWithContentsOfFile:mainBundlePath];
    }

    // 3. Стандартный системный поиск
    return [UIImage imageNamed:name];
}

@end
