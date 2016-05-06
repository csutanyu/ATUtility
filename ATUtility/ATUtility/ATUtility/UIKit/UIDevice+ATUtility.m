//
//  UIDevice+ATUtility.m
//  ATUtility
//
//  Created by arvin.tan on 15/11/20.
//  Copyright © 2015年 arvin.tan. All rights reserved.
//

#import "UIDevice+ATUtility.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>
#include <net/ethernet.h>
#include <ifaddrs.h>

#define    min(a,b)    ((a) < (b) ? (a) : (b))
#define    max(a,b)    ((a) > (b) ? (a) : (b))

#define BUFFERSIZE    4000
#define MAXADDRS    32

char *if_names[MAXADDRS];
char *ip_names[MAXADDRS];
char *hw_addrs[MAXADDRS];
unsigned long ip_addrs[MAXADDRS];

static int   nextAddr = 0;

@implementation UIDevice (ATUtility)

// Ref: http://www.oschina.net/question/565065_64686
+ (void)initAddresses {
    int i;
    for (i=0; i<MAXADDRS; ++i)
    {
        if_names[i] = ip_names[i] = hw_addrs[i] = NULL;
        ip_addrs[i] = 0;
    }
}

+ (void)freeAddresses {
    nextAddr = 0;
    int i;
    for (i=0; i<MAXADDRS; ++i)
    {
        if (if_names[i] != 0) free(if_names[i]);
        if (ip_names[i] != 0) free(ip_names[i]);
        if (hw_addrs[i] != 0) free(hw_addrs[i]);
        ip_addrs[i] = 0;
    }
}

+ (void)getIPAddresses{
    int                 i, len, flags;
    char                buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifconf       ifc;
    struct ifreq        *ifr, ifrcopy;
    struct sockaddr_in    *sin;
    
    char temp[80];
    
    int sockfd;
    
    for (i=0; i<MAXADDRS; ++i)
    {
        if_names[i] = ip_names[i] = NULL;
        ip_addrs[i] = 0;
    }
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        perror("socket failed");
        return;
    }
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) < 0)
    {
        perror("ioctl error");
        return;
    }
    
    lastname[0] = 0;
    
    for (ptr = buffer; ptr < buffer + ifc.ifc_len; )
    {
        ifr = (struct ifreq *)ptr;
        len = max(sizeof(struct sockaddr), ifr->ifr_addr.sa_len);
        ptr += sizeof(ifr->ifr_name) + len;    // for next one in buffer
        
        if (ifr->ifr_addr.sa_family != AF_INET)
        {
            continue;    // ignore if not desired address family
        }
        
        if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL)
        {
            *cptr = 0;        // replace colon will null
        }
        
        if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0)
        {
            continue;    /* already processed this interface */
        }
        
        memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
        
        ifrcopy = *ifr;
        ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
        flags = ifrcopy.ifr_flags;
        if ((flags & IFF_UP) == 0)
        {
            continue;    // ignore if interface not up
        }
        
        if_names[nextAddr] = (char *)malloc(strlen(ifr->ifr_name)+1);
        if (if_names[nextAddr] == NULL)
        {
            return;
        }
        strcpy(if_names[nextAddr], ifr->ifr_name);
        
        sin = (struct sockaddr_in *)&ifr->ifr_addr;
        strcpy(temp, inet_ntoa(sin->sin_addr));
        
        ip_names[nextAddr] = (char *)malloc(strlen(temp)+1);
        if (ip_names[nextAddr] == NULL)
        {
            return;
        }
        strcpy(ip_names[nextAddr], temp);
        
        ip_addrs[nextAddr] = sin->sin_addr.s_addr;
        
        ++nextAddr;
    }
    
    close(sockfd);
}

+ (void)getHWAddresses {
    struct ifconf ifc;
    struct ifreq *ifr;
    int i, sockfd;
    char buffer[BUFFERSIZE], *cp, *cplim;
    char temp[80];
    
    for (i=0; i<MAXADDRS; ++i)
    {
        hw_addrs[i] = NULL;
    }
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        perror("socket failed");
        return;
    }
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, (char *)&ifc) < 0)
    {
        perror("ioctl error");
        close(sockfd);
        return;
    }
    
    ifr = ifc.ifc_req;
    
    cplim = buffer + ifc.ifc_len;
    
    for (cp=buffer; cp < cplim; )
    {
        ifr = (struct ifreq *)cp;
        if (ifr->ifr_addr.sa_family == AF_LINK)
        {
            struct sockaddr_dl *sdl = (struct sockaddr_dl *)&ifr->ifr_addr;
            int a,b,c,d,e,f;
            int i;
            
            strcpy(temp, (char *)ether_ntoa((const struct ether_addr *)LLADDR(sdl)));
            sscanf(temp, "%x:%x:%x:%x:%x:%x", &a, &b, &c, &d, &e, &f);
            sprintf(temp, "%02X:%02X:%02X:%02X:%02X:%02X",a,b,c,d,e,f);
            
            for (i=0; i<MAXADDRS; ++i)
            {
                if ((if_names[i] != NULL) && (strcmp(ifr->ifr_name,if_names[i]) == 0))
                {
                    if (hw_addrs[i] == NULL)
                    {
                        hw_addrs[i] = (char *)malloc(strlen(temp)+1);
                        strcpy(hw_addrs[i], temp);
                        break;
                    }
                }
            }
        }
        cp += sizeof(ifr->ifr_name) + max(sizeof(ifr->ifr_addr), ifr->ifr_addr.sa_len);
    }
    
    close(sockfd);
}

+ (NSString *)IPAddress {
#if 0
    NSString *ip;
    @synchronized(self) {
        [self initAddresses];
        [self getIPAddresses];
        [self getHWAddresses];
        ip = [NSString stringWithFormat:@"%s", ip_names[1]];
        [self freeAddresses];
    }
    return ip;
#else
    return [self wifiIPAddress];
#endif
}

+ (NSString *)wifiIPAddress {
    @try {
        // Set a string for the address
        NSString *IPAddress;
        // Set up structs to hold the interfaces and the temporary address
        struct ifaddrs *Interfaces;
        struct ifaddrs *Temp;
        // Set up int for success or fail
        int Status = 0;
        
        // Get all the network interfaces
        Status = getifaddrs(&Interfaces);
        
        // If it's 0, then it's good
        if (Status == 0)
        {
            // Loop through the list of interfaces
            Temp = Interfaces;
            
            // Run through it while it's still available
            while(Temp != NULL)
            {
                // If the temp interface is a valid interface
                if(Temp->ifa_addr->sa_family == AF_INET)
                {
                    // Check if the interface is WiFi
                    if([[NSString stringWithUTF8String:Temp->ifa_name] isEqualToString:@"en0"])
                    {
                        // Get the WiFi IP Address
                        IPAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)Temp->ifa_addr)->sin_addr)];
                    }
                }
                
                // Set the temp value to the next interface
                Temp = Temp->ifa_next;
            }
        }
        
        // Free the memory of the interfaces
        freeifaddrs(Interfaces);
        
        // Check to make sure it's not empty
        if (IPAddress == nil || IPAddress.length <= 0) {
            // Empty, return not found
            return nil;
        }
        
        // Return the IP Address of the WiFi
        return IPAddress;
    }
    @catch (NSException *exception) {
        // Error, IP Not found
        return nil;
    }
}

+ (NSString*)hardwareString {
    int name[] = {CTL_HW,HW_MACHINE};
    size_t size = 100;
    sysctl(name, 2, NULL, &size, NULL, 0); // getting size of answer
    char *hw_machine = malloc(size);
    
    sysctl(name, 2, hw_machine, &size, NULL, 0);
    NSString *hardware = [NSString stringWithUTF8String:hw_machine];
    free(hw_machine);
    return hardware;
}


+ (NSString*)hardwareDescription {
    NSString *hardware = [self hardwareString];
    if ([hardware isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([hardware isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([hardware isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([hardware isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([hardware isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (GSM Rev. A)";
    if ([hardware isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([hardware isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([hardware isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([hardware isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (Global)";
    if ([hardware isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (GSM)";
    if ([hardware isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (Global)";
    if ([hardware isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([hardware isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (Global)";
    
    if ([hardware isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([hardware isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([hardware isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([hardware isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([hardware isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([hardware isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([hardware isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([hardware isEqualToString:@"iPad1,1"])      return @"iPad (WiFi)";
    if ([hardware isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([hardware isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([hardware isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([hardware isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([hardware isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi Rev. A)";
    if ([hardware isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([hardware isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([hardware isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
    if ([hardware isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([hardware isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
    if ([hardware isEqualToString:@"iPad3,3"])      return @"iPad 3 (Global)";
    if ([hardware isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([hardware isEqualToString:@"iPad3,5"])      return @"iPad 4 (CDMA)";
    if ([hardware isEqualToString:@"iPad3,6"])      return @"iPad 4 (Global)";
    if ([hardware isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([hardware isEqualToString:@"iPad4,2"])      return @"iPad Air (WiFi+GSM)";
    if ([hardware isEqualToString:@"iPad4,3"])      return @"iPad Air (WiFi+CDMA)";
    if ([hardware isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina (WiFi)";
    if ([hardware isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina (WiFi+CDMA)";
    if ([hardware isEqualToString:@"iPad4,6"])      return @"iPad Mini Retina (Wi-Fi + Cellular CN)";
    if ([hardware isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (Wi-Fi)";
    if ([hardware isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Wi-Fi + Cellular)";
    if ([hardware isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (Wi-Fi)";
    if ([hardware isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Wi-Fi + Cellular)";
    
    if ([hardware isEqualToString:@"i386"])         return @"Simulator";
    if ([hardware isEqualToString:@"x86_64"])       return @"Simulator";
    if ([hardware hasPrefix:@"iPhone"])             return @"iPhone";
    if ([hardware hasPrefix:@"iPod"])               return @"iPod";
    if ([hardware hasPrefix:@"iPad"])               return @"iPad";
    
    //log message that your device is not present in the list
    return nil;
}

+ (NSString *)currentModel {
    NSString *result = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        result = @"IPHONE";
    } else {
        result = @"IPAD";
    }
    
    return result;
}

+ (BOOL)runningOnSimulator {
    NSString *model = [[UIDevice currentDevice] model];
    if ([model hasSuffix:@"Simulator"]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)UUIDString {
    CFUUIDRef UUIDRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *result = CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, UUIDRef));
    CFRelease(UUIDRef);
    return result;
}

- (NSDictionary *)networkInfo {
    NSDictionary *result = nil;
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    if (interfaces) {
        CFIndex count = CFArrayGetCount(interfaces);
        if (count > 0) {
            CFDictionaryRef networkInfo = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(interfaces, 0));
            //            ELog(@"%@", networkInfo);
            if (networkInfo) {
                result = (__bridge NSDictionary *)(networkInfo);
                CFRelease(networkInfo);
            }
        }
        CFRelease(interfaces);
    }
    return result;
}

- (NSString *)SSID {
    NSString *result = [NSString string];
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    if (interfaces) {
        CFIndex count = CFArrayGetCount(interfaces);
        if (count > 0) {
            CFDictionaryRef networkInfo = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(interfaces, 0));
            //            ELog(@"%@ VS %@", networkInfo, [self networkInfo]);
            if (networkInfo) {
                NSString *SSIDValue = CFDictionaryGetValue(networkInfo, kCNNetworkInfoKeySSID);
                if (SSIDValue && SSIDValue.length > 0) {
                    result = SSIDValue;
                }
                CFRelease(networkInfo);
            }
        }
        CFRelease(interfaces);
    }
    return result;
}

@end
