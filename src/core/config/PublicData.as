package core.config
{
	import flash.geom.Point;
	
	public class PublicData
	{
		/**
		 *公共资源 
		 * 
		 */		
		public function PublicData()
		{
		}
		
		public var bg:String;  //背景
		
		public var titleLetter:String;	//字母查询标题
		public var titleRecommend:String; //景区推荐标题
		public var titleRoute:String;		//线路查询标题
		public var titleMap:String;		//地图查询标题
		public var titleOneMinute:String;	//一分钟攻略标题
		public var titleLiJiang:String;    //丽江古城
		public var titlebg:String;			//标题背景
		public var titleinfo:String;		//其他信息
		
		public var controlUrls:String;           //地图放大缩小按钮
		public var zoomPos:Point = new Point(887,533);
		public var controlPos:Point = new Point(953,452);//312
		public var controlBtnTopPos:Point = new Point(981.2,469.85);
		public var controlBtnBottomPos:Point = new Point(981.2,534.4);
		public var controlBtnLeftPos:Point = new Point(966.3,486);
		public var controlBtnRightPos:Point = new Point(1029.55,486);
		
		public var scrollBar:String;//拖动条
		public var sid:int;
		public var lyjPic:String;
		
		public var backButton:String;
		
		public function getCtrlBtnsPos():Array
		{
			var posArr:Array = new Array;

			posArr.push(controlBtnTopPos);
			posArr.push(controlBtnBottomPos);
			posArr.push(controlBtnLeftPos);
			posArr.push(controlBtnRightPos);
			
			return posArr;
		}
	}
}