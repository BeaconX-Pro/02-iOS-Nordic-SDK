//
//  MTPublicHeader.h
//  MTBeaconPlus
//
//  Created by SACRELEE on 9/21/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, FrameType) {
    FrameNone = -3,
    FrameConnectable = -2,
    FrameUnknown = -1,
    FrameTLM = 0,
    FrameHTSensor,
    FrameAccSensor,
    FrameLightSensor,
    FrameQlock,
    FrameDFU,
    FrameRoambee,
    FrameForceSensor,
    FramePIRSensor,
    FrameTVOCSensor,
    FrameTempSensor,
    FrameLineBeacon,
    FrameSixAxisSensor, // 六轴传感器
    FrameMagnetometerSensor, // 磁力计传感器
    FrameAtmosphericPressureSensor, // 大气压力传感器数据

    //staticFrame
    FrameUID = 100,
    FrameiBeacon,
    FrameURL,
    FrameDeviceInfo,
};


static NSString *FrameTypeString(FrameType type) {
    switch (type) {
        case FrameNone:
            return @"FrameNone";
        case FrameConnectable:
            return @"FrameConnectable";
        case FrameUnknown:
            return @"FrameUnknown";
        case FrameTLM:
            return @"FrameTLM";
        case FrameHTSensor:
            return @"FrameHTSensor";
        case FrameAccSensor:
            return @"FrameAccSensor";
        case FrameLightSensor:
            return @"FrameLightSensor";
        case FrameQlock:
            return @"FrameQlock";
        case FrameDFU:
            return @"FrameDFU";
        case FrameRoambee:
            return @"FrameRoambee";
        case FrameForceSensor:
            return @"FrameForceSensor";
        case FramePIRSensor:
            return @"FramePIRSensor";
        case FrameTVOCSensor:
            return @"FrameTVOCSensor";
        case FrameTempSensor:
            return @"FrameTempSensor";
        case FrameLineBeacon:
            return @"FrameLineBeacon";
        case FrameUID:
            return @"FrameUID";
        case FrameiBeacon:
            return @"FrameiBeacon";
        case FrameURL:
            return @"FrameURL";
        case FrameDeviceInfo:
            return @"FrameDeviceInfo";
        default:
            return @"";
    }
}


#define MTNAValue 10000000000.0
