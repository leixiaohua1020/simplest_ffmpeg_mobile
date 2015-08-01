/**
 * 最简单的Windows Phone平台下FFmpeg的HelloWorld例子
 * Simplest FFmpeg WinPhone HelloWorld
 *
 * 雷霄骅 Lei Xiaohua
 * leixiaohua1020@126.com
 * 中国传媒大学/数字电视技术
 * Communication University of China / Digital TV Technology
 * http://blog.csdn.net/leixiaohua1020
 * 
 * 本程序是移植FFmpeg到Windows App平台的最简单程序。它可以打印出FFmpeg类库的下列信息：
 * Protocol:  FFmpeg类库支持的协议
 * AVFormat:  FFmpeg类库支持的封装格式
 * AVCodec:   FFmpeg类库支持的编解码器
 * AVFilter:  FFmpeg类库支持的滤镜
 * Configure: FFmpeg类库的配置信息
 *
 * This is the simplest program based on FFmpeg in Windows App Platform. It can show following
 * informations about FFmpeg library:
 * Protocol:  Protocols supported by FFmpeg.
 * AVFormat:  Container format supported by FFmpeg.
 * AVCodec:   Encoder/Decoder supported by FFmpeg.
 * AVFilter:  Filters supported by FFmpeg.
 * Configure: configure information of FFmpeg.
 *
 */

#include "pch.h"
#include "MainPage.xaml.h"
#include <atlconv.h>

#define __STDC_CONSTANT_MACROS
extern "C"
{
#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
#include "libavfilter/avfilter.h"
};

using namespace simplest_ffmpeg_winphone_helloworld;

using namespace Platform;
using namespace Windows::Foundation;
using namespace Windows::Foundation::Collections;
using namespace Windows::UI::Xaml;
using namespace Windows::UI::Xaml::Controls;
using namespace Windows::UI::Xaml::Controls::Primitives;
using namespace Windows::UI::Xaml::Data;
using namespace Windows::UI::Xaml::Input;
using namespace Windows::UI::Xaml::Media;
using namespace Windows::UI::Xaml::Navigation;
using namespace Windows::UI::Popups;

MainPage::MainPage()
{
	InitializeComponent();
}

/**
* Protocol Support Information
*/
void MainPage::click_protocol(Platform::Object^ sender, Windows::UI::Xaml::RoutedEventArgs^ e){
	
	//FIX
	struct URLProtocol;

	char info[40000] = {0};
	av_register_all();

	struct URLProtocol *pup = NULL;
	//Input
	struct URLProtocol **p_temp = &pup;
	avio_enum_protocols((void **)p_temp, 0);
	while ((*p_temp) != NULL){
		sprintf_s(info, sizeof(info), "%s[In ][%10s]\n", info, avio_enum_protocols((void **)p_temp, 0));
	}
	pup = NULL;
	//Output
	avio_enum_protocols((void **)p_temp, 1);
	while ((*p_temp) != NULL){
		sprintf_s(info, sizeof(info), "%s[Out][%10s]\n", info, avio_enum_protocols((void **)p_temp, 1));
	}

	USES_CONVERSION;
	String ^infostr = ref new String(A2W(info));
	information->Text = infostr;
	
}

/**
* AVFormat Support Information
*/

void MainPage::click_avformat(Platform::Object^ sender, Windows::UI::Xaml::RoutedEventArgs^ e){
	
	char info[40000] = { 0 };

	av_register_all();

	AVInputFormat *if_temp = av_iformat_next(NULL);
	AVOutputFormat *of_temp = av_oformat_next(NULL);
	//Input
	while (if_temp != NULL){
		sprintf_s(info, sizeof(info), "%s[In ] %10s\n", info, if_temp->name);
		if_temp = if_temp->next;
	}
	//Output
	while (of_temp != NULL){
		sprintf_s(info, sizeof(info), "%s[Out] %10s\n", info, of_temp->name);
		of_temp = of_temp->next;
	}

	USES_CONVERSION;
	String ^infostr = ref new String(A2W(info));
	information->Text = infostr;
	
}

/**
* AVCodec Support Information
*/
void MainPage::click_avcodec(Platform::Object^ sender, Windows::UI::Xaml::RoutedEventArgs^ e){
	
	char info[40000] = { 0 };

	av_register_all();

	AVCodec *c_temp = av_codec_next(NULL);

	while (c_temp != NULL){
		if (c_temp->decode != NULL){
			sprintf_s(info, sizeof(info), "%s[Dec]", info);
		}
		else{
			sprintf_s(info, sizeof(info), "%s[Enc]", info);
		}
		switch (c_temp->type){
		case AVMEDIA_TYPE_VIDEO:
			sprintf_s(info, sizeof(info), "%s[Video]", info);
			break;
		case AVMEDIA_TYPE_AUDIO:
			sprintf_s(info, sizeof(info), "%s[Audio]", info);
			break;
		default:
			sprintf_s(info, sizeof(info), "%s[Other]", info);
			break;
		}

		sprintf_s(info, sizeof(info), "%s %10s\n", info, c_temp->name);

		c_temp = c_temp->next;
	}

	USES_CONVERSION;
	String ^infostr = ref new String(A2W(info));
	information->Text = infostr;
	
}

/**
* AVFilter Support Information
*/
void MainPage::click_avfilter(Platform::Object^ sender, Windows::UI::Xaml::RoutedEventArgs^ e){
	
	char info[40000] = { 0 };
	av_register_all();
	AVFilter *f_temp = (AVFilter *)avfilter_next(NULL);
	while (f_temp != NULL){
		sprintf_s(info, sizeof(info), "%s[%10s]\n", info, f_temp->name);
	}

	USES_CONVERSION;
	String ^infostr = ref new String(A2W(info));
	information->Text = infostr;
	
}

/**
* Configuration Information
*/
void MainPage::click_configuration(Platform::Object^ sender, Windows::UI::Xaml::RoutedEventArgs^ e){

	char info[10000] = { 0 };
	av_register_all();

	sprintf_s(info, sizeof(info), "%s\n", avcodec_configuration());
	
	USES_CONVERSION;
	String ^infostr = ref new String(A2W(avcodec_configuration()));
	//information->Text = infostr;
	
	MessageDialog(infostr).ShowAsync();

}

