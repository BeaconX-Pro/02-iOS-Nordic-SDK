
#pragma mark - **************************  颜色相关  *********************************
/** 带有RGBA和RGB的颜色设置 */
#define RGBACOLOR(r,g,b,a)              [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBCOLOR(r,g,b)                 RGBACOLOR(r,g,b,1.0f)

/** 根据RGB16进制值获取颜色（16进制->10进制） */
#define UIColorFromRGB(rgbValue)        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/** 获取随机色 */
#define kRandomColor                    ([UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0f])

/**常用颜色**/

/**黑色*/
#define COLOR_BLACK_MARCROS             UIColorFromRGB(0x333333)
/**深黑色*/
#define COLOR_DEEPBLACK_MARCROS         UIColorFromRGB(0x000000)
/**蓝色*/
#define COLOR_BLUE_MARCROS              UIColorFromRGB(0x4790ef)
/**天蓝色*/
#define COLOR_SKYBLUE_MARCROS           UIColorFromRGB(0xf3f8fe)
/**浅蓝色*/
#define COLOR_LIGHTBLUE_MARCROS         UIColorFromRGB(0x4490ee)
/**灰色*/
#define COLOR_GRAY_MARCROS              UIColorFromRGB(0x999999)
/**浅灰色*/
#define COLOR_LIGHTGRAY_MARCROS         UIColorFromRGB(0xdddddd)
/**线的颜色，亮银灰色*/
#define COLOR_LINE_MARCROS              UIColorFromRGB(0xe5e5e5)
/**红色*/
#define COLOR_RED_MARCROS               UIColorFromRGB(0xff3400)
/**价格颜色*/
#define COLOR_LIGHTRED_MARCROS          UIColorFromRGB(0xff4200)
/**绿色*/
#define COLOR_GREEN_MARCROS             UIColorFromRGB(0x32b16c)
/**按钮颜色*/
#define BUTTON_COLOR_SURE               RGBCOLOR(75,146,236)
/**导航栏字体颜色*/
#define FONT_COLOR_BLACK                RGBCOLOR(51,51,51)        //黑色
/**白色*/
#define COLOR_WHITE_MACROS              RGBCOLOR(255,255,255)     //白色
/**白色带透明度*/
#define FONT_COLOR_WHITE(a)             RGBACOLOR(255,255,255,a)  //白色带透明度
/**透明色**/
#define COLOR_CLEAR_MACROS              FONT_COLOR_WHITE(0)



/**
 分割线颜色
 */
#define CUTTING_LINE_COLOR               RGBCOLOR(0xe8, 0xe8, 0xe8)

/**
 *  导航栏颜色
 *
 */
#define NAVBAR_COLOR_MACROS            UIColorFromRGB(0x2F84D0)

#define DEFAULT_TEXT_COLOR               UIColorFromRGB(0x353535)
