package core.config
{
	public class TripRaiderData
	{
		public var picUrl:String;//二级页面按钮URL
		public var sid:uint;
		public var name:String;
		public var type:int;//1:文本，图片类；2：可能是视频之类的
		
		public var mapbgUrl:String;//景点解说背景URL.
		
		public var mainUrl:String;//各图片的根文件路径+文件名 就可进行加载
		
		//下为景点解说
		public var btnsX:String;	//景点解说中按钮坐标
		public var btnsY:String;
		public var picarr:String;
		//
		
		//下为三级页面
		public var picarr1:String;//缩略图
		public var picarr2:String;//详细图URL
		public var btnskinn:String;//按钮正常状态URL
		public var btnskinc:String;//点击状URL
		public var detailBg:String;
		
		public var array:String;
		public var ts:String;
		
		public function TripRaiderData()
		{
		}
	}
}