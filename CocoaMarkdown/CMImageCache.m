//
//  CMImageCache.m
//  CocoaMarkdown
//
//  Created by James Tang on 11/4/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

#import "CMImageCache.h"

NSString *const CMImageCacheImageDidLoadNotification = @"CMImageCacheImageDidLoadNotification";

@implementation CMImageCache {
    NSMutableDictionary *_backingStore;
}

+ (instancetype)sharedInstance {
    static CMImageCache *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _backingStore = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setImage:(CMImage *)image forURL:(NSURL *)URL {
    if ( ! image) {
        [_backingStore removeObjectForKey:URL];
        return;
    }

    [_backingStore setObject:image forKey:URL];
    [[NSNotificationCenter defaultCenter] postNotificationName:CMImageCacheImageDidLoadNotification object:self userInfo:@{@"image":image, @"url":URL}];
}

- (CMImage *)imageForURL:(NSURL *)URL {
    return [_backingStore objectForKey:URL];
}

@end

#pragma mark -

@implementation CMImageCache (Utilities)

- (void)loadImageFromURL:(NSURL *)URL {
    NSLog(@"CMImageCache: Start downloading images with URL %@", URL);
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:URL] queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               CMImage *image = [[CMImage alloc] initWithData:data];
                               NSLog(@"CMImageCache: Finished downloading images from URL %@, error? %@", URL, connectionError);
                               if (image) {
                                   [self setImage:image forURL:URL];
                               }
                           }];
}


+ (CMImage *)placeholderImageWithSize:(CGSize)size {
    return [self imageOfPlaceholderWithFrame:CGRectMake(0, 0, size.width, size.height)];
}

+ (void)drawPlaceholderWithFrame: (CGRect)frame
{
#if TARGET_OS_IPHONE
    //// Color Declarations
    CMColor* color = [CMColor colorWithRed: 0.95 green: 0.95 blue: 0.95 alpha: 1];

    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame)) cornerRadius: 6];
    [color setFill];
    [rectanglePath fill];
#endif
}

#pragma mark Generated Images

+ (CMImage *)imageOfPlaceholderWithFrame: (CGRect)frame
{
#if TARGET_OS_IPHONE
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0f);
    [self drawPlaceholderWithFrame: frame];

    CMImage* imageOfPlaceholder = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageOfPlaceholder;
#endif
    return nil;
}

+ (CGSize)size:(CGSize)originalSize thatAspectFits:(CGSize)size {
    CGFloat widthRatio = size.width / originalSize.width;
    CGFloat heightRatio = size.height / originalSize.height;
    CGFloat ratio = MIN(widthRatio, heightRatio);
    CGAffineTransform transform = CGAffineTransformMakeScale(ratio, ratio);
    CGSize newSize = CGSizeApplyAffineTransform(originalSize, transform);
    return newSize;
}

@end
