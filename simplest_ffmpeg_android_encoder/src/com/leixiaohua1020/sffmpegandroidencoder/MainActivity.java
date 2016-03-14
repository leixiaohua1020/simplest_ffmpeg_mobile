package com.leixiaohua1020.sffmpegandroidencoder;


import android.os.Bundle;
import android.os.Environment;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
		Button startButton = (Button) this.findViewById(R.id.button_start);
		final EditText edittext_input= (EditText) this.findViewById(R.id.input_yuv_url);
		final EditText edittext_resolution= (EditText) this.findViewById(R.id.input_yuv_resolution);
		final EditText edittext_settings= (EditText) this.findViewById(R.id.encode_settings);
		final EditText edittext_output= (EditText) this.findViewById(R.id.output_bitstream_url);
		
		startButton.setOnClickListener(new OnClickListener() {
			public void onClick(View arg0){

				String folderurl=Environment.getExternalStorageDirectory().getPath();
				
				String str_input=edittext_input.getText().toString();
		        String str_input_full=folderurl+"/"+str_input;
		        
		        String str_resolution=edittext_resolution.getText().toString();
		        String str_settings=edittext_settings.getText().toString();
		        
		        String str_output=edittext_output.getText().toString();
		        String str_output_full=folderurl+"/"+str_output;
		        
		        Log.i("inputurl",str_input_full);
		        Log.i("outputurl",str_output_full);
		    
		        encode(str_input_full,str_resolution,str_settings,str_output_full);
		        
			}
		});
        
        
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }
    
  //JNI
    public native int encode(String inputurl, String resolution,String settings,String outputurl);
    
    static{
    	System.loadLibrary("avutil-54");
    	System.loadLibrary("swresample-1");
    	System.loadLibrary("avcodec-56");
    	System.loadLibrary("avformat-56");
    	System.loadLibrary("swscale-3");
    	System.loadLibrary("postproc-53");
    	System.loadLibrary("avfilter-5");
    	System.loadLibrary("avdevice-56");
    	System.loadLibrary("sffencoder");
    }
    
    
}
