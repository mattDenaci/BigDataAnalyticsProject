//note: We do not need a reducer as we want to extract the vector of weather parameters for each day and would want to stop after the list of values from mapper is generated per entry. Later we can create a table from this processed file using Pig/Hive and perform a JOIN operation with the processed crime database with the date used as the common field.
public class weather {
public static void main(String[] args) throws Exception {
	if (args.length != 2) {
		System.err.println("Usage: weather <input path> <output path>"); System.exit(1​);
		}
	Job job = new Job();
	job.setJarByClass(weather.class);
	wdsp=Integer.parseInt(line.substring(79, 83)); prcp=Integer.parseInt(line.substring(119, 123));
	job.setJobName("Max temperature"); FileInputFormat.addInputPath(job, new Path(args[0]));
	FileOutputFormat.setOutputPath(job, new Path(args[1])); job.setMapperClass(weatherMapper.class); job.setNumReduceTasks(0); job.setOutputKeyClass(Text.class); job.setOutputValueClass(IntWritable.class);
	System.exit(job.waitForCompletion(true) ? 0 : 1); 
	}
}
