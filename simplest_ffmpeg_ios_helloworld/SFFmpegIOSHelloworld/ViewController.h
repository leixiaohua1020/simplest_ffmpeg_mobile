/**
 * 最简单的基于FFmpeg的HelloWorld程序 － IOS
 * Simplest FFmpeg Helloworld － IOS
 *
 * 雷霄骅 Lei Xiaohua
 * leixiaohua1020@126.com
 * 中国传媒大学/数字电视技术
 * Communication University of China / Digital TV Technology
 * http://blog.csdn.net/leixiaohua1020
 *
 * 本程序可以获得FFmpeg类库相关的信息。
 * This software can get information about FFmpeg libraries.
 *
 */

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UILabel *content;

- (IBAction)clickProtocolButton:(id)sender;

- (IBAction)clickAVFormatButton:(id)sender;

- (IBAction)clickAVCodecButton:(id)sender;

- (IBAction)clickAVFilterButton:(id)sender;

- (IBAction)clickConfigurationButton:(id)sender;

@end

