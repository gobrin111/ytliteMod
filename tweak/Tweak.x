// Ad-blocking hooks ported from YTLite's YTLite.x (upstream/YTLite-v5.2b4, lines 17-70).
// Every class and selector hooked or called here was found by name in YouTube 21.44.4.
#import <Foundation/Foundation.h>

@interface YTIElementRendererCompatibilityOptions : NSObject
@property (nonatomic, assign, readonly) BOOL hasAdLoggingData;
@end

@interface YTIElementRenderer : NSObject
@property (nonatomic, assign, readonly) BOOL hasCompatibilityOptions;
@property (nonatomic, strong, readonly) YTIElementRendererCompatibilityOptions *compatibilityOptions;
@end

@interface YTIItemSectionSupportedRenderers : NSObject
@property (nonatomic, assign, readonly) BOOL hasPromotedVideoRenderer;
@property (nonatomic, assign, readonly) BOOL hasCompactPromotedVideoRenderer;
@property (nonatomic, assign, readonly) BOOL hasPromotedVideoInlineMutedRenderer;
@end

@interface YTIItemSectionRenderer : NSObject
@property (nonatomic, strong, readonly) NSMutableArray <YTIItemSectionSupportedRenderers *> *contentsArray;
@end

@interface YTISectionListSupportedRenderers : NSObject
@property (nonatomic, strong, readonly) YTIItemSectionRenderer *itemSectionRenderer;
@end

@interface YTISectionListRenderer : NSObject
@property (nonatomic, strong, readonly) NSMutableArray <YTISectionListSupportedRenderers *> *contentsArray;
@end

%hook YTIPlayerResponse
- (BOOL)isMonetized { return NO; }
%end

%hook YTDataUtils
+ (id)spamSignalsDictionary { return nil; }
+ (id)spamSignalsDictionaryWithoutIDFA { return nil; }
%end

// Upstream also skipped -decorateContext: on the two ads context decorators. That selector
// is gone in 21.44.4 (there is a decorateContext:serviceType: instead), so it is left out
// until its real signature is known.

%hook YTIElementRenderer
- (NSData *)elementData {
    if (self.hasCompatibilityOptions && self.compatibilityOptions.hasAdLoggingData) return nil;
    return %orig;
}
%end

%hook YTSectionListViewController
- (void)loadWithModel:(YTISectionListRenderer *)model {
    NSMutableArray <YTISectionListSupportedRenderers *> *contentsArray = model.contentsArray;
    NSIndexSet *removeIndexes = [contentsArray indexesOfObjectsPassingTest:^BOOL(YTISectionListSupportedRenderers *renderers, NSUInteger idx, BOOL *stop) {
        YTIItemSectionSupportedRenderers *firstObject = [renderers.itemSectionRenderer.contentsArray firstObject];
        return firstObject.hasPromotedVideoRenderer || firstObject.hasCompactPromotedVideoRenderer || firstObject.hasPromotedVideoInlineMutedRenderer;
    }];
    [contentsArray removeObjectsAtIndexes:removeIndexes];
    %orig;
}
%end
