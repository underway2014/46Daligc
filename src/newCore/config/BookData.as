package newCore.config
{
	/**
	 *每本书所含信息（DM单） 
	 * @author bin.li
	 * 
	 */	
	public class BookData
	{
		public var sid:int;
		public var picUrl:String;
		public var name:String;
		public var pics:String;	//每页的图片
		public var txt:String;		//文字内容
		public var coord:String;	//X，Y坐标
		public var titlePic:String; 	//文本描述开始的小图片
		public var mainPicUrl:String;	//每页图片URL
		public function BookData()
		{
		}
	}
}