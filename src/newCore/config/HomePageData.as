package newCore.config
{
	/**
	 *全攻略首页 
	 * @author bin.li
	 * 
	 */	
	public class HomePageData
	{
		public var mainurl:String;
		public var sid:int;
		public var name:String;
		
		public var normalArr0:String;		//首页按钮点击前按钮//广告按钮图片
		public var normalArr1:String;
		
		public var downBtn0:String;		//点击后BAR 翻面的按钮
		public var downBtn1:String;
		
		public var bg:String;	//按钮条背景
		
		public var urlarr0:String; //广告点击相应URL
		public var urlarr1:String;	//自己广告URL
		public var width:int;		//广告图片宽高
		public var height:int;
		
		public var jjbtn:String;
		
		//周边，一分钟攻略，线路，地图SWF地址
		public var oneMinuteUrl:String;
		public var circumUrl:String;
		public var mapsearchUrl:String;
		public var linsearchUrl:String;
		public var jjbgUrl:String;
		public function HomePageData()
		{
			
		}
	}
}