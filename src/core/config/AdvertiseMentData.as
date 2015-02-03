package core.config
{
	/**
	 *第条广告对应的信息 
	 * @author bin.li
	 * 
	 */	
	public class AdvertiseMentData
	{
		public var name:String;
		public var sid:int;
		public var mainUrl:String;
		public var pic:String;			//广告图片
		public var targetUrl:String;	//点击后连接到的地址
		public var swf:String;	//上方的两个广告
		public var id:String;	//每个广告独有的序列号
		public var w:int;	//视频宽度
		public var h:int;
		public function AdvertiseMentData()
		{
		}
	}
}