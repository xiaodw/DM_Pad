#import "DMCourseModel.h"

@implementation DMCourseModel

- (NSString *)url {
    if(_url.length) return _url;
    NSArray *image = @[
                       @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3591222702,2238709329&fm=173&s=B8946194C4C918E424B8D9020300E093&w=218&h=146&img.JPEG",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505455588157&di=c5f0ce488e7312105d9b453a3c889b4d&imgtype=0&src=http%3A%2F%2Fwww.qupu123.com%2FPublic%2FUploads%2F2016%2F09%2F17%2F13782357dc9d86c189f.png",
                      @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3591222702,2238709329&fm=173&s=B8946194C4C918E424B8D9020300E093&w=218&h=146&img.JPEG",
                      @"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=3604692245,2351986326&fm=173&s=BFB4CF04C8D00CCA0839F8DC030010E2&w=218&h=146&img.JPEG"];
    
    _url = image[arc4random_uniform(4)];
    return _url;
}

@end