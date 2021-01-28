#import "TinkPlugin.h"
#if __has_include(<tink_plugin/tink_plugin-Swift.h>)
#import <tink_plugin/tink_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tink_plugin-Swift.h"
#endif

@implementation TinkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTinkPlugin registerWithRegistrar:registrar];
}
@end
