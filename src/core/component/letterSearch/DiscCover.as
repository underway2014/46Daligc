package core.component.letterSearch
{
	import core.interfaces.SelectItem;
	import core.loadEvents.CLoaderMany;
	import core.tween.TweenMax;
	import core.tween.easing.Cubic;
	import core.tween.plugins.RoundPropsPlugin;
	import core.tween.plugins.TweenPlugin;
	import core.tween.utils.tween.TransformAroundCenterVars;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	


	public class DiscCover extends Sprite implements SelectItem
	{

		private var urlArr:Array = new Array();
		private var loader:CLoaderMany;
		public var data:*;//存放按钮数据

		private var disc:Sprite=new Sprite;
		private var cover:Sprite=new Sprite;
		private var bottom:Sprite = new Sprite;
		
		
		/**
		 * 
		 * @param arg 全攻略封面、碟片、封底
		 * 
		 */		
		public function DiscCover(urlArr:Array)
		{
			super();
			this.urlArr = urlArr;
			this.addChild(bottom);
			this.addChild(disc);
			this.addChild(cover);
			
			trace("====urlArr==urlArrnnn==",urlArr);
			loader = new CLoaderMany();
			loader.load(urlArr);
			loader.addEventListener(CLoaderMany.LOADE_COMPLETE,loadOkHandler);

			this.addEventListener(MouseEvent.CLICK,clickHandler);	
			this.buttonMode = true;
		}
		private var hTargetX:Number;
		private var oneStepOver:Boolean = false;
		private var currentTarget:Point = new Point();
		private var targetXY:Point = new Point(540,1550);
		/**
		 *转动的蝶片是否可见 
		 * @param b
		 * 
		 */		
		public function move(b:Boolean):void
		{
			disc.visible = b;
//			hTargetX = disc.x + disc.width/2;
//			currentTarget = disc.globalToLocal(targetXY);
//			disc.addEventListener(Event.ENTER_FRAME,moveOutHandler);
		}
		private var rx:Number;
		private var ry:Number;
		private function moveOutHandler(event:Event):void
		{
			if(disc.x<hTargetX&&!oneStepOver)
			{
				disc.x += 2;
				
			}
			else
			{
				oneStepOver = true;
			}
			if(oneStepOver)
			{
				rx = (currentTarget.x - disc.x);
				ry = currentTarget.y - disc.y
				disc.x += (rx)*0.2;
				disc.y += (ry)*0.2;
				
				if(Math.abs(disc.x - currentTarget.x)<1&&Math.abs(disc.y - currentTarget.y)<1)
				{
					disc.removeEventListener(Event.ENTER_FRAME,moveOutHandler);
				}
			}
		}


		private var i:int;
		private function loadOkHandler(event:Event):void
		{
			i=0;
			try
			{
				cover.addChild(loader._loaderContent[i]);
				i++;
				disc.addChild(loader._loaderContent[i]);
				loader._loaderContent[i].x = -loader._loaderContent[i].width/2;
				loader._loaderContent[i].y = -loader._loaderContent[i].height/2;
				disc.x = -loader._loaderContent[i].x+27;
				disc.y = -loader._loaderContent[i].y+2;
				
				i++;
				if(i<urlArr.length)
					bottom.addChild(loader._loaderContent[i]);
				
				
				//discTurn();

//				if (centerZoom)
//				{
//					i = 0;
//					loader._loaderContent[i].x = -loader._loaderContent[i].width/2;
//					loader._loaderContent[i].y = -loader._loaderContent[i].height/2;
//					
//					i++;
//					loader._loaderContent[i].x = -loader._loaderContent[i].width/2;
//					loader._loaderContent[i].y = -loader._loaderContent[i].height/2;
//					
//					i++;
//					if(i<urlArr.length)
//					{
//						loader._loaderContent[i].x = -loader._loaderContent[i].width/2;
//						loader._loaderContent[i].y = -loader._loaderContent[i].height/2;
//					}
//				}
//				
				
			}
			catch(er:Error)
			{
				throw new Error("加载的图片路径个数不对！");
			}
			
			//init();
		}
		
		public function animation(b:Boolean = false):void
		{
			if(!b)
			{
				this.addEventListener(Event.ENTER_FRAME,enterFrame);
			}
		}
		
		private function enterFrame(e:Event):void
		{
			disc.rotation+=15;//Math.random()*30;
		}
		
		public function removeAnimation():void
		{
			disc.rotation = 0;
			this.removeEventListener(Event.ENTER_FRAME,enterFrame);
		}
		
		private function discTurn():void
		{
			TweenMax.to(disc, 10, {rotation:360});
			//TweenMax.to(disc,1000,{ease:Cubic.easeOut,TransformAroundPointVars:{ point:new Point(disc.x+100, disc.y+50), rotation:360 }, onComplete:discTurn});
			//TweenMax.to(disc,1000,{ease:Cubic.easeOut,transformAroundCenter:{rotation:(1*360*Direction)},x:x,y:y,onComplete:discTurn});

		}

		private function clickHandler(event:Event):void
		{

		}
		
		
		//private var str:Array = new Array("云南石林", "西双版纳", "云南民族村");
		private var str:Array = new Array("hello word", "adfasdfas", "werewrwdf"); 
		private var tft:TextFormat = new TextFormat(); 
		private function init():void
		{ 
			tft.font = "Microsoft YaHei"; 
			tft.color = 0x000000; 
			tft.size = 48; 
			tft.bold = true;
			
			var t:Timer=new Timer(1000); 
			t.addEventListener ("timer", textFly); 
			
			t.start ();
		} 
		
		private var index:int = 0;
		private function textFly (_evt:TimerEvent):void
		{  
			if (index == str.length-1)
				index = 0;
			
			var e_str:TextField=new TextField();
			e_str.text = str[index];
			e_str.defaultTextFormat = tft; 
			
			e_str.selectable=false; 
			e_str.x = 180;
			e_str.y = 100;
			this.addChild (e_str); 
			
			//trace (_evt.target.currentCount); 

			//TweenMax.to(e_str, 2, {x:10, y:10, Bezier:[{x:180, y:100},{x:90, y:0}], onComplete:clearText, onCompleteParams:[e_str]}); 
			TweenMax.to(e_str, Math.random()*2,{x:Math.random()/stage.stageWidth, y:Math.random()/stage.stageHeight, onComplete: clearText, onCompleteParams:[e_str]});
			
			index++;
		}; 
 

		public function select(b:Boolean):void
		{
			
		}
		private function clearText(_mc:TextField):void
		{ 
			this.removeChild (_mc); 
		} 
	}
}