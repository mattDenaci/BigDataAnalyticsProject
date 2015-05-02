import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
public class weatherMapper extends Mapper<LongWritable, Text, Text, Text> {
	 
	public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
		String line = value.toString();
		
		//date,usaf
		String wdate=line.substring(44,52).trim();
		String usaf=line.substring(31,37).trim();
		String res="";
		//time
		res+=","+line.substring(53,57)+","+usaf;

		//wind
		String windquality=line.substring(85,86).trim();
		//windspeed
		String abc=line.substring(79,84).trim();
		double d=Double.parseDouble(abc);
		 
		double windspeed=0;
		if(windquality.matches("[01459]")&&d!=999.9)
			windspeed=d;
		res+=","+String.valueOf(windspeed).trim();

		//air temperature
		//String atquality=line.substring(119,120).trim();
		String atquality=line.substring(94,95).trim();
		double airtemp=0;		 
		abc=line.substring(87,93).trim();
		d=Double.parseDouble(abc);		 
		if(atquality.matches("[01459]")&&d!=999.9)
			airtemp=d;
		res+=","+String.valueOf(airtemp).trim();

		//precipitation
		String hours=line.substring(114,116).trim();
		Double amount=Double.parseDouble(line.substring(117,122).trim());
		String pptquality=line.substring(125,126).trim();
		if(!hours.equals("99")&&pptquality.matches("[01459]")&&amount!=999.9)		
			res+=","+hours+","+String.valueOf(amount);
		else
			res+=",0,0";

		//snow
		int snowdepth=Integer.parseInt(line.substring(166,170).trim());
		String squality=line.substring(173,174).trim();
		if(squality.matches("[01459]")&&snowdepth!=9999)
			res+=","+snowdepth;
		else
			res+=",0";
		context.write(new Text(wdate),new Text(res));


	}
}
