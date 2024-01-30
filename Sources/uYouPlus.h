#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <dlfcn.h>
#import <sys/utsname.h>
#import <substrate.h>
#import <rootless.h>

#import "uYouPlusThemes.h" // Hide "Buy Super Thanks" banner (_ASDisplayView)
#import "../Tweaks/YouTubeHeader/YTAppDelegate.h" // Activate FLEX
#import "../Tweaks/YouTubeHeader/YTIMenuConditionalServiceItemRenderer.h"

// #import "../Tweaks/YouTubeHeader/YTISectionListRenderer.h" // Hide search ads by @PoomSmart - https://github.com/PoomSmart/YouTube-X

#define LOC(x) [tweakBundle localizedStringForKey:x value:nil table:nil]
#define IS_ENABLED(k) [[NSUserDefaults standardUserDefaults] boolForKey:k]
#define APP_THEME_IDX [[NSUserDefaults standardUserDefaults] integerForKey:@"appTheme"]

// Disable snap to chapter
@interface YTSegmentableInlinePlayerBarView
@property (nonatomic, assign, readwrite) BOOL enableSnapToChapter;
@end

// Hide autoplay switch / CC button
@interface YTMainAppControlsOverlayView : UIView
@end

// Skips content warning before playing *some videos - @PoomSmart
@interface YTPlayabilityResolutionUserActionUIController : NSObject
- (void)confirmAlertDidPressConfirm;
@end

// Hide iSponsorBlock
@interface YTRightNavigationButtons : UIView
@property (nonatomic, readwrite, strong) UIView *sponsorBlockButton;
@end

// Hide YouTube annoying banner in Home page? - @MiRO92 - YTNoShorts: https://github.com/MiRO92/YTNoShorts
@interface _ASCollectionViewCell : UICollectionViewCell
- (id)node;
@end
@interface YTAsyncCollectionView : UICollectionView
- (void)removeShortsAndFeaturesAdsAtIndexPath:(NSIndexPath *)indexPath;
@end
