#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <CaptainHook/CaptainHook.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <dlfcn.h>
#import <sys/utsname.h>
#import <substrate.h>
#import <rootless.h>

#import "uYouPlusThemes.h" // Hide "Buy Super Thanks" banner (_ASDisplayView)
#import "Tweaks/YouTubeHeader/YTAppDelegate.h" // Activate FLEX
#import "Tweaks/YouTubeHeader/YTIMenuConditionalServiceItemRenderer.h"
#import "Tweaks/YouTubeHeader/YTIPlayerBarDecorationModel.h"
#import "Tweaks/YouTubeHeader/YTPlayerBarRectangleDecorationView.h"
#import "Tweaks/YouTubeHeader/YTVideoQualitySwitchOriginalController.h"
#import "Tweaks/YouTubeHeader/YTIGuideResponse.h"
#import "Tweaks/YouTubeHeader/YTIGuideResponseSupportedRenderers.h"
#import "Tweaks/YouTubeHeader/YTIPivotBarSupportedRenderers.h"
#import "Tweaks/YouTubeHeader/YTIPivotBarItemRenderer.h"
#import "Tweaks/YouTubeHeader/YTIBrowseRequest.h"
#import "Tweaks/YouTubeHeader/YTIButtonRenderer.h"
#import "Tweaks/YouTubeHeader/YTIElementRenderer.h"
#import "Tweaks/YouTubeHeader/YTISectionListRenderer.h"
#import "Tweaks/YouTubeHeader/YTWatchNextResultsViewController.h"
#import "Tweaks/YouTubeHeader/YTPlayerOverlay.h"
#import "Tweaks/YouTubeHeader/YTPlayerOverlayProvider.h"
#import "Tweaks/YouTubeHeader/YTReelWatchPlaybackOverlayView.h"
#import "Tweaks/YouTubeHeader/YTInlinePlayerBarContainerView.h"
#import "Tweaks/YouTubeHeader/YTInnerTubeCollectionViewController.h"
#import "Tweaks/YouTubeHeader/YTPivotBarItemView.h"
#import "Tweaks/YouTubeHeader/YTCollectionViewCell.h"
#import "Tweaks/YouTubeHeader/YTIFormattedString.h"
#import "Tweaks/YouTubeHeader/GPBMessage.h"
#import "Tweaks/YouTubeHeader/YTIStringRun.h"

// Hide buttons under the video player by @PoomSmart
#import "Tweaks/YouTubeHeader/ASCollectionElement.h"
#import "Tweaks/YouTubeHeader/ASCollectionView.h"
#import "Tweaks/YouTubeHeader/ELMNodeController.h"

// YouTube-X
#import "Tweaks/YouTubeHeader/YTVideoWithContextNode.h"
#import "Tweaks/YouTubeHeader/ELMCellNode.h"

#define LOC(x) [tweakBundle localizedStringForKey:x value:nil table:nil]
#define IS_ENABLED(k) [[NSUserDefaults standardUserDefaults] boolForKey:k]
#define APP_THEME_IDX [[NSUserDefaults standardUserDefaults] integerForKey:@"appTheme"]
#define YT_BUNDLE_ID @"com.google.ios.youtube"
#define YT_NAME @"YouTube"
#define DEFAULT_RATE 1.0f // YTSpeed
#define LOWCONTRASTMODE_CUTOFF_VERSION @"17.38.10" // LowContrastMode (v17.33.2-17.38.10)

// IAmYouTube
@interface SSOConfiguration : NSObject
@end

// Hide Double tap to seek Overlay
@interface YTInlinePlayerDoubleTapIndicatorView : UIView
@property (nonatomic, strong) UIView *scrimOverlay;
@end

// YTTapToSeek - https://github.com/bhackel/YTTapToSeek
@interface YTMainAppVideoPlayerOverlayViewController : UIViewController
- (CGFloat)totalTime;
@end

// Enable Premium logo - @bhackel
@interface YTITopbarLogoRenderer : NSObject
@property(readonly, nonatomic) YTIIcon *iconImage;
@end

// Hide Premium Promo in You tab - @bhackel
@interface YTIIconThumbnailRenderer : GPBMessage
    @property (nonatomic, strong) YTIIcon *icon;
    - (bool)hasIcon;
@end
@interface YTICompactListItemThumbnailSupportedRenderers : GPBMessage
    @property (nonatomic, strong) YTIIconThumbnailRenderer *iconThumbnailRenderer;
    - (bool)hasIconThumbnailRenderer;
@end
@interface YTICompactListItemRenderer : GPBMessage
    @property (nonatomic, strong) YTICompactListItemThumbnailSupportedRenderers *thumbnail;
    @property (nonatomic, strong) YTIFormattedString *title;
    - (bool)hasThumbnail;
    - (bool)hasTitle;
@end
@interface YTIIcon (uYouEnhanced)
    - (bool)hasIconType;
@end
@interface YTICompactLinkRenderer : GPBMessage
    @property (nonatomic, strong) YTIIcon *icon;
    @property (nonatomic, strong) YTIFormattedString *title;
    @property (nonatomic, strong) YTICompactListItemThumbnailSupportedRenderers *thumbnail;
    - (bool)hasIcon;
    - (bool)hasThumbnail;
@end
@interface YTIItemSectionSupportedRenderers (uYouEnhanced)
    @property(readonly, nonatomic) YTICompactLinkRenderer *compactLinkRenderer;
    @property(readonly, nonatomic) YTICompactListItemRenderer *compactListItemRenderer;
    - (bool)hasCompactLinkRenderer;
    - (bool)hasCompactListItemRenderer;
@end
@interface YTAppCollectionViewController : YTInnerTubeCollectionViewController
- (void)uYouEnhancedFakePremiumModel:(YTISectionListRenderer *)model;
@end
@interface YTInnerTubeCollectionViewController (uYouEnhanced)
    @property(readonly, nonatomic) YTISectionListRenderer *model;
@end

// uYouPlus
@interface YTHeaderLogoController : UIView
@property(readonly, nonatomic) long long pageStyle;
@end

@interface YTNavigationBarTitleView : UIView
@end

@interface YTChipCloudCell : UIView
@end

@interface YTPlayabilityResolutionUserActionUIController : NSObject // Skips content warning before playing *some videos - @PoomSmart
- (void)confirmAlertDidPressConfirm;
@end

@interface YTMainAppControlsOverlayView : UIView
@property(readonly, nonatomic) YTQTMButton *watchCollapseButton;
@end

@interface YTTransportControlsButtonView : UIView
@end

@interface YTFullscreenActionsView : UIView
@end

@interface _ASCollectionViewCell : UICollectionViewCell
- (id)node;
@end

@interface YTAsyncCollectionView : UICollectionView
@end

@interface FRPSliderCell : UITableViewCell
@end

@interface boolSettingsVC : UIViewController
@end

@interface YTPlaybackButton : UIControl
@end

@interface YTPlaylistHeaderViewController : UIViewController
@property UIButton *downloadsButton;
@end

// Buttons
@interface YTRightNavigationButtons : UIView
- (id)_viewControllerForAncestor;
@property(readonly, nonatomic) YTQTMButton *searchButton;
@property(readonly, nonatomic) YTQTMButton *notificationButton;
@property(strong, nonatomic) YTQTMButton *sponsorBlockButton;
@property(strong, nonatomic) YTQTMButton *uYouPlusButton;
- (void)setLeadingPadding:(CGFloat)arg1;
- (void)uYouPlusRootOptionsAction;
@end

@interface YTISlimMetadataButtonSupportedRenderers : NSObject
- (id)slimButton_buttonRenderer;
- (id)slimMetadataButtonRenderer;
@end

// YTSpeed
@interface YTVarispeedSwitchControllerOption : NSObject
- (id)initWithTitle:(id)title rate:(float)rate;
@end

@interface MLHAMQueuePlayer : NSObject
@property id playerEventCenter;
@property id delegate;
- (void)setRate:(float)rate;
- (void)internalSetRate;
@end

@interface MLPlayerStickySettings (uYouPlus)
- (void)setRate:(float)rate;
@end

@interface MLPlayerEventCenter : NSObject
- (void)broadcastRateChange:(float)rate;
@end

@interface HAMPlayerInternal : NSObject
- (void)setRate:(float)rate;
@end

// App Theme
@interface YTColor : NSObject
+ (UIColor *)white1;
+ (UIColor *)white2;
+ (UIColor *)white3;
+ (UIColor *)white4;
+ (UIColor *)white5;
+ (UIColor *)black0;
+ (UIColor *)black1;
+ (UIColor *)black2;
+ (UIColor *)black3;
+ (UIColor *)black4;
+ (UIColor *)blackPure;
+ (UIColor *)grey1;
+ (UIColor *)grey2;
@end

@interface YTPageStyleController
+ (NSInteger)pageStyle;
@end

@interface YCHLiveChatView : UIView
@end

@interface ELMView : UIView
@end

@interface ELMContainerNode : NSObject
@end

@interface YTAutonavEndscreenView : UIView
@end

@interface YTPivotBarIndicatorView : UIView
@end
