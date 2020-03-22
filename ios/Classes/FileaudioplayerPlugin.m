#import "FileaudioplayerPlugin.h"
#if __has_include(<fileaudioplayer/fileaudioplayer-Swift.h>)
#import <fileaudioplayer/fileaudioplayer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fileaudioplayer-Swift.h"
#endif

@implementation FileaudioplayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFileaudioplayerPlugin registerWithRegistrar:registrar];
}
@end
