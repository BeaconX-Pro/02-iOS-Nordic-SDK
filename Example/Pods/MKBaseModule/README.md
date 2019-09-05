baseModule 基础控件库
常用分类方法定义,如果需要自定义导航栏左侧返回按钮，则
#import "UINavigationController+MKCategoryModule.h"
self.UINavigationController.leftItemIcon = 自定义的icon即可。这样的设置会对该导航栏下面所有的vc生效


如果是想自定义某一个vc的左侧返回按钮，则操作self.leftButton即可


