package core.component.advertisement
{
	import com.hurlant.crypto.symmetric.NullPad;
	
	import core.loadEvents.CLoaderMany;
	
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 *下方广告条 (四个滚动的 + 左右两个固定的)
	 * @author bin.li
	 * 
	 */	
	public class AdvertisementBar extends Sprite
	{
		private var content:RollAdvertisement;
		
		private var totalWidth:Number;	//流动内容宽度
		private var totalPage:int;	//内容有多少页(4 per page)
		
		private var loader:CLoaderMany;
		public function AdvertisementBar()
		{
			super();
			
			content = new RollAdvertisement();
			content.y = 41;
			content.x = content.picWidth;
			addChild(content);
			
			trace(content.selfarr);
			loader = new CLoaderMany();
			loader.load(content.selfarr);
			loader.addEventListener(CLoaderMany.LOADE_COMPLETE,selfOkHandler);//加载自己的广告
				
			totalWidth = content.picWidth*content.picNumber;
			totalPage = content.picNumber/4;
			
			var maskS:Shape = new Shape();
			maskS.graphics.beginFill(0xaacc00,0);
			maskS.graphics.drawRect(0,0,content.picWidth*4,content.picHeight);
			maskS.graphics.endFill();
			maskS.x = content.picWidth;
//			addChild(maskS);
//			content.mask = maskS;
			
			targetXY = new Point();
			
//			var timer:Timer = new Timer(10000);
//			timer.addEventListener(TimerEvent.TIMER,timerHandler);
//			timer.start();
		}
		private function timerHandler(event:TimerEvent):void
		{
			trace("==conten.width timer begin==",content.width);
			computeCoord();
			content.addEventListener(Event.ENTER_FRAME,contenMoveHandler);
		}
		private var i:int;
		private function selfOkHandler(event:Event):void
		{
			trace("==self ok===");
			i = 0;
			loader._loaderContent[1].x = content.picWidth*5;
			for each(var l:Loader in loader._loaderContent)
			{
				addChild(l);
				addChild(l);
				l.addEventListener(MouseEvent.CLICK,clickSelfHandler);
				l.name = content.selfUrlArr[i];
				i++;
			}
			
		}
		private function clickSelfHandler(event:MouseEvent):void
		{
			var l:Loader = event.currentTarget as Loader;
			trace("self==",l.name);
		}
		
		private var currentPage:int=1;	//当前页
		private var direction:int = 1;		//当前方向
		
		private var targetXY:Point;	//下一次移动的目的坐标
		
		private var speed:int = 6;		//移动速度
		/**
		 *广告移动 
		 * @param event
		 * 
		 */		
		private function contenMoveHandler(event:Event):void
		{
			content.x -= speed*direction;
			if(Math.abs(targetXY.x - content.x)<3)
			{
				trace("move ok..");
				content.x = targetXY.x;
				currentPage+=direction;
				content.removeEventListener(Event.ENTER_FRAME,contenMoveHandler);
				if(currentPage == totalPage)
				{
					direction = -1;
				}
				else if(currentPage == 1)
				{
					direction = 1;
					trace("归位前：",content.x);
					content.x = content.picWidth;	//归位一次
					trace("归位后：",content.x);
				}
			}
		}
		/**
		 *计算目的地坐标 
		 * 
		 */		
		private function computeCoord():void
		{
			targetXY.x = content.x - direction*content.picWidth*4;
			targetXY.y = content.y;
		}
	}
}