//package core.component.advertisement
//{
//	import core.baseComponent.CMoveClip;
//	import core.config.AdvertiseMentData;
//	import core.constant.Const;
//	import core.string.StringSlice;
//	
//	import flash.display.Sprite;
//	import flash.events.Event;
//	import flash.events.MouseEvent;
//	import flash.events.TimerEvent;
//	import flash.utils.Timer;
//	
//	public class FullScreenAdvertise extends Sprite
//	{
//		/**
//		 *全屏广告 
//		 * 
//		 */		
//		public function FullScreenAdvertise()
//		{
//			super();
//			
//			this.visible = false;
//			this.addEventListener(MouseEvent.CLICK,setVisionHandler);
//			init();
//			
//		}
//		private var mc:CMoveClip;
//		private function init():void
//		{
//			var config:XmlBaseConfig = new XmlBaseConfig("fullscreen");
//			var data:AdvertiseMentData = config.getSampleById(0) as AdvertiseMentData;
//			
//			var picArr:Array = data.pic.split(",");
//			
//			StringSlice.addString(picArr,data.mainUrl,2);
//			
//			mc = new CMoveClip(picArr,0.01,30,true,2);
//			mc.addEventListener(CMoveClip.PLAY_OVER,mcPlayOverHandler);
//			addChild(mc);
//			mc.addEventListener(CMoveClip.LOAD_OVER,loadOkHandler);
//		}
//		private function mcPlayOverHandler(event:Event):void
//		{
//			setVisionHandler(null);
//		}
//		private var isOk:Boolean;	//是否加载OK
//		private function loadOkHandler(event:Event):void
//		{
//			isOk = true;
//		}
//		private var nowIndex:int;
//		/**
//		 * 
//		 * 
//		 */		
//		public function play(_b:Boolean = true):void
//		{
//			if(isOk)
//			{
//				this.visible = true;
//				if(!_b)
//				{
//					mc.gotoAndSotp(nowIndex%mc.totalFrame+1);
//					nowIndex++;
//					if(nowIndex>100000)
//					{
//						nowIndex = nowIndex%mc.totalFrame;
//					}
//					timer = new Timer(Const.PLAYING_TIME,1);
//					timer.addEventListener(TimerEvent.TIMER,setVisionHandler);
//					timer.start();
//				}
//				else
//				{
//					mc.play();
//				}
//			}
//		}
//		private var timer:Timer;
//		private function setVisionHandler(event:Event):void
//		{
//			this.visible = false;
//			mc.stop();
//			if(timer)
//			{
//				timer.stop();
//				timer.removeEventListener(TimerEvent.TIMER,setVisionHandler);
//				timer = null;
//			}
//		}
//	}
//}