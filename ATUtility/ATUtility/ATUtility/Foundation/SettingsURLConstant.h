//
//  UIApplication+Settings.h
//  ATUtility
//
//  Created by arvin.tan on 5/16/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import <UIKit/UIKit.h>

// Ref: https://gist.github.com/phynet/471089a51b8f940f0fb4

// Attention: To use these Settings URL, you must set prefs in "target => info => URL Types"
// Example: [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Keyboard"]];

//prefs:	The topmost level General
FOUNDATION_EXTERN NSString *const RootSettingsURLString;
//prefs:root=General&path=About	About
FOUNDATION_EXTERN NSString *const AboutSettingsURLString;
//prefs:root=General&path=ACCESSIBILITY	Accessibility
FOUNDATION_EXTERN NSString *const AccessibilitySettingsURLStringGeneral;
//prefs:root=ACCOUNT_SETTINGS	Account Settings
FOUNDATION_EXTERN NSString *const AccountSettingsURLString;
//prefs:root=AIRPLANE_MODE	Airplane Mode
FOUNDATION_EXTERN NSString *const AirplaneModeSettingsURLString;
//prefs:root=General&path=AUTOLOCK	Autolock
FOUNDATION_EXTERN NSString *const AutolockSettingsURLString;
//prefs:root=Brightness	Brightness
FOUNDATION_EXTERN NSString *const BrightnessSettingsURLString;
//prefs:root=General&path=Bluetooth	Bluetooth iOS < 9
//prefs:root=Bluetooth	Bluetooth iOS > 9
FOUNDATION_EXTERN NSString *const BluetoothSettingsURLString;
//prefs:root=CASTLE	Castle
FOUNDATION_EXTERN NSString *const CastleSettingsURLString;
//prefs:root=General&path=USAGE/CELLULAR_USAGE	Cellular Usage
FOUNDATION_EXTERN NSString *const CellularUsageSettingsURLString;
//prefs:root=General&path=ManagedConfigurationList	Configuration List
FOUNDATION_EXTERN NSString *const ConfigurationListSettingsURLString;
//prefs:root=General&path=DATE_AND_TIME	Date and Time
FOUNDATION_EXTERN NSString *const DateAndTimeSettingsURLString;
//prefs:root=FACETIME	Facetime
FOUNDATION_EXTERN NSString *const FacetimeSettingsURLString;
//prefs:root=General	General
FOUNDATION_EXTERN NSString *const GeneralSettingsURLString;
//prefs:root=INTERNET_TETHERING	Internet Tethering
FOUNDATION_EXTERN NSString *const InternetTetheringSettingsURLString;
//prefs:root=MUSIC	iTunes
FOUNDATION_EXTERN NSString *const iTunesSettingsURLString;
//prefs:root=MUSIC&path=EQ	iTunes Equalizer
FOUNDATION_EXTERN NSString *const iTunesEqualizerSettingsURLString;
//prefs:root=MUSIC&path=VolumeLimit	iTunes Volume
FOUNDATION_EXTERN NSString *const iTunesVolumeSettingsURLString;
//prefs:root=General&path=Keyboard	Keyboard
FOUNDATION_EXTERN NSString *const KeyboardSettingsURLString;
//prefs:root=General&path=INTERNATIONAL	Lang International
FOUNDATION_EXTERN NSString *const LanguageInternationalSettingsURLString;
//prefs:root=LOCATION_SERVICES	Location Services
FOUNDATION_EXTERN NSString *const LocationServicesSettingsURLString;
//prefs:root=General&path=Network	Network
FOUNDATION_EXTERN NSString *const NetworkSettingsURLString;
//prefs:root=NIKE_PLUS_IPOD	Nike iPod
FOUNDATION_EXTERN NSString *const NikeiPodSettingsURLString;
//prefs:root=NOTES	Notes
FOUNDATION_EXTERN NSString *const NotesSettingsURLString;
//prefs:root=NOTIFICATIONS_ID	Notifications ID
FOUNDATION_EXTERN NSString *const NotificationsIDSettingsURLString;
//prefs:root=PASSBOOK	Passbook
FOUNDATION_EXTERN NSString *const PassbookSettingsURLString;
//prefs:root=Phone	Phone
FOUNDATION_EXTERN NSString *const PhoneSettingsURLString;
//prefs:root=Photos	Photo Camera Roll
FOUNDATION_EXTERN NSString *const PhotoCameraRollSettingsURLString;
//prefs:root=General&path=Reset	Reset
FOUNDATION_EXTERN NSString *const ResetSettingsURLString;
//prefs:root=Sounds&path=Ringtone	Ringtone
FOUNDATION_EXTERN NSString *const RingtoneSettingsURLString;
//prefs:root=Safari	Safari
FOUNDATION_EXTERN NSString *const SafariSettingsURLString;
//prefs:root=General&path=Assistant	Siri
FOUNDATION_EXTERN NSString *const SiriSettingsURLString;
//prefs:root=Sounds	Sounds
FOUNDATION_EXTERN NSString *const SoundsSettingsURLString;
//prefs:root=General&path=SOFTWARE_UPDATE_LINK	Software Update
FOUNDATION_EXTERN NSString *const SoftwareUpdateSettingsURLString;
//prefs:root=CASTLE&path=STORAGE_AND_BACKUP	Storage & Backup
FOUNDATION_EXTERN NSString *const StorageBackupSettingsURLString;
//prefs:root=STORE	Store
FOUNDATION_EXTERN NSString *const StoreSettingsURLString;
//prefs:root=TWITTER	Twitter
FOUNDATION_EXTERN NSString *const TwitterSettingsURLString;
//prefs:root=General&path=USAGE	Usage
FOUNDATION_EXTERN NSString *const UsageSettingsURLString;
//prefs:root=VIDEO	Video
FOUNDATION_EXTERN NSString *const VideoSettingsURLString;
//prefs:root=General&path=Network/VPN	VPN
FOUNDATION_EXTERN NSString *const VPUSettingsURLString;
//prefs:root=Wallpaper	Wallpaper
FOUNDATION_EXTERN NSString *const WallpaperSettingsURLString;
//prefs:root=WIFI	WIFI
FOUNDATION_EXTERN NSString *const WiFiSettignsURLString;
