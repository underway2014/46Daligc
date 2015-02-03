package core.config
{
	
	public class CommonData
	{
		/**
		 *字母查询公共资源 
		 * 
		 */		
		public function CommonData()
		{
		}
		
		public var sid:int;
		public var publicUrl:String;//公共资源路径
		public var letterUrl:String;//字母路径
		
		public var backPic:String;	//按钮
		public var turnPage:String;//翻页按钮 

		public var disc:String;		//碟片
		public var discBG:String;		//碟片背景
		
		public var letterBG:String;	//字母背景
		public var letteNormal:String;		//字母正常状态
		public var letteDown:String;	//字母选中状态
	}
}