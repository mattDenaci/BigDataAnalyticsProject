public class WeatherMapper extends Mapper<LongWritable, Text, Text, IntWritable> { 
	public void map(LongWritable key, Text value, Context context) throws IOException,InterruptedException {
		String line = value.toString();
		String date = line.substring(15, 22);
		String chicagostations;//this will be initialized with the concatenation of all
		station ids from Chicago
		int temp,wdsp,prcp,sndp;//mean temperature, windspeed, precipitation and snow depth
		temp=Integer.parseInt(line.substring(25, 30));
		NCDC
		sndp=Integer.parseInt(line.substring(126, 130)); if(chicagostations.contains(line.substring(126, 130))){
		context.write(new Text(date), new IntWritable(temp)); context.write(new Text(date), new IntWritable(wdsp)); context.write(new Text(date), new IntWritable(prcp)); context.write(new Text(date), new IntWritable(sndp));
	}
}
