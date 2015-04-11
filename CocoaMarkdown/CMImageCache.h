//
//  CMImageCache.h
//  CocoaMarkdown
//
//  Created by James Tang on 11/4/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CMPlatformDefines.h"

extern NSString *const CMImageCacheImageDidLoadNotification;

@interface CMImageCache : NSObject

+ (instancetype)sharedInstance;

- (void)setImage:(CMImage *)image forURL:(NSURL *)URL;
- (CMImage *)imageForURL:(NSURL *)URL;

@end


@interface CMImageCache (Utilities)

- (void)loadImageFromURL:(NSURL *)URL;
+ (CMImage *)placeholderImageWithSize:(CGSize)size;

@end
