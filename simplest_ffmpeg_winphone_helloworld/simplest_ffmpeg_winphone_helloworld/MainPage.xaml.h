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

#pragma once

#include "MainPage.g.h"

namespace simplest_ffmpeg_winphone_helloworld
{
	public ref class MainPage sealed
	{
	public:
		MainPage();

		void click_protocol(Platform::Object^ sender, Windows::UI::Xaml::RoutedEventArgs^ e);
		void click_avformat(Platform::Object^ sender, Windows::UI::Xaml::RoutedEventArgs^ e);
		void click_avcodec(Platform::Object^ sender, Windows::UI::Xaml::RoutedEventArgs^ e);
		void click_avfilter(Platform::Object^ sender, Windows::UI::Xaml::RoutedEventArgs^ e);
		void click_configuration(Platform::Object^ sender, Windows::UI::Xaml::RoutedEventArgs^ e);
	};
}
