package com.example.echos

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

class BootBroadcastReceiver: BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent){
        if(Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())){
            val i = Intent(context, MainActivity::class.java).apply{
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            context.startActivity(i)
        }
    }
    // @Override
    // public void onReceive(Context context, Intent intent) {
    //     if (Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
    //         Intent i = new Intent(context, MainActivity.class);
    //         i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    //         context.startActivity(i);
    //     }
    // }
}