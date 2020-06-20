#import "DYPlugin.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

static NSString *const CHANNEL_NAME = @"com.hg.dy/DYPlugin";

@interface DYPlugin ()
@property(nonatomic, retain) FlutterMethodChannel *channel;
@end

@implementation DYPlugin


+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:CHANNEL_NAME
                  binaryMessenger:[registrar messenger]];
    DYPlugin *instance = [[DYPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}
  


- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if([@"getVideoThumbnail" isEqualToString:call.method]) {
        FlutterStandardTypedData *thumbnail = [self getScreenShotImageFromVideoPath:call.arguments];
        result(thumbnail);
    }else if ([@"shareVideo" isEqualToString:call.method]) {
        [self shareVideo:call.arguments];
        result(nil);
    }else if ([@"getVideoSize" isEqualToString:call.method]) {
        NSURL *fileURL = [NSURL fileURLWithPath:call.arguments];
        AVURLAsset  *asset = [AVURLAsset assetWithURL:fileURL];
        NSArray *array = asset.tracks;
        CGSize videoSize = CGSizeZero;
        for(AVAssetTrack  *track in array)
        {
            if([track.mediaType isEqualToString:AVMediaTypeVideo])
            {
                  videoSize = track.naturalSize;
            }
        }
        NSString *stringFloat = [NSString stringWithFormat:@"%f,%f",videoSize.width,videoSize.height];
        
        result(stringFloat);
    }else {
        result(FlutterMethodNotImplemented);
    }
}


-(void) shareVideo:(NSString *) filePath{
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    UIActivityViewController *c = [[UIActivityViewController alloc]initWithActivityItems:@[fileURL] applicationActivities:nil];
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootViewController = appdelegate.window.rootViewController;
    [rootViewController presentViewController:c animated:YES completion:nil];
}

/**
 *  获取视频的缩略图方法
 *  @param filePath 视频的本地路径
 *  @return 视频截图
 */
- (FlutterStandardTypedData *)getScreenShotImageFromVideoPath:(NSString *)filePath{
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];

    UIImage *shotImage;

    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];

    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];

    gen.appliesPreferredTrackTransform = YES;

    CMTime time = CMTimeMakeWithSeconds(0.0, 600);

    NSError *error = nil;

    CMTime actualTime;

    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];

    shotImage = [[UIImage alloc] initWithCGImage:image];

    CGImageRelease(image);

    NSData *imageData = UIImagePNGRepresentation(shotImage);

    FlutterStandardTypedData *data = [FlutterStandardTypedData typedDataWithBytes:imageData];

    return data;
}

@end
