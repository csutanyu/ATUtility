//
//  UIApplication+Settings.m
//  ATUtility
//
//  Created by arvin.tan on 5/16/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import "SettingsURLConstant.h"


//prefs:	The topmost level General
NSString *const RootSettingsURLString = @"prefs:";
//prefs:root=General&path=About	About
NSString *const AboutSettingsURLString = @"prefs:root=General&path=About";
//prefs:root=General&path=ACCESSIBILITY	Accessibility
NSString *const AccessibilitySettingsURLStringGeneral = @"prefs:root=General&path=ACCESSIBILITY";
//prefs:root=ACCOUNT_SETTINGS	Account Settings
NSString *const AccountSettingsURLString = @"prefs:root=ACCOUNT_SETTINGS";
//prefs:root=AIRPLANE_MODE	Airplane Mode
NSString *const AirplaneModeSettingsURLString = @"prefs:root=AIRPLANE_MODE";
//prefs:root=General&path=AUTOLOCK	Autolock
NSString *const AutolockSettingsURLString = @"prefs:root=General&path=AUTOLOCK";
//prefs:root=Brightness	Brightness
NSString *const BrightnessSettingsURLString = @"prefs:root=Brightness";
//prefs:root=General&path=Bluetooth	Bluetooth iOS < 9
//prefs:root=Bluetooth	Bluetooth iOS > 9
#ifdef __IPHONE_9_0
NSString *const BluetoothSettingsURLString = @"prefs:root=Bluetooth";
#else
NSString *const BluetoothSettingsURLString = @"prefs:root=General&path=Bluetooth";
#endif
//prefs:root=CASTLE	Castle
NSString *const CastleSettingsURLString = @"prefs:root=CASTLE";
//prefs:root=General&path=USAGE/CELLULAR_USAGE	Cellular Usage
NSString *const CellularUsageSettingsURLString = @"prefs:root=General&path=USAGE/CELLULAR_USAGE";
//prefs:root=General&path=ManagedConfigurationList	Configuration List
NSString *const ConfigurationListSettingsURLString = @"prefs:root=General&path=ManagedConfigurationList";
//prefs:root=General&path=DATE_AND_TIME	Date and Time
NSString *const DateAndTimeSettingsURLString = @"prefs:root=General&path=DATE_AND_TIME";
//prefs:root=FACETIME	Facetime
NSString *const FacetimeSettingsURLString = @"prefs:root=FACETIME";
//prefs:root=General	General
NSString *const GeneralSettingsURLString = @"prefs:root=General";
//prefs:root=INTERNET_TETHERING	Internet Tethering
NSString *const InternetTetheringSettingsURLString = @"prefs:root=INTERNET_TETHERING";
//prefs:root=MUSIC	iTunes
NSString *const iTunesSettingsURLString = @"prefs:root=MUSIC";
//prefs:root=MUSIC&path=EQ	iTunes Equalizer
NSString *const iTunesEqualizerSettingsURLString = @"prefs:root=MUSIC&path=EQ";
//prefs:root=MUSIC&path=VolumeLimit	iTunes Volume
NSString *const iTunesVolumeSettingsURLString = @"prefs:root=MUSIC&path=VolumeLimit";
//prefs:root=General&path=Keyboard	Keyboard
NSString *const KeyboardSettingsURLString = @"prefs:root=General&path=Keyboard";
//prefs:root=General&path=INTERNATIONAL	Lang International
NSString *const LanguageInternationalSettingsURLString = @"prefs:root=General&path=INTERNATIONAL";
//prefs:root=LOCATION_SERVICES	Location Services
NSString *const LocationServicesSettingsURLString = @"prefs:root=LOCATION_SERVICES";
//prefs:root=General&path=Network	Network
NSString *const NetworkSettingsURLString = @"prefs:root=General&path=Network";
//prefs:root=NIKE_PLUS_IPOD	Nike iPod
NSString *const NikeiPodSettingsURLString = @"prefs:root=NIKE_PLUS_IPOD";
//prefs:root=NOTES	Notes
NSString *const NotesSettingsURLString = @"prefs:root=NOTES";
//prefs:root=NOTIFICATIONS_ID	Notifications ID
NSString *const NotificationsIDSettingsURLString = @"prefs:root=NOTIFICATIONS_ID";
//prefs:root=PASSBOOK	Passbook
NSString *const PassbookSettingsURLString = @"prefs:root=PASSBOOK";
//prefs:root=Phone	Phone
NSString *const PhoneSettingsURLString = @"prefs:root=Phone";
//prefs:root=Photos	Photo Camera Roll
NSString *const PhotoCameraRollSettingsURLString = @"prefs:root=Photos";
//prefs:root=General&path=Reset	Reset
NSString *const ResetSettingsURLString = @"prefs:root=General&path=Reset";
//prefs:root=Sounds&path=Ringtone	Ringtone
NSString *const RingtoneSettingsURLString = @"prefs:root=Sounds&path=Ringtone";
//prefs:root=Safari	Safari
NSString *const SafariSettingsURLString = @"Safari";
//prefs:root=General&path=Assistant	Siri
NSString *const SiriSettingsURLString = @"prefs:root=General&path=Assistant";
//prefs:root=Sounds	Sounds
NSString *const SoundsSettingsURLString = @"prefs:root=Sounds";
//prefs:root=General&path=SOFTWARE_UPDATE_LINK	Software Update
NSString *const SoftwareUpdateSettingsURLString = @"prefs:root=General&path=SOFTWARE_UPDATE_LINK";
//prefs:root=CASTLE&path=STORAGE_AND_BACKUP	Storage & Backup
NSString *const StorageBackupSettingsURLString = @"prefs:root=CASTLE&path=STORAGE_AND_BACKUP";
//prefs:root=STORE	Store
NSString *const StoreSettingsURLString = @"prefs:root=STORE";
//prefs:root=TWITTER	Twitter
NSString *const TwitterSettingsURLString = @"prefs:root=TWITTER";
//prefs:root=General&path=USAGE	Usage
NSString *const UsageSettingsURLString = @"prefs:root=General&path=USAGE";
//prefs:root=VIDEO	Video
NSString *const VideoSettingsURLString = @"prefs:root=VIDEO";
//prefs:root=General&path=Network/VPN	VPN
NSString *const VPUSettingsURLString = @"prefs:root=General&path=Network/VPN";
//prefs:root=Wallpaper	Wallpaper
NSString *const WallpaperSettingsURLString = @"prefs:root=Wallpaper";
//prefs:root=WIFI	WIFI
NSString *const WiFiSettignsURLString = @"prefs:root=WIFI";

@implementation UIApplication (Settings)

@end
