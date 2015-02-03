package newCore.component.letterSearch
{
	import core.loadEvents.Cevent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	public class ControlMove extends EventDispatcher
	{
		/**
		 *控制碟片运动 
		 * 
		 */		
		public function ControlMove()
		{
		}
		private static var object:DisplayObject;
		private static var targetXY:Point;
//		private static var targetXY:Point = new Point(540,1440);
		private static var oneTargetXY:Point;
		private static var beginX:Number;
		private static var beginSpeed:Number;//碟子转动初速度
		private static var maxSpeed:Number = 15;//最大速度
		
		private static var firSpeed:int = 12;
		private static var secSpeed:int = 50;
		/**
		 *飞出卡片 
		 * @param event
		 * 
		 */		
		public static function beginMove(_dis:DisplayObject,_w:Number):void
		{
			beginSpeed = 0;
			object = _dis;
			isNextStep = false;
			beginX = object.x;
			object.addEventListener(Event.ENTER_FRAME,beginMoveHandler);
			oneTargetXY = new Point(object.x + _w,object.y);
			targetXY = new Point(oneTargetXY.x + (1080 +_w/2 - oneTargetXY.x),oneTargetXY.y);
			
			trace("==out handler==",object.x,object.y,object.width,oneTargetXY);
		}
		/**
		 *返回卡片 
		 * 
		 */		
		public static function backMove():void
		{
			isNextStep = false;
			trace("back.hand..",oneTargetXY);
			object.addEventListener(Event.ENTER_FRAME,backMoveHandler);
		}
		private static function backMoveHandler(event:Event):void
		{
			object.rotation += beginSpeed;
			if(!isNextStep)
			{
				
//				var rx:Number;
//				var ry:Number;
//				if(oneTargetXY.x - object.x>0)
//				{
//					rx = Math.abs((object.x - oneTargetXY.x)*.1)<2?2:-(object.x - oneTargetXY.x)*.2;;
//				}
//				else
//				{
//					rx = Math.abs((object.x - oneTargetXY.x)*.1)<2?-2:-(object.x - oneTargetXY.x)*.2;;
//				}
//				if(oneTargetXY.y - object.y>0)
//				{
//					ry = Math.abs((object.y - oneTargetXY.y)*.1)<2?2:-(object.y - oneTargetXY.y)*.2
//				}
//				else
//				{
//					ry = Math.abs((object.y - oneTargetXY.y)*.1)<2?-2:-(object.y - oneTargetXY.y)*.2;
//				}
				object.x -= secSpeed;
//				object.y += ry;
//				if(Math.abs(oneTargetXY.x - object.x)<2&&Math.abs(oneTargetXY.y - object.y)<2)
				if(oneTargetXY.x >= object.x)
				{
					isNextStep = true;
					object.dispatchEvent(new Event(Cevent.DISK_BACK_FIRSTEP_OVER));
				}
			}
			else
			{
				
				object.x -= firSpeed;
				if(object.x < beginX)
				{
					object.x = beginX;
					object.removeEventListener(Event.ENTER_FRAME,backMoveHandler);
					object.dispatchEvent(new Event(Cevent.DISK_BACK_SECSTEP_OVER));
				}
			}
		}
		private static var isNextStep:Boolean;
		private static function beginMoveHandler(event:Event):void
		{
			object.rotation += beginSpeed;
			beginSpeed += 5;
			if(object.x < oneTargetXY.x&&!isNextStep)
			{
				object.x += firSpeed;
				if(oneTargetXY.x <= object.x)
				{
					isNextStep = true;
					object.dispatchEvent(new Event(Cevent.DISK_OUT_FIRSTEP_OVER));
				}
			}
			else
			{
//				var rx:Number;
//				var ry:Number;
//				if(targetXY.x - object.x>0)
//				{
//					 rx = Math.abs(-(object.x - targetXY.x)*.1)<2?2:-(object.x - targetXY.x)*.2;;
//				}
//				else
//				{
//					rx = Math.abs(-(object.x - targetXY.x)*.1)<2?-2:-(object.x - targetXY.x)*.2;;
//				}
//				if(targetXY.y - object.y>0)
//				{
//					ry = Math.abs(-(object.y - targetXY.y)*.1)<2?2:-(object.y - targetXY.y)*.2
//				}
//				else
//				{
//					ry = Math.abs(-(object.y - targetXY.y)*.1)<2?-2:-(object.y - targetXY.y)*.2;
//				}
				
				
				object.x += secSpeed;
				
//				object.y += ry;
//				if(Math.abs(object.x - targetXY.x)<3&&Math.abs(object.y - targetXY.y)<3)
				if(object.x > targetXY.x)
				{
					object.removeEventListener(Event.ENTER_FRAME,beginMoveHandler);
					object.x = targetXY.x;
					object.y = targetXY.y;
					object.dispatchEvent(new Event(Cevent.DISK_OUT_SECSTEP_OVER));
//					object.dispatchEvent(new Event
//					backMove();
//					isNextStep = false;
				}
			}
			
		}
	}
}