/**
 * 最简单的基于FFmpeg的视频编码器
 * Simplest FFmpeg Android Encoder
 *
 * 雷霄骅 Lei Xiaohua
 * leixiaohua1020@126.com
 * 中国传媒大学/数字电视技术
 * Communication University of China / Digital TV Technology
 * http://blog.csdn.net/leixiaohua1020
 *
 *
 */


#include <stdio.h>
#include <time.h> 

#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
#include "libavutil/opt.h"
#include "libavutil/parseutils.h"
#include "libavutil/log.h"

#ifdef ANDROID
#include <jni.h>
#include <android/log.h>
#define LOGE(format, ...)  __android_log_print(ANDROID_LOG_ERROR, "(>_<)", format, ##__VA_ARGS__)
#define LOGI(format, ...)  __android_log_print(ANDROID_LOG_INFO,  "(^_^)", format, ##__VA_ARGS__)
#else
#define LOGE(format, ...)  LOGE("(>_<) " format "\n", ##__VA_ARGS__)
#define LOGI(format, ...)  LOGE("(^_^) " format "\n", ##__VA_ARGS__)
#endif

//Output FFmpeg's av_log()
void custom_log(void *ptr, int level, const char* fmt, va_list vl){
	FILE *fp=fopen("/storage/emulated/0/av_log.txt","a+");
	if(fp){
		vfprintf(fp,fmt,vl);
		fflush(fp);
		fclose(fp);
	}
}


int flush_encoder(AVFormatContext *fmt_ctx,unsigned int stream_index){
	int ret;
	int got_frame;
	AVPacket enc_pkt;
	if (!(fmt_ctx->streams[stream_index]->codec->codec->capabilities &
		CODEC_CAP_DELAY))
		return 0;
	while (1) {
		enc_pkt.data = NULL;
		enc_pkt.size = 0;
		av_init_packet(&enc_pkt);
		ret = avcodec_encode_video2 (fmt_ctx->streams[stream_index]->codec, &enc_pkt,
			NULL, &got_frame);
		av_frame_free(NULL);
		if (ret < 0)
			break;
		if (!got_frame){
			ret=0;
			break;
		}
		LOGE("Flush Encoder: Succeed to encode 1 frame!\tsize:%5d\n",enc_pkt.size);
		/* mux encoded frame */
		ret = av_write_frame(fmt_ctx, &enc_pkt);
		if (ret < 0)
			break;
	}
	return ret;
}

JNIEXPORT jint JNICALL Java_com_leixiaohua1020_sffmpegandroidencoder_MainActivity_encode
  (JNIEnv *env, jobject obj, jstring inputurl_jstr, jstring resolution_jstr,jstring settings_jstr,jstring outputurl_jstr)
{
	AVFormatContext* pFormatCtx;
	AVOutputFormat* fmt;
	AVStream* video_st;
	AVCodecContext* pCodecCtx;
	AVCodec* pCodec;
	AVPacket pkt;
	uint8_t* picture_buf;
	AVFrame* pFrame;
	int picture_size;
	int y_size;
	int framecnt=0;
	int i;
	int ret=0;
	char *parsed_key,*value;
	char *settings_args;
	char inputurl_str[500]={0};
	char resolution_str[500]={0};
	char settings_str[500]={0};
	char outputurl_str[500]={0};
	sprintf(inputurl_str,"%s",(*env)->GetStringUTFChars(env,inputurl_jstr, NULL));
	sprintf(resolution_str,"%s",(*env)->GetStringUTFChars(env,resolution_jstr, NULL));
	sprintf(settings_str,"%s",(*env)->GetStringUTFChars(env,settings_jstr, NULL));
	sprintf(outputurl_str,"%s",(*env)->GetStringUTFChars(env,outputurl_jstr, NULL));

	//FILE *in_file = fopen("src01_480x272.yuv", "rb");	//Input raw YUV data
	FILE *in_file = fopen(inputurl_str, "rb");   //Input raw YUV data

	int in_w=0,in_h=0;   //Input data's width and height
	av_parse_video_size(&in_w,&in_h,resolution_str);

	int framenum=1000;                                   //Frames to encode
	//const char* out_file = "src01.h264";              //Output Filepath
	//const char* out_file = "src01.ts";
	//const char* out_file = "src01.hevc";
	//const char* out_file = "ds.h264";

	//FFmpeg av_log() callback
	av_log_set_callback(custom_log);

	av_register_all();
	//Method1.
	pFormatCtx = avformat_alloc_context();
	//Guess Format
	fmt = av_guess_format(NULL, outputurl_str, NULL);
	pFormatCtx->oformat = fmt;

	//Method 2.
	//avformat_alloc_output_context2(&pFormatCtx, NULL, NULL, out_file);
	//fmt = pFormatCtx->oformat;


	//Open output URL
	if (avio_open(&pFormatCtx->pb,outputurl_str, AVIO_FLAG_READ_WRITE) < 0){
		LOGE("Failed to open output file! \n");
		return -1;
	}

	video_st = avformat_new_stream(pFormatCtx, 0);
	video_st->time_base.num = 1;
	video_st->time_base.den = 25;

	if (video_st==NULL){
		return -1;
	}
	//Param that must set
	pCodecCtx = video_st->codec;
	//pCodecCtx->codec_id =AV_CODEC_ID_HEVC;
	pCodecCtx->codec_id = fmt->video_codec;
	pCodecCtx->codec_type = AVMEDIA_TYPE_VIDEO;
	pCodecCtx->pix_fmt = PIX_FMT_YUV420P;
	pCodecCtx->width = in_w;
	pCodecCtx->height = in_h;
	pCodecCtx->time_base.num = 1;
	pCodecCtx->time_base.den = 25;
	pCodecCtx->bit_rate = 400000;
	pCodecCtx->gop_size=250;
	//H264
	//pCodecCtx->me_range = 16;
	//pCodecCtx->max_qdiff = 4;
	//pCodecCtx->qcompress = 0.6;
	pCodecCtx->qmin = 10;
	pCodecCtx->qmax = 51;

	//Optional Param
	pCodecCtx->max_b_frames=3;

	// Set Option
	AVDictionary *param = 0;
	//Set Options
	settings_args=settings_str;
	while(*settings_args){
		ret=av_opt_get_key_value(&settings_args,"=",":",0,&parsed_key,&value);
		if(ret<0)
			break;
		av_dict_set(&param,parsed_key, value, 0);
		LOGE("key:%s, value:%s\n",parsed_key,value);
		if(*settings_args)
			settings_args++;
		av_free(parsed_key);
		av_free(value);
	}

	//av_dict_set(&param, "preset", "ultrafast", 0);
	//av_dict_set(&param, "tune", "zerolatency", 0);
	//av_dict_set(&param, "profile", "main", 0);

	pCodec = avcodec_find_encoder(pCodecCtx->codec_id);
	if (!pCodec){
		LOGE("Can not find encoder! \n");
		return -1;
	}
	if (avcodec_open2(pCodecCtx, pCodec,&param) < 0){
		LOGE("Failed to open encoder! \n");
		return -1;
	}


	pFrame = av_frame_alloc();
	picture_size = avpicture_get_size(pCodecCtx->pix_fmt, pCodecCtx->width, pCodecCtx->height);
	picture_buf = (uint8_t *)av_malloc(picture_size);
	avpicture_fill((AVPicture *)pFrame, picture_buf, pCodecCtx->pix_fmt, pCodecCtx->width, pCodecCtx->height);

	//Write File Header
	avformat_write_header(pFormatCtx,NULL);

	av_new_packet(&pkt,picture_size);

	y_size = pCodecCtx->width * pCodecCtx->height;

	for (i=0; i<framenum; i++){
		//Read raw YUV data
		if (fread(picture_buf, 1, y_size*3/2, in_file) <= 0){
			LOGE("Failed to read raw data! \n");
			break;
		}else if(feof(in_file)){
			break;
		}
		pFrame->data[0] = picture_buf;              // Y
		pFrame->data[1] = picture_buf+ y_size;      // U
		pFrame->data[2] = picture_buf+ y_size*5/4;  // V
		//PTS
		pFrame->pts=i;
		int got_picture=0;
		//Encode
		int ret = avcodec_encode_video2(pCodecCtx, &pkt,pFrame, &got_picture);
		if(ret < 0){
			LOGE("Failed to encode! \n");
			return -1;
		}
		if (got_picture==1){
			LOGI("Succeed to encode frame: %5d\tsize:%5d\n",framecnt,pkt.size);
			framecnt++;
			pkt.stream_index = video_st->index;
			ret = av_write_frame(pFormatCtx, &pkt);
			av_free_packet(&pkt);
		}
	}
	//Flush Encoder
	ret = flush_encoder(pFormatCtx,0);
	if (ret < 0) {
		LOGE("Flushing encoder failed\n");
		return -1;
	}

	//Write file trailer
	av_write_trailer(pFormatCtx);

	//Clean
	if (video_st){
		avcodec_close(video_st->codec);
		av_free(pFrame);
		av_free(picture_buf);
	}
	avio_close(pFormatCtx->pb);
	avformat_free_context(pFormatCtx);

	fclose(in_file);

	return 0;
}

