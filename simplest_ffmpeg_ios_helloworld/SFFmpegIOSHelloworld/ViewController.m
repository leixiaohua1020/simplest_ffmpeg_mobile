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

#import "ViewController.h"
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavfilter/avfilter.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    av_register_all();
    char info[10000] = { 0 };
    printf("%s\n", avcodec_configuration());
    sprintf(info, "%s\n", avcodec_configuration());
    NSString * info_ns = [NSString stringWithFormat:@"%s", info];
    self.content.text=info_ns;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickProtocolButton:(id)sender {
    //Alert
    /*
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"Title" message:@"This is content" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alter show];
     */
    char info[40000]={0};
    av_register_all();
    
    struct URLProtocol *pup = NULL;
    //Input
    struct URLProtocol **p_temp = &pup;
    avio_enum_protocols((void **)p_temp, 0);
    while ((*p_temp) != NULL){
        sprintf(info, "%s[In ][%10s]\n", info, avio_enum_protocols((void **)p_temp, 0));
    }
    pup = NULL;
    //Output
    avio_enum_protocols((void **)p_temp, 1);
    while ((*p_temp) != NULL){
        sprintf(info, "%s[Out][%10s]\n", info, avio_enum_protocols((void **)p_temp, 1));
    }
    //printf("%s", info);
    NSString * info_ns = [NSString stringWithFormat:@"%s", info];
    self.content.text=info_ns;
}

- (IBAction)clickAVFormatButton:(id)sender {
    char info[40000] = { 0 };
    
    av_register_all();
    
    AVInputFormat *if_temp = av_iformat_next(NULL);
    AVOutputFormat *of_temp = av_oformat_next(NULL);
    //Input
    while(if_temp!=NULL){
        sprintf(info, "%s[In ]%10s\n", info, if_temp->name);
        if_temp=if_temp->next;
    }
    //Output
    while (of_temp != NULL){
        sprintf(info, "%s[Out]%10s\n", info, of_temp->name);
        of_temp = of_temp->next;
    }
    //printf("%s", info);
    NSString * info_ns = [NSString stringWithFormat:@"%s", info];
    self.content.text=info_ns;
}


- (IBAction)clickAVCodecButton:(id)sender {
    
    char info[40000] = { 0 };
    
    av_register_all();
    
    AVCodec *c_temp = av_codec_next(NULL);
    
    while(c_temp!=NULL){
        if (c_temp->decode!=NULL){
            sprintf(info, "%s[Dec]", info);
        }
        else{
            sprintf(info, "%s[Enc]", info);
        }
        switch (c_temp->type){
            case AVMEDIA_TYPE_VIDEO:
                sprintf(info, "%s[Video]", info);
                break;
            case AVMEDIA_TYPE_AUDIO:
                sprintf(info, "%s[Audio]", info);
                break;
            default:
                sprintf(info, "%s[Other]", info);
                break;
        }
        sprintf(info, "%s%10s\n", info, c_temp->name);
        
        
        c_temp=c_temp->next;
    }
    //printf("%s", info);
    NSString * info_ns = [NSString stringWithFormat:@"%s", info];
    self.content.text=info_ns;
}

- (IBAction)clickAVFilterButton:(id)sender {
    char info[40000] = { 0 };
    avfilter_register_all();
    AVFilter *f_temp = (AVFilter *)avfilter_next(NULL);
    while (f_temp != NULL){
        sprintf(info, "%s[%10s]\n", info, f_temp->name);
    }
    //printf("%s", info);
    NSString * info_ns = [NSString stringWithFormat:@"%s", info];
    self.content.text=info_ns;
}

- (IBAction)clickConfigurationButton:(id)sender {
    char info[10000] = { 0 };
    av_register_all();
    
    sprintf(info, "%s\n", avcodec_configuration());
    
    //printf("%s", info);
    //self.content.text=@"Lei Xiaohua";
    NSString * info_ns = [NSString stringWithFormat:@"%s", info];
    self.content.text=info_ns;
}


@end
