package newCore.config
{
	import core.xmlclass.XmlParse;
	import core.xmlclass.XmlBaseConfig

	public class LetterSearchConfig extends XmlBaseConfig
	{
		private static var instance:LetterSearchConfig;
		
		public function LetterSearchConfig(str:String=null)
		{
			super(str);
		}
		
		public static function getConfig():LetterSearchConfig
		{
			if(!instance)
			{
				instance = new LetterSearchConfig();
			}
			return instance;
		}
		
		public function getSample(id:int):LetterSearchData
		{
			return getSampleById(id) as LetterSearchData;
		}
		
		public function getSampleByGroup(group:String):LetterSearchData
		{
			var xmllist:XMLList = super.xml.sample.(@group==group);
			if (xmllist.length() == 0)
				return null;
			trace("=====*8xmllist.length()**==",xmllist.length());
			return XmlParse.parse(xmllist[0]) as LetterSearchData;
		}
		/**
		 *返回根结点属性值 
		 * @param _str
		 * @return 
		 * 
		 */		
		public function getRootAttribute(_str:String):String
		{
			return super.xml["@"+_str];
		}
		
		private var _length:uint;
		public function get length():uint
		{
			return getLength();
		}
	}
}