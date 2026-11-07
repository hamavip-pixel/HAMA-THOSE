#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static NSString * const kOverlayImagePath =
    @"/Library/Application Support/HAMAOverlay/HAMAOverlay.png";

static UIImageView *gHamaOverlayView = nil;

static UIWindow *HAMAKeyWindow(void) {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) continue;
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        for (UIWindow *window in windowScene.windows) {
            if (window.isKeyWindow) return window;
        }
    }
    return UIApplication.sharedApplication.keyWindow;
}

static void HAMAInstallOverlay(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = HAMAKeyWindow();
        if (!window || gHamaOverlayView) return;

        UIImage *image = [UIImage imageWithContentsOfFile:kOverlayImagePath];
        if (!image) {
            NSLog(@"[HAMA VIP] Add your image as layout/HAMAOverlay.png before building.");
            return;
        }

        CGFloat width = CGRectGetWidth(window.bounds);
        CGFloat height = CGRectGetHeight(window.bounds);

        // Initial position/size are proportional. Adjust these values to your reference.
        CGFloat imageWidth = width * 0.22;
        CGFloat imageHeight = imageWidth * (image.size.height / image.size.width);
        CGFloat x = width * 0.74;
        CGFloat y = height * 0.10;

        gHamaOverlayView = [[UIImageView alloc] initWithImage:image];
        gHamaOverlayView.frame = CGRectMake(x, y, imageWidth, imageHeight);
        gHamaOverlayView.contentMode = UIViewContentModeScaleAspectFit;
        gHamaOverlayView.userInteractionEnabled = NO;
        gHamaOverlayView.backgroundColor = UIColor.clearColor;
        gHamaOverlayView.autoresizingMask = UIViewAutoresizingNone;
        [window addSubview:gHamaOverlayView];
        [window bringSubviewToFront:gHamaOverlayView];

        NSLog(@"[HAMA VIP] Static overlay loaded.");
    });
}

%ctor {
    @autoreleasepool {
        NSString *bundleID = NSBundle.mainBundle.bundleIdentifier ?: @"";
        NSArray *supported = @[
            @"com.tencent.ig",
            @"com.pubg.krmobile",
            @"com.vng.pubgmobile",
            @"com.rekoo.pubgm"
        ];
        if (![supported containsObject:bundleID]) return;

        [[NSNotificationCenter defaultCenter]
            addObserverForName:UIApplicationDidBecomeActiveNotification
            object:nil
            queue:[NSOperationQueue mainQueue]
            usingBlock:^(__unused NSNotification *note) {
                HAMAInstallOverlay();
            }];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            HAMAInstallOverlay();
        });
    }
}
