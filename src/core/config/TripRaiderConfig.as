package core.config
{
	/**
	 *整个DUOBAO 的 XML数据 
	 * @author Administrator
	 * 
	 */
	public class TripRaiderConfig extends BaseConfig
	{
		
		private static var instance:TripRaiderConfig;
		public function TripRaiderConfig(_n:String = "tripRaider")
		{
			super(_n);
		}
		public static function getConfig():TripRaiderConfig
		{
			if(!instance)
			{
				instance = new TripRaiderConfig();
			}
			return instance;
		}
		public function getSample(id:int):TripRaiderData
		{
//			return instance.getSampleById(id) as TripRaiderData;
			return getSampleById(id) as TripRaiderData;
		}
		private var _length:uint;
		public function get length():uint
		{
			return getLength();
		}
	}
}