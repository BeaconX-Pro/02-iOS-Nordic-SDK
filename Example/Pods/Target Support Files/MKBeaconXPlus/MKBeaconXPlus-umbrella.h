#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MKBXPApplicationModule.h"
#import "CTMediator+MKBXPAdd.h"
#import "MKBXPConnectManager.h"
#import "MKBXPDeviceTimeDataModel.h"
#import "MKBXPAccelerationController.h"
#import "MKBXPAccelerationModel.h"
#import "MKBXPAccelerationHeaderView.h"
#import "MKBXPAccelerationParamsCell.h"
#import "MKBXPExportDataController.h"
#import "MKBXPExportDataCurveView.h"
#import "MKBXPTHCurveView.h"
#import "MKBXPHTConfigController.h"
#import "MKBXPHTConfigModel.h"
#import "MKBXPStorageTriggerHTView.h"
#import "MKBXPStorageTriggerHumidityView.h"
#import "MKBXPStorageTriggerTempView.h"
#import "MKBXPStorageTriggerTimeView.h"
#import "MKBXPHTConfigHeaderView.h"
#import "MKBXPHTConfigNormalCell.h"
#import "MKBXPStorageTriggerCell.h"
#import "MKBXPSyncBeaconTimeCell.h"
#import "MKBXPLightSensorController.h"
#import "MKBXPLightSensorDataModel.h"
#import "MKBXPLightSensorButtonView.h"
#import "MKBXPLightSensorHeaderView.h"
#import "MKBXPQuickSwitchController.h"
#import "MKBXPQuickSwitchModel.h"
#import "MKBXPScanPageAdopter.h"
#import "MKBXPScanViewController.h"
#import "MKBXPScanInfoCellModel.h"
#import "MKBXPSensorConfigController.h"
#import "MKBXPSettingController.h"
#import "MKBXPDFUModel.h"
#import "MKBXPSlotConfigController.h"
#import "MKBXPSlotConfigModel.h"
#import "MKBXPSlotConfigAdvParamsCell.h"
#import "MKBXPSlotController.h"
#import "MKBXPSlotDataModel.h"
#import "MKBXPTabBarController.h"
#import "MKBXPDeviceInfoModel.h"
#import "CBPeripheral+MKBXPAdd.h"
#import "MKBXPAdopter.h"
#import "MKBXPBaseBeacon.h"
#import "MKBXPCentralManager.h"
#import "MKBXPInterface+MKBXPConfig.h"
#import "MKBXPInterface.h"
#import "MKBXPOperation.h"
#import "MKBXPOperationID.h"
#import "MKBXPPeripheral.h"
#import "MKBXPSDK.h"
#import "MKBXPService.h"
#import "MKBXPTaskAdopter.h"
#import "Target_BXP_Module.h"

FOUNDATION_EXPORT double MKBeaconXPlusVersionNumber;
FOUNDATION_EXPORT const unsigned char MKBeaconXPlusVersionString[];

