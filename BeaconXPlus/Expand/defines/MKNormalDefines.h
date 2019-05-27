
//图片的宏定义
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@",file,(iPhone6Plus || iPhoneX || iPhoneMax) ? @"@3x" : @"@2x"] ofType:ext]]
