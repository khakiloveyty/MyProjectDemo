#import <UIKit/UIKit.h>

//帖子类型枚举
typedef enum{
    JPAllTopic=1,          //全部
    JPVideoTopic=41,       //视频
    JPVoiceTopic=31,       //声音
    JPPictureTopic=10,     //图片
    JPWordTopic=29         //段子
} JPTopicType;


/** 用户头像的占位图片 */
UIKIT_EXTERN NSString *const JPDefaultUserIcon;

/** 精华-顶部标签栏的高度 */
UIKIT_EXTERN CGFloat const JPTitlesViewHeight;

/** 精华-顶部标签栏的Y值 */
UIKIT_EXTERN CGFloat const JPTitlesViewY;

/** 帖子cell的各控件之间的边距 */
UIKIT_EXTERN CGFloat const JPTopicCellMargin;

/** 精华-帖子cell的文字label的Y值 */
UIKIT_EXTERN CGFloat const JPTopicCellTextY;

/** 精华-帖子cell的底部工具条的高度 */
UIKIT_EXTERN CGFloat const JPTopicCellBottomBarHeight;

/** 精华-帖子cell-图片的最大高度 */
UIKIT_EXTERN CGFloat const JPTopicCellPictureMaxHeight;

/** 精华-帖子cell-图片的指定高度（图片超过最大高度时使用） */
UIKIT_EXTERN CGFloat const JPTopicCellPictureOrdinaryHeight;

/** JPUser-性别-男 */
UIKIT_EXTERN NSString *const JPUserSexMan;

/** JPUser-性别-女 */
UIKIT_EXTERN NSString *const JPUserSexWoman;

/** 精华-帖子cell-热门评论标题的高度 */
UIKIT_EXTERN CGFloat const JPTopicCellHotCommentTitleHeight;

/** 精华-帖子cell-热门评论内容内边距 */
UIKIT_EXTERN CGFloat const JPTopicCellHotCommentContentMargin;