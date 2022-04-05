//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  TikTokReverseDylib.m
//  TikTokReverseDylib
//
//  Created by iceman on 2022/4/3.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

#import "TikTokReverseDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import <MDCycriptManager.h>

CHConstructor{
    printf(INSERT_SUCCESS_WELCOME);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
#ifndef __OPTIMIZE__
        CYListenServer(6666);

        MDCycriptManager* manager = [MDCycriptManager sharedInstance];
        [manager loadCycript:NO];

        NSError* error;
        NSString* result = [manager evaluateCycript:@"UIApp" error:&error];
        NSLog(@"result: %@", result);
        if(error.code != 0){
            NSLog(@"error: %@", error.localizedDescription);
        }
#endif
        
    }];
}


CHDeclareClass(CustomViewController)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

//add new method
CHDeclareMethod1(void, CustomViewController, newMethod, NSString*, output){
    NSLog(@"This is a new method : %@", output);
}

#pragma clang diagnostic pop

CHOptimizedClassMethod0(self, void, CustomViewController, classMethod){
    NSLog(@"hook class method");
    CHSuper0(CustomViewController, classMethod);
}

CHOptimizedMethod0(self, NSString*, CustomViewController, getMyName){
    //get origin value
    NSString* originName = CHSuper(0, CustomViewController, getMyName);
    
    NSLog(@"origin name is:%@",originName);
    
    //get property
    NSString* password = CHIvar(self,_password,__strong NSString*);
    
    NSLog(@"password is %@",password);
    
    [self newMethod:@"output"];
    
    //set new property
    self.newProperty = @"newProperty";
    
    NSLog(@"newProperty : %@", self.newProperty);
    
    //change the value
    return @"iceman";
    
}

//add new property
CHPropertyRetainNonatomic(CustomViewController, NSString*, newProperty, setNewProperty);

CHConstructor{
    CHLoadLateClass(CustomViewController);
    CHClassHook0(CustomViewController, getMyName);
    CHClassHook0(CustomViewController, classMethod);
    
    CHHook0(CustomViewController, newProperty);
    CHHook1(CustomViewController, setNewProperty);
}

//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  AYTikTokPod.m
//  AYTikTokPod
//
//  Created by AiJe on 2018/12/18.
//  Copyright (c) 2018 AYJk. All rights reserved.
//

#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#define HOOK_MENU_TITLE @"🎉TikTok🎉小插件"
#define HookInitAreaValue @{@"area": @"日本🇯🇵", @"code": @"JP", @"mcc": @"440", @"mnc": @"01"}


@interface AWEHookSettingViewController : UIViewController

@end


@interface AWESettingSectionModel

@property(copy, nonatomic) NSString *sectionFooterTitle; // @synthesize sectionFooterTitle=_sectionFooterTitle;
@property(retain, nonatomic) NSArray *itemArray; // @synthesize itemArray=_itemArray;
@property(nonatomic) double sectionHeaderHeight; // @synthesize sectionHeaderHeight=_sectionHeaderHeight;
@property(copy, nonatomic) NSString *sectionHeaderTitle; // @synthesize sectionHeaderTitle=_sectionHeaderTitle;
@property(nonatomic) long long type; // @synthesize type=_type;

@end


@interface AWESettingItemModel: NSObject

@property(copy, nonatomic) id cellRefreshBlock; // @synthesize cellRefreshBlock=_cellRefreshBlock;
@property(copy, nonatomic) id switchChangedBlock; // @synthesize switchChangedBlock=_switchChangedBlock;
@property(copy, nonatomic) void(^cellTappedBlock)(void); // @synthesize cellTappedBlock=_cellTappedBlock;
@property(nonatomic) double cellHeight; // @synthesize cellHeight=_cellHeight;
@property(nonatomic) long long dotType; // @synthesize dotType=_dotType;
@property(nonatomic) _Bool showDotView; // @synthesize showDotView=_showDotView;
@property(nonatomic) _Bool isEnable; // @synthesize isEnable=_isEnable;
@property(nonatomic) _Bool isSwitchOn; // @synthesize isSwitchOn=_isSwitchOn;
@property(nonatomic) long long cellType; // @synthesize cellType=_cellType;
@property(copy, nonatomic) NSString *iconImageName; // @synthesize iconImageName=_iconImageName;
@property(copy, nonatomic) NSString *detail; // @synthesize detail=_detail;
@property(copy, nonatomic) NSString *fancySubtitle; // @synthesize fancySubtitle=_fancySubtitle;
@property(copy, nonatomic) NSString *subTitle; // @synthesize subTitle=_subTitle;
@property(copy, nonatomic) NSString *title; // @synthesize title=_title;
@property(nonatomic) long long type; // @synthesize type=_type;

@end

@interface AWESettingsViewModel

@property (nonatomic, copy) NSString *isHooked;

@end

@interface AWEURLModel

@property(retain, nonatomic) NSArray *originURLList;

@end

@interface AWEVideoModel

@property(readonly, nonatomic) AWEURLModel *playURL;
@property(readonly, nonatomic) AWEURLModel *downloadURL;

@end

@interface AWEAwemeModel

@property(nonatomic, assign) BOOL preventDownload;
@property(retain, nonatomic) AWEVideoModel *video;

@end

CHConstructor{
    NSDictionary *areaDic = [UserDefaults valueForKey:HookArea];
    if (areaDic == nil) {
        [UserDefaults setValue:HookInitAreaValue forKey:HookArea];
        [UserDefaults setBool:NO forKey:HookDownLoad];
        [UserDefaults setBool:NO forKey:HookWaterMark];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
#pragma GCC diagnostic ignored "-Wundeclared-selector"

// MARK: - Hook CTCarrier
CHDeclareClass(CTCarrier)

CHMethod0(NSString *, CTCarrier, isoCountryCode) {
    NSDictionary *areaDic = [UserDefaults valueForKey:HookArea];
    NSString *code = [areaDic objectForKey:@"code"];
    return code;
}

CHMethod0(NSString *, CTCarrier, mobileCountryCode) {
    NSDictionary *areaDic = [UserDefaults valueForKey:HookArea];
    NSString *mcc = [areaDic objectForKey:@"mcc"];
    return mcc;
}

CHMethod0(NSString *, CTCarrier, mobileNetworkCode) {
    NSDictionary *areaDic = [UserDefaults valueForKey:HookArea];
    NSString *mnc = [areaDic objectForKey:@"mnc"];
    return mnc;
}

CHConstructor {
    CHLoadLateClass(CTCarrier);
    CHHook0(CTCarrier, isoCountryCode);
    CHHook0(CTCarrier, mobileCountryCode);
    CHHook0(CTCarrier, mobileNetworkCode);
}

// MARK: - Setting界面
CHDeclareClass(AWESettingsTableViewController)
CHDeclareClass(AWESettingsViewModel)

CHPropertyAssign(AWESettingsViewModel, NSString *, isHooked, setIsHooked);

CHMethod0(NSArray *, AWESettingsViewModel, sectionDataArray) {
    NSMutableArray *hookSettings = [CHSuper0(AWESettingsViewModel, sectionDataArray) mutableCopy];
    if (![self.isHooked isEqualToString:@"YES"]) {
        AWESettingSectionModel *firstSectionModle = hookSettings.firstObject;
        NSMutableArray *items = [firstSectionModle.itemArray mutableCopy];
        AWESettingItemModel *hookItem = [objc_getClass("AWESettingItemModel") new];
        hookItem.type = -1;
        hookItem.title = HOOK_MENU_TITLE;
        hookItem.iconImageName = @"awe-settings-icon-safety-center";
        hookItem.cellType = 2;
        hookItem.cellTappedBlock = ^(void) {
            dispatch_async(dispatch_get_main_queue(), ^{
                AWEHookSettingViewController *settingVc = [[AWEHookSettingViewController alloc] init];
                UIViewController *tabbarVc = UIApplication.sharedApplication.keyWindow.rootViewController;
                UINavigationController *hookNavi = [[UINavigationController alloc] initWithRootViewController:settingVc];
                [tabbarVc presentViewController:hookNavi animated:YES completion:nil];
            });
        };
        [items insertObject:hookItem atIndex:0];
        firstSectionModle.itemArray = [items copy];
        self.isHooked = @"YES";
    }
    return [hookSettings copy];
}

CHConstructor {
    CHLoadLateClass(AWESettingsTableViewController);
    CHLoadLateClass(AWESettingsViewModel);
    CHHook0(AWESettingsViewModel, sectionDataArray);
    CHHook0(AWESettingsViewModel, isHooked);
    CHHook1(AWESettingsViewModel, setIsHooked);
}

// MARK: - AWEAwemeModel
CHDeclareClass(AWEShareServiceUtils)
CHDeclareClass(AWEAwemeModel)

CHMethod1(void, AWEAwemeModel, setPreventDownload, BOOL, arg1) {
    arg1 = ![UserDefaults boolForKey:HookDownLoad];
    CHSuper1(AWEAwemeModel, setPreventDownload, arg1);
}

CHMethod1(void, AWEAwemeModel, setVideo, AWEVideoModel *, arg1) {
    BOOL isHookDownLoad = [UserDefaults boolForKey:HookDownLoad];
    if (isHookDownLoad) {
        arg1.downloadURL.originURLList = arg1.playURL.originURLList;
    }
    CHSuper1(AWEAwemeModel, setVideo, arg1);
}

CHConstructor {
    CHLoadLateClass(AWEAwemeModel);
    CHLoadLateClass(AWEShareServiceUtils);
    CHHook1(AWEAwemeModel, setPreventDownload);
    CHHook1(AWEAwemeModel, setVideo);
}

CHDeclareClass(AWEVideoModel)
CHMethod0(AWEURLModel *,AWEVideoModel,playURL){
    AWEURLModel *tempPlayUrl =  CHSuper0(AWEVideoModel, playURL);
    return tempPlayUrl;
}

// MARK: - WaterMark
CHDeclareClass(AWEDynamicWaterMarkExporter)

CHOptimizedClassMethod0(self, NSArray *, AWEDynamicWaterMarkExporter, watermarkLogoImageArray) {
    BOOL isHookWaterMark = [UserDefaults boolForKey:HookWaterMark];
    if (isHookWaterMark) {
        return @[];
    }
    return CHSuper0(AWEDynamicWaterMarkExporter, watermarkLogoImageArray);
}

CHConstructor {
    CHLoadLateClass(AWEDynamicWaterMarkExporter);
    CHClassHook0(AWEDynamicWaterMarkExporter, watermarkLogoImageArray);
}


@interface AWEHookSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray<NSDictionary *>* areaLists;
@property (nonatomic, copy) NSArray *normalSettingTitle;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) BOOL isHookWaterMark;
@property (nonatomic, assign) BOOL isHookDownLoad;
@end

@implementation AWEHookSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:22 / 255.0 green:24 / 255.0 blue:35 / 255.0 alpha:1];
    self.title = @"🎉TikTok🎉小插件";
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *resourcePath = [bundle pathForResource:@"AYTikTokPod" ofType:@"bundle"];
    bundle = [NSBundle bundleWithPath:resourcePath];
    NSString *plistFile = [bundle pathForResource:@"countryCode" ofType:@"plist"];
    self.areaLists = [NSArray arrayWithContentsOfFile:plistFile];
    self.normalSettingTitle = @[@"移除下载限制", @"移除水印"];
    self.isHookDownLoad = [UserDefaults boolForKey:HookDownLoad];
    self.isHookWaterMark = [UserDefaults boolForKey:HookWaterMark];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, self.view.bounds.size.width - 30, 140)];
    infoLabel.numberOfLines = 0;
    infoLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:15.0];
    infoLabel.textColor = [UIColor lightGrayColor];
    infoLabel.text = @"Author: @AYJk\nVersion: 1.2.0\nInfo: Have Fun🤣";
    infoLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:infoLabel];
    
    UITableView *areaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    [self.view addSubview:areaTableView];
    [areaTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"areaCell"];
    [areaTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"normalSettingCell"];
    areaTableView.delegate = self;
    areaTableView.dataSource = self;
    areaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    areaTableView.tableFooterView = footerView;
    areaTableView.backgroundColor = [UIColor colorWithRed:22 / 255.0 green:24 / 255.0 blue:35 / 255.0 alpha:1];
    NSDictionary *areaDic = [UserDefaults valueForKey:HookArea];
    NSString *code = [areaDic objectForKey:@"code"];
    for (NSInteger index = 0; index < self.areaLists.count; index ++) {
        NSDictionary *dataDic = self.areaLists[index];
        if ([code isEqualToString:dataDic[@"code"]]) {
            self.selectedRow = index;
            break;
        }
    }
    [self configNaviItem];
}

- (void)configNaviItem {
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [saveButton setTitle:@"完成" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitleColor:[UIColor colorWithRed:254 / 255.0 green:44 / 255.0 blue:85 / 255.0 alpha:1] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:17.0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor colorWithRed:254 / 255.0 green:44 / 255.0 blue:85 / 255.0 alpha:1] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:17.0];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
}

- (void)saveAction {
    [UserDefaults setBool:self.isHookDownLoad forKey:HookDownLoad];
    [UserDefaults setBool:self.isHookWaterMark forKey:HookWaterMark];
    NSDictionary *areaDic = [UserDefaults objectForKey:HookArea];
    if (![areaDic isEqualToDictionary:self.areaLists[self.selectedRow]]) {
        [UserDefaults setObject:self.areaLists[self.selectedRow] forKey:HookArea];
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"世界线已经发生变动！👹\n这一切都是命运石之门的选择！\n少年！加油吧！\n请重新打开TikTok开启冒险🎉" preferredStyle:UIAlertControllerStyleAlert];
        [alertCon addAction:[UIAlertAction actionWithTitle:@"El Psy Congroo" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            exit(0);
        }]];
        [self presentViewController:alertCon animated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)cancelAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)switchAction:(UISwitch *)sender {
    if (sender.tag == 1000) {
        self.isHookDownLoad = sender.isOn;
    } else if (sender.tag == 1001) {
        self.isHookWaterMark = sender.isOn;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalSettingCell" forIndexPath:indexPath];
        for (UIView *tempView in cell.contentView.subviews) {
            if ([tempView isMemberOfClass:[UISwitch class]]) {
                [tempView removeFromSuperview];
                break;
            }
        }
        UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 16 - 51, 4, 51, 31)];
        mySwitch.tag = 1000 + indexPath.row;
        [mySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:mySwitch];
        cell.textLabel.text = self.normalSettingTitle[indexPath.row];
        cell.backgroundColor = self.view.backgroundColor;
        cell.textLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:15.0];
        if (indexPath.row == 0) {
            mySwitch.on = self.isHookDownLoad;
        } else if (indexPath.row == 1) {
            mySwitch.on = self.isHookWaterMark;
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"areaCell" forIndexPath:indexPath];
        NSDictionary *dataDic = self.areaLists[indexPath.row];
        cell.textLabel.text = dataDic[@"area"];
        cell.backgroundColor = self.view.backgroundColor;
        cell.textLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:15.0];
        cell.tintColor = [UIColor colorWithRed:254 / 255.0 green:44 / 255.0 blue:85 / 255.0 alpha:1];
        if (self.selectedRow == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    headerView.backgroundColor = [UIColor colorWithRed:22 / 255.0 green:24 / 255.0 blue:35 / 255.0 alpha:1];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, 40)];
    [headerView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:13.0];
    titleLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.34];
    if (section == 0) {
        titleLabel.text = @"一般配置";
    } else if (section == 1) {
        titleLabel.text = @"国家/地区切换";
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.normalSettingTitle.count;
    } else {
        return self.areaLists.count;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//
//    return footerView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        self.selectedRow = indexPath.row;
        [tableView reloadData];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

CHDeclareClass(UIViewController)

CHMethod2(void, UIViewController, motionEnded, UIEventSubtype, motion, withEvent, UIEvent *, event) {

    CHSuper2(UIViewController, motionEnded, motion, withEvent, event);

    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        AWEHookSettingViewController *settingVc = [[AWEHookSettingViewController alloc] init];
        UIViewController *tabbarVc = UIApplication.sharedApplication.keyWindow.rootViewController;
        UINavigationController *hookNavi = [[UINavigationController alloc] initWithRootViewController:settingVc];
        [tabbarVc presentViewController:hookNavi animated:YES completion:nil];
    }
}

CHConstructor {
    CHLoadLateClass(UIViewController);
    CHClassHook2(UIViewController, motionEnded, withEvent);
}
