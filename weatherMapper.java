import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
public class weatherMapper extends Mapper<LongWritable, Text, Text, Text> {
	 
	public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
		String line = value.toString();
		
		//date
		String wdate=line.substring(44,52).trim();
		String usaf=line.substring(31,37).trim();
		String res="";
		//time
		res+=","+line.substring(53,57)+","+usaf;
		//wind
		String windquality=line.substring(85,86).trim();
		//String abc=line.substring(80,85).trim();
		String abc=line.substring(79,84).trim();
		double d=Double.parseDouble(abc);
		//double d=Double.parseDouble(line.substring(80,85).trim());
		double windspeed=0;
		if(windquality.matches("[01459]")&&d!=999.9)
			windspeed=d;
		res+=","+String.valueOf(windspeed).trim();
		//air temperature
		String atquality=line.substring(119,120).trim();
		//String atquality=line.substring(120,121).trim();
		double airtemp=0;
		abc=line.substring(112,118).trim();
		d=Double.parseDouble(abc);
		//d=Double.parseDouble(line.substring(113,119).trim());
		if(atquality.matches("[01459IMPRU]")&&d!=999.9)
			airtemp=d;
		res+=","+String.valueOf(airtemp).trim();
		//precipitation
		String hours=line.substring(139,141).trim();
		Double amount=Double.parseDouble(line.substring(142,147).trim());
		if(line.substring(148,149).trim().equals("9")&&line.substring(150,151).trim().matches("[01459IMPRU]")&&amount!=999.9)
			res+=","+hours+","+String.valueOf(amount);
		else
			res+=",-1,-1";
		//snow
		int snowdepth=Integer.parseInt(line.substring(191,195).trim());
		String squality=line.substring(198,199).trim();
		if(squality.matches("[01459IM]")&&snowdepth!=9999)
			res+=","+snowdepth;
		else
			res+=",-1";
		context.write(new Text(wdate),new Text(res));


	}
}
