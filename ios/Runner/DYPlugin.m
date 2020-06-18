#import "DYPlugin.h"
#import <AVFoundation/AVFoundation.h>

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
    } else if ([@"getVideoDuration" isEqualToString:call.method]) {
        result([self getVideoTimeByUrlString:call.arguments]);
    }  else if ([@"shareVideo" isEqualToString:call.method]) {
        
        
        
           result([self getVideoTimeByUrlString:call.arguments]);
    }else {
        result(FlutterMethodNotImplemented);
    }
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


//获取视频时长
- (NSNumber*)getVideoTimeByUrlString:(NSString*)urlString {
NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
forKey:AVURLAssetPreferPreciseDurationAndTimingKey];

    
    NSURL*videoUrl = [NSURL URLWithString:urlString ];
AVURLAsset *avUrl = [AVURLAsset URLAssetWithURL:videoUrl options:opts];
CMTime time = [avUrl duration];
int seconds = ceil(time.value/time.timescale);
return [NSNumber numberWithInt:seconds];

}



@end
