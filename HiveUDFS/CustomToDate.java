package com.BigDataProject.hive;

import org.apache.commons.lang.StringUtils;
import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.IntWritable;


//note: to build need to have have hive-exec*.jar in build path
class CustomToDate extends UDF {
	
  public String evaluate(Text input) {
  	int year = 2000 + Integer.parseInt(input.substring(5, 6));
  	int month =  Integer.parseInt(intput.substring(2,3));
  	int day = Integer.parseInt(input.substring(0,1));
    return new IntWritable(year+"-"+month+"-"+day);
  }
}