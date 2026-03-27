#import <UIKit/UIKit.h>
#import <Security/Security.h>

// 1. UIDevice himoyasi
%hook UIDevice
- (NSString *)identifierForVendor {
    return @"00000000-0000-0000-0000-000000000000";
}
- (NSString *)name { return @"iPhone14,5"; }
- (NSString *)model { return @"iPhone"; }
%end

// 2. Keychain tozalash (asl Apple)
%hook SecItem
+ (CFTypeRef)SecItemCopyMatching:(CFDictionaryRef)query result:(CFTypeRef *)result {
    return kSecErrNotFound;  // Hech narsa topilmasin
}
%end

// 3. LITSENZIYA BYPASS (umumiy)
%hook NSObject
- (BOOL)isValid { return YES; }
- (BOOL)isActivated { return YES; }
- (BOOL)isExpired { return NO; }
- (BOOL)isLicensed { return YES; }
- (BOOL)checkKey:(id)key { return YES; }
- (BOOL)validateLicense { return YES; }
%end

// 4. VANTROX maxsus
%hook NSString
- (BOOL)isEqualToString:(NSString *)other {
    if ([other containsString:@"VANTROX"] || 
        [other containsString:@"I6WPE9VKCUZAMG85"]) {
        return YES;
    }
    return %orig;
}
%end

// 5. Key dialog bloklash
%hook UIAlertController
+ (UIAlertController *)alertControllerWithTitle:(NSString *)title 
                                        message:(NSString *)message 
                                 preferredStyle:(UIAlertControllerStyle)style {
    if ([title containsString:@"license"] || 
        [title containsString:@"VANTROX"] ||
        [message containsString:@"key"]) {
        return nil;
    }
    return %orig;
}
%end

%ctor {
    NSLog(@"✅ [VANTROX] License bypass active!");
}
