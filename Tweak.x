#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

// 1. Xotira patcher (Bypass uchun)
void apply_patch(uintptr_t address, uint32_t value) {
    mach_port_t task = mach_task_self();
    vm_address_t page_start = trunc_page(address);
    if (vm_protect(task, page_start, vm_page_size, FALSE, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY) == KERN_SUCCESS) {
        *(uint32_t *)address = value;
        vm_protect(task, page_start, vm_page_size, FALSE, VM_PROT_READ | VM_PROT_EXECUTE);
    }
}

// 2. UIDevice-ni yashirish (Device ID-ni nol qilish)
%hook UIDevice
- (NSString *)identifierForVendor {
    return @"00000000-0000-0000-0000-000000000000";
}
- (NSString *)name { return @"iPhone"; }
- (NSString *)model { return @"iPhone"; }
- (NSString *)systemVersion { return @"17.0"; }
%end

// 3. Keychain-ni bloklash (Ban izlarini tozalash)
%hook UICKeyChainStore
- (id)stringForKey:(id)key { return nil; }
- (_Bool)setString:(id)string forKey:(id)key { return YES; }
%end

// 4. Key (Kalit) oynasini olib tashlash
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        uintptr_t slide = _dyld_get_image_vmaddr_slide(0);
        // ShadowTrackerExtra v4.3.0 Key Bypass
        apply_patch(slide + 0x15E6680, 0xD65F03C0);
    });
}
