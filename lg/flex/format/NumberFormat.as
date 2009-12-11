package lg.flex.format {
	import mx.formatters.NumberFormatter;
	
	public class NumberFormat {
		public function NumberFormat() {
		}
		
		public static function dollarFormat(input:Number, round:Boolean=true):String {
			var formatted:String='', formatter:NumberFormatter=new NumberFormatter();
			
			if(round)
				formatter.precision				= 0;
			else
				formatter.precision				= 2;
			
			formatter.useNegativeSign		= true;
			formatter.useThousandsSeparator	= true;
			formatted	= formatter.format(input);
			
			return '$'+formatted;
		}
	}
}