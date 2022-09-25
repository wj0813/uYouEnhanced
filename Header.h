#import "Tweaks/YouTubeHeader/YTPlayerViewController.h"

#define LOC(x) [tweakBundle localizedStringForKey:x value:nil table:nil]
#define YT_BUNDLE_ID @"com.google.ios.youtube"
#define YT_NAME @"YouTube"

// IAmYouTube
@interface SSOConfiguration : NSObject
@end

// uYouPlus
@interface YTPlayabilityResolutionUserActionUIController : NSObject // Skips content warning before playing *some videos - @PoomSmart
- (void)confirmAlertDidPressConfirm;
@end 

@interface YTMainAppControlsOverlayView : UIView
@end

@interface YTTransportControlsButtonView : UIView
@end

@interface _ASCollectionViewCell : UICollectionViewCell
- (id)node;
@end

@interface YTAsyncCollectionView : UICollectionView
- (void)removeShortsAndFeaturesAdsAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface FRPSliderCell : UITableViewCell
@end

@interface boolSettingsVC : UIViewController
@end

@interface PlayerManager : NSObject
- (float)progress;
@end

@interface YTPlayerView : UIView
- (BOOL)zoomToFill;
- (id)renderingView;
- (id)playerView;
@end

@interface MLHAMSBDLSampleBufferRenderingView : UIView
@end

@interface YTMainAppVideoPlayerOverlayViewController : UIViewController
- (BOOL)isFullscreen;
- (id)videoPlayerOverlayView;
- (id)activeVideoPlayerOverlay;
@end

@interface YTMainAppVideoPlayerOverlayView : UIView
- (UIViewController *)_viewControllerForAncestor;
+ (CGFloat)topButtonAdditionalPadding;
@end

// iOS16 fix
@interface OBPrivacyLinkButton : UIButton
- (instancetype)initWithCaption:(NSString *)caption
                     buttonText:(NSString *)buttonText
                          image:(UIImage *)image
                      imageSize:(CGSize)imageSize
                   useLargeIcon:(BOOL)useLargeIcon
                displayLanguage:(NSString *)displayLanguage;
@end

// uYouLocal fix
@interface YTLocalPlaybackController : NSObject
- (id)activeVideo;
@end

// BigYTMiniPlayer
@interface YTMainAppVideoPlayerOverlayView : UIView
- (UIViewController *)_viewControllerForAncestor;
@end

@interface YTWatchMiniBarView : UIView
@end

// YTAutoFullScreen
@interface YTPlayerViewController (YTPlayerViewControllerCategory)
- (void)autoFullscreen;
- (id)activeVideoPlayerOverlay;
- (id)playerView;
@end

// OLED Darkmode
@interface ASWAppSwitcherCollectionViewCell : UIView
@end

@interface ASScrollView : UIView
@end

@interface UIKeyboardLayoutStar : UIView
@end

@interface UIKeyboardDockView : UIView
@end

@interface _ASDisplayView : UIView
@end

@interface YTCommentDetailHeaderCell : UIView
@end

@interface SponsorBlockSettingsController : UITableViewController
@end

@interface SponsorBlockViewController : UIViewController
@end

@interface UICandidateViewController : UIViewController
@end

@interface UIPredictionViewController : UIViewController
@end

//
NSString* deviceName();
BOOL isDeviceSupported();
void activate(); 
void deactivate();
void center();