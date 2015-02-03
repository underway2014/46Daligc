package com
{
	import core.baseComponent.CButton;
	import core.layout.Group;
	import core.loadEvents.CLoader;
	import core.loadEvents.CLoaderMany;
	import core.loadEvents.CXmlLoader;
	import core.loadEvents.Cevent;
	import core.string.StringSlice;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ListWindow extends Sprite
	{
		private var listData:ListWindowData;
		public function ListWindow(xmlLoader:CXmlLoader)
		{
			super();
			
			listData = xmlLoader.getDataById(1) as ListWindowData;
				
			initBackground();
		}
		private var bgLoader:CLoaderMany;
		private function initBackground():void
		{
			bgLoader = new CLoaderMany();
			bgLoader.load([listData.mainurl + listData.bg,listData.mainurl + listData.bottomLine,listData.mainurl + listData.title]);
			bgLoader.addEventListener(CLoader.LOADE_COMPLETE,bgOkHandler);
		}
		private var buttonContain:Sprite;
		private function bgOkHandler(event:Event):void
		{
			addChild(bgLoader._loaderContent[0]);
			buttonContain = new Sprite();
			addChild(buttonContain);
			addChild(bgLoader._loaderContent[1]);
			bgLoader._loaderContent[1].y = 863 - bgLoader._loaderContent[1].height;
			
			addChild(bgLoader._loaderContent[2]);
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xaacc00,0.4);
			shape.graphics.drawRect(0,0,1080,863);
			shape.graphics.endFill();
			addChild(shape);
			this.mask = shape;
			
			var pArr:Array = StringSlice.addString(listData.turnPageButton.split(","),listData.mainurl,3);
			
			var leftButton:CButton = new CButton(pArr.slice(0,2),false);
			var rightButton:CButton = new CButton(pArr.slice(2),false);
			leftButton.data = "left";
			rightButton.data = "right";
			leftButton.addEventListener(MouseEvent.CLICK,turnPageHandler);
			
//			addChild(leftButton);
//			addChild(rightButton);
			leftButton.x = 50;
			rightButton.x = 1080 - 100;
			leftButton.y = rightButton.y = 300;
			
			
			initButton();
		}
		private var bx:int = 125;
		private var by:int = 60 + 110;
		private var group:Group = new Group();
		private function initButton():void
		{
			var arrN:Array = StringSlice.addString(listData.buttonListN.split(","),listData.mainurl,3);
			var arrD:Array = StringSlice.addString(listData.buttonListD.split(","),listData.mainurl,3);
			var len:int = arrN.length;
			
			var button:CButton;
			for(var i:int = 0;i<len ;i++)
			{
				button = new CButton([arrN[i],arrD[i]],false,false);
				button.addEventListener(MouseEvent.MOUSE_UP,clickHandler);
				
				buttonContain.addChild(button);
				button.data = i;
				group.add(button);
				if(i>1)	
				{
					button.mouseEnabled = false;
					button.mouseChildren = false;
				}
				
				button.x = bx + i%2*(363 + (1080 - 2*bx - 2*363));
				button.y = by + Math.floor(i/2)*(156 + 50);
			}
//			group.selectById(0);
			group.addEventListener(Cevent.SELECT_CHANGE,selectChangeHandler);
		}
		private function outHandler(event:MouseEvent):void
		{
			trace("in list window mouse out...test.");
		}
		public var curentScenicId:uint = 0;
		public var nameArray:Array = ["云南省","四川省"];
		private function clickHandler(event:MouseEvent):void
		{
			var b:CButton = (event.currentTarget as CButton);
			if(curentScenicId>1)
			{
				return;
			}
			curentScenicId = b.data;
			
			group.selectByItem(b);
		}
		private function selectChangeHandler(event:Event):void
		{
			group.selectById(-1);
			this.visible = false;
			dispatchEvent(new Event(LIST_CHANGE));
		}
		public static const LIST_CHANGE:String = "list_change";
		private function turnPageHandler(event:MouseEvent):void
		{
			var btn:CButton = event.currentTarget as CButton;
			switch(btn.data)
			{
				case "left":
					trace("left");
					break;
				case "right":
					trace("right");
					break;
			}
		}
	}
}