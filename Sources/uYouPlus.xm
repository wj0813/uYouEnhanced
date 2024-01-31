#import "uYouPlus.h"

// Tweak's bundle for Localizations support - @PoomSmart - https://github.com/PoomSmart/YouPiP/commit/aea2473f64c75d73cab713e1e2d5d0a77675024f
NSBundle *uYouPlusBundle() {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
 	dispatch_once(&onceToken, ^{
        NSString *tweakBundlePath = [[NSBundle mainBundle] pathForResource:@"uYouPlus" ofType:@"bundle"];
        if (tweakBundlePath)
            bundle = [NSBundle bundleWithPath:tweakBundlePath];
        else
            bundle = [NSBundle bundleWithPath:ROOT_PATH_NS(@"/Library/Application Support/uYouPlus.bundle")];
    });
    return bundle;
}
NSBundle *tweakBundle = uYouPlusBundle();

# pragma mark - App appearance
// See uYouPlusThemes.xm

# pragma mark - Video player options
// Bring back Slide to seek - https://github.com/PoomSmart/YTABConfig/discussions/95#discussioncomment-8166019
%hook YTColdConfig
- (BOOL)speedMasterArm2FastForwardWithoutSeekBySliding {
    return IS_ENABLED(@"slideToSeek_enabled") ? NO : %orig;
}
%end

// Disable double tap to seek
%hook YTDoubleTapToSeekController
- (void)enableDoubleTapToSeek:(BOOL)arg1 {
    return IS_ENABLED(@"doubleTapToSeek_disabled") ? %orig(NO) : %orig;
}
%end

// Disable snap to chapter
%hook YTSegmentableInlinePlayerBarView
- (void)didMoveToWindow {
    %orig;
    if (IS_ENABLED(@"snapToChapter_enabled")) {
        self.enableSnapToChapter = NO;
    }
}
%end

// Disable pinch to zoom
%hook YTColdConfig
- (BOOL)videoZoomFreeZoomEnabledGlobalConfig {
    return IS_ENABLED(@"pinchToZoom_enabled") ? NO : %orig;
}
%end

// Enable miniplayer for all videos
// See YTMiniPlayerEnabler.x

// Use stock iOS volume HUD
// See YTStockVolumeHUD.xm

# pragma mark - Video control overlay options

%hook YTMainAppControlsOverlayView
// Hide autoplay switch
- (void)setAutoplaySwitchButtonRenderer:(id)arg1 { // hide Autoplay
    if (IS_ENABLED(@"hideAutoplaySwitch_enabled")) {}
    else { return %orig; }
}
// Hide CC button
- (void)setClosedCaptionsOrSubtitlesButtonAvailable:(BOOL)arg1 {
    return IS_ENABLED(@"hideCC_enabled") ? %orig(NO) : %orig;
}
%end

// Hide HUD Messages
%hook YTHUDMessageView
- (id)initWithMessage:(id)arg1 dismissHandler:(id)arg2 {
    return IS_ENABLED(@"hideHUD_enabled") ? nil : %orig;
}
%end

// Hide paid promotion banner
// See YTNoPaidPromo.x

// Hide channel watermark
%hook YTAnnotationsViewController
- (void)loadFeaturedChannelWatermark {
    if (IS_ENABLED(@"hideChannelWatermark_enabled")) {}
    else { return %orig; }
}
%end
%hook YTColdConfig
- (BOOL)iosEnableFeaturedChannelWatermarkOverlayFix {
    return IS_ENABLED(@"hideChannelWatermark_enabled") ? NO : %orig;
}
%end

// Hide next and previous buttons
%group gHidePreviousAndNextButton
%hook YTColdConfig
- (BOOL)removeNextPaddleForSingletonVideos { return YES; }
- (BOOL)removePreviousPaddleForSingletonVideos { return YES; }
%end
%end

// Replace next and previous buttons with fast forward and rewind
%group gReplacePreviousAndNextButton
%hook YTColdConfig
- (BOOL)replaceNextPaddleWithFastForwardButtonForSingletonVods { return YES; }
- (BOOL)replacePreviousPaddleWithRewindButtonForSingletonVods { return YES; }
%end
%end

// Bring back the red progress bar - Broken?!
%hook YTInlinePlayerBarContainerView
- (id)quietProgressBarColor {
    return IS_ENABLED(@"redProgressBar_enabled") ? [UIColor redColor] : %orig;
}
%end

// Hide videos' end screens
// See YTNoHoverCards.x

// Hide engagement panels in full screen
%hook YTColdConfig
- (BOOL)isLandscapeEngagementPanelEnabled {
    return IS_ENABLED(@"hideRightPanel_enabled") ? NO : %orig;
}
%end

// Skips content warning before playing *some videos - @PoomSmart
%hook YTPlayabilityResolutionUserActionUIController
- (void)showConfirmAlert { [self confirmAlertDidPressConfirm]; }
%end

# pragma mark - Shorts controls overlay options

// Hide "Buy Super Thanks" banner
%hook _ASDisplayView
- (void)didMoveToWindow {
    %orig;
    if ((IS_ENABLED(@"hideBuySuperThanks_enabled")) && ([self.accessibilityIdentifier isEqualToString:@"id.elements.components.suggested_action"])) { 
        self.hidden = YES; 
    }
}
%end

// Hide subscriptions button
%hook YTReelWatchRootViewController
- (void)setPausedStateCarouselView {
    if (IS_ENABLED(@"hideSubcriptions_enabled")) {}
    else { return %orig; }
}
%end

// Disable resume to Shorts
%hook YTShortsStartupCoordinator
- (id)evaluateResumeToShorts { 
    return IS_ENABLED(@"disableResumeToShorts") ? nil : %orig;
}
%end

# pragma mark - Miscellaneous

// Hide iSponsorBlock
%hook YTRightNavigationButtons
- (void)didMoveToWindow {
    %orig;
    if (IS_ENABLED(@"hideiSponsorBlockButton_enabled"))
        self.sponsorBlockButton.hidden = YES;
}
%end

// YTCastConfirm
// See YTCastConfirm.xm

// Disable hints - https://github.com/LillieH001/YouTube-Reborn/blob/v4/
%group gDisableHints
%hook YTSettings
- (BOOL)areHintsDisabled {
	return YES;
}
- (void)setHintsDisabled:(BOOL)arg1 {
    %orig(YES);
}
%end
%hook YTUserDefaults
- (BOOL)areHintsDisabled {
	return YES;
}
- (void)setHintsDisabled:(BOOL)arg1 {
    %orig(YES);
}
%end
%end

// Enable YouTube startup animation
%hook YTColdConfig
- (BOOL)mainAppCoreClientIosEnableStartupAnimation {
    return IS_ENABLED(@"ytStartupAnimation_enabled") ? YES : NO;
}
%end

// Hide upper bar
%group gHideChipBar
%hook YTMySubsFilterHeaderView 
- (void)setChipFilterView:(id)arg1 {}
%end

%hook YTHeaderContentComboView
- (void)enableSubheaderBarWithView:(id)arg1 {}
%end

%hook YTHeaderContentComboView
- (void)setFeedHeaderScrollMode:(int)arg1 { %orig(0); }
%end
%end

// Hide "Play next in queue" - qnblackcat/uYouPlus#1138
%hook YTMenuItemVisibilityHandler
- (BOOL)shouldShowServiceItemRenderer:(YTIMenuConditionalServiceItemRenderer *)renderer {
    return IS_ENABLED(@"hidePlayNextInQueue_enabled") && renderer.icon.iconType == 251 ? NO : %orig;
}
%end

// Force iPhone layout
%group giPhoneLayout
%hook UIDevice
- (long long)userInterfaceIdiom {
    return NO;
} 
%end
%hook UIStatusBarStyleAttributes
- (long long)idiom {
    return YES;
} 
%end
%hook UIKBTree
- (long long)nativeIdiom {
    return YES;
} 
%end
%hook UIKBRenderer
- (long long)assetIdiom {
    return YES;
} 
%end
%end

# pragma mark - Other hooks

// Activate FLEX
%hook YTAppDelegate
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    BOOL didFinishLaunching = %orig;
    if (IS_ENABLED(@"flex_enabled")) {
        [[%c(FLEXManager) performSelector:@selector(sharedManager)] performSelector:@selector(showExplorer)];
    }
    return didFinishLaunching;
}
- (void)appWillResignActive:(id)arg1 {
    %orig;
    if (IS_ENABLED(@"flex_enabled")) {
        [[%c(FLEXManager) performSelector:@selector(sharedManager)] performSelector:@selector(showExplorer)];
    }
}
%end

// Hide YouTube annoying banner in Home page? - @MiRO92 - YTNoShorts: https://github.com/MiRO92/YTNoShorts
%hook YTAsyncCollectionView
- (id)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = %orig;
    if ([cell isKindOfClass:NSClassFromString(@"_ASCollectionViewCell")]) {
        _ASCollectionViewCell *cell = %orig;
        if ([cell respondsToSelector:@selector(node)]) {
            if ([[[cell node] accessibilityIdentifier] isEqualToString:@"statement_banner.view"]) { [self removeShortsAndFeaturesAdsAtIndexPath:indexPath]; }
            if ([[[cell node] accessibilityIdentifier] isEqualToString:@"compact.view"]) { [self removeShortsAndFeaturesAdsAtIndexPath:indexPath]; }
            // if ([[[cell node] accessibilityIdentifier] isEqualToString:@"id.ui.video_metadata_carousel"]) { [self removeShortsAndFeaturesAdsAtIndexPath:indexPath]; }
        }
    }
    return %orig;
}
%new
- (void)removeShortsAndFeaturesAdsAtIndexPath:(NSIndexPath *)indexPath {
    [self deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}
%end

// Hide search ads by @PoomSmart - https://github.com/PoomSmart/YouTube-X
// %hook YTIElementRenderer
// - (NSData *)elementData {
//     if (self.hasCompatibilityOptions && self.compatibilityOptions.hasAdLoggingData)
//         return nil;
//     return %orig;
// }
// %end

// %hook YTSectionListViewController
// - (void)loadWithModel:(YTISectionListRenderer *)model {
//     NSMutableArray <YTISectionListSupportedRenderers *> *contentsArray = model.contentsArray;
//     NSIndexSet *removeIndexes = [contentsArray indexesOfObjectsPassingTest:^BOOL(YTISectionListSupportedRenderers *renderers, NSUInteger idx, BOOL *stop) {
//         YTIItemSectionRenderer *sectionRenderer = renderers.itemSectionRenderer;
//         YTIItemSectionSupportedRenderers *firstObject = [sectionRenderer.contentsArray firstObject];
//         return firstObject.hasPromotedVideoRenderer || firstObject.hasCompactPromotedVideoRenderer || firstObject.hasPromotedVideoInlineMutedRenderer;
//     }];
//     [contentsArray removeObjectsAtIndexes:removeIndexes];
//     %orig;
// }
// %end

// A/B flags
%hook YTColdConfig 
// YouRememberCaption: https://poomsmart.github.io/repo/depictions/youremembercaption.html
- (BOOL)respectDeviceCaptionSetting { return NO; }
// Swipe right to dismiss the right panel in fullscreen mode
- (BOOL)isLandscapeEngagementPanelSwipeRightToDismissEnabled { return YES; }
%end

# pragma mark - Constructor

%ctor {
    // Load uYou first so its functions are available for hooks.
    // dlopen([[NSString stringWithFormat:@"%@/Frameworks/uYou.dylib", [[NSBundle mainBundle] bundlePath]] UTF8String], RTLD_LAZY);

    %init;
    if (IS_ENABLED(@"hidePreviousAndNextButton_enabled")) {
        %init(gHidePreviousAndNextButton);
    }
    if (IS_ENABLED(@"replacePreviousAndNextButton_enabled")) {
        %init(gReplacePreviousAndNextButton);
    }
    if (IS_ENABLED(@"disableHints_enabled")) {
        %init(gDisableHints);
    }
    if (IS_ENABLED(@"hideChipBar_enabled")) {
        %init(gHideChipBar);
    }
    if (IS_ENABLED(@"iPhoneLayout_enabled") && (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)) {
        %init(giPhoneLayout);
    }
    
    // Change the default value of some options
    NSArray *allKeys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    if (![allKeys containsObject:@"hidePlayNextInQueue_enabled"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hidePlayNextInQueue_enabled"];
    }
    if (![allKeys containsObject:@"relatedVideosAtTheEndOfYTVideos"]) { 
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"relatedVideosAtTheEndOfYTVideos"]; 
    }
    if (![allKeys containsObject:@"shortsProgressBar"]) { 
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shortsProgressBar"]; 
    }
    if (![allKeys containsObject:@"RYD-ENABLED"]) { 
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RYD-ENABLED"]; 
    }
    if (![allKeys containsObject:@"YouPiPEnabled"]) { 
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"YouPiPEnabled"]; 
    }
}
