import java.io.IOException;
import java.util.Iterator;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;


public class weatherReducer extends Reducer<Text, Text, Text, Text> {	

	public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {	
		/*for(Text value:values)
			context.write(key,value);*/

		//12-17	
		double airtempSUM=0,count=0;

		for(Text value:values) {
			airtempSUM+=Double.parseDouble(value.toString().trim());
			count++;
		}	
		double airtemAVG=airtempSUM/count;
		String res=","+String.valueOf(airtemAVG).trim();
		context.write(key,new Text(res));
			
		 
	}
}
	
