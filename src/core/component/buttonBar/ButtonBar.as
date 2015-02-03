package core.component.buttonBar
{
	import core.baseComponent.CButton;
	import core.config.HomePageData;
	import core.layout.Group;
	import core.loadEvents.CLoaderMany;
	import core.loadEvents.CXmlLoader;
	import core.loadEvents.Cevent;
	import core.loadEvents.DataEvent;
	import core.string.StringSlice;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 *按钮条 
	 * @author bin.li
	 * 
	 */	
	public class ButtonBar extends Sprite
	{
		private var homeData:HomePageData;
		private var loader:CXmlLoader;
		public function ButtonBar(url:String)
		{
			super();
			
			loader = new CXmlLoader();
			loader.loader(url);
			loader.addEventListener(CXmlLoader.LOADER_COMPLETE,loadOkHandler);
			
			addChild(buttonSprite);
			buttonSprite.addChild(frontSprite);
			buttonSprite.addChild(backSprite);
			
			addChild(jjSprite);
			jjSprite.x = 811;
			
//			config = new XmlBaseConfig("homepage");
		
		}
		private function loadOkHandler(event:Event):void
		{
			homeData = loader.getDataById(1) as HomePageData;
			
			initBg();
			initBtn();
			
		}
		
		private var bgArr:Array = [];
		private var bgLoader:CLoaderMany;//背景图片加载
		
		private function initBg():void
		{
			bgLoader = new CLoaderMany();
			bgLoader.load(StringSlice.addString(homeData.bg.split(","),homeData.mainurl,2));
			
			bgLoader.addEventListener(CLoaderMany.LOADE_COMPLETE,bgOKHandler);
		}
		private var buttonSprite:Sprite = new Sprite();
		
		private var frontSprite:Sprite = new Sprite();	//正面
		private var backSprite:Sprite = new Sprite();
		
		private var fgroup:Group = new Group();	//管理正面
		private var bgroup:Group = new Group();
		
		private var jjSprite:Sprite = new Sprite();//锦江按钮
		
		private var shapeMask:Shape = new Shape();
		
		private var safeSprite:Sprite = new Sprite();//用于保护，使点击不出问题
		/**
		 *u背景图片加载 
		 * @param event
		 * 
		 */		
		private function bgOKHandler(event:Event):void
		{
			bgArr.push(bgLoader._loaderContent[0]);
			bgArr.push(bgLoader._loaderContent[1]);//BAR背景图片
			
			jjSprite.addChildAt(bgLoader._loaderContent[2],0);
			
			frontSprite.addChildAt(bgArr[0],0);
			backSprite.addChildAt(bgArr[1],0);
			
			trace(frontSprite.height);
			
			shapeMask.graphics.beginFill(0xaacc00);
			shapeMask.graphics.drawRect(0,0,backSprite.width,backSprite.height);
			shapeMask.graphics.endFill();
			buttonSprite.addChild(shapeMask);
			backSprite.mask = shapeMask;
			
			safeSprite.graphics.beginFill(0xaacc00,0);
			safeSprite.graphics.drawRect(0,0,backSprite.width,backSprite.height);
			safeSprite.graphics.endFill();
			safeSprite.visible = false;
			addChild(safeSprite);
			
			
//			jjSprite.y = frontSprite.y = -frontSprite.height/2;
			backSprite.y = frontSprite.height;
//			backSprite.rotationX = 180;
			
//			masks.graphics.beginFill(0xaacc0,0.5);
//			masks.graphics.drawRoundRect(0,0,frontSprite.width,frontSprite.height,15,10);
//			masks.graphics.endFill();
//			addChild(masks);
//			masks.y = -frontSprite.height/2;
//			frontSprite.mask = masks;
		}
		private var masks:Shape = new Shape();
		private var i:int;
		private function initBtn():void
		{
			var fBtn:CButton;
			var f0:Array = homeData.normalArr0.split(",");
			var f1:Array = homeData.normalArr1.split(",");
			var len0:int = f0.length;
			for(i=0;i<len0;i++)
			{
				fBtn = new CButton(new Array(homeData.mainurl+f0[i],homeData.mainurl+f1[i]),false);
				fgroup.add(fBtn);
				fBtn.x = i*(162+80) + 80;
//				fBtn.x = 160 + i*240;
				fBtn.y = 5;
				fBtn.addEventListener(MouseEvent.CLICK,fclickHandler);
				frontSprite.addChild(fBtn);
				fBtn.data = "f" + i;
			}
			fgroup.addEventListener(Cevent.SELECT_CHANGE,fselectChangeHandler);
			
			//////////////////
			//锦江按钮
//			jjbtn = new Button(new CSkin());
			var btnArrHiden:Array = StringSlice.addString(homeData.jjbtn.split(","),homeData.mainurl,2);
			jjbtn = new CButton([btnArrHiden[0],btnArrHiden[1]],false);
			jjbtn.buttonMode = false;
			jjSprite.addChild(jjbtn);
			jjbtn.addEventListener(MouseEvent.CLICK,jjbgHandler);
			jjbtn.data = "hiden";
			jjbtn.x = 46;
			jjbtn.y = 3;
			
			
//			hidBtn = new CButton([btnArrHiden[0],btnArrHiden[1]],false);
//			hidBtn.buttonMode = false;
//			hidBtn.addEventListener(MouseEvent.CLICK,hidenHandler);
//			hidBtn.data = "hiden";
//			hidBtn.x = 46;
//			hidBtn.y = 3;
//			jjSprite.addChild(hidBtn);
//			hidBtn.visible = false;
			
			
			
			////////翻面后的按钮
			
			var bBtn:CButton;
			var b0:Array = homeData.downBtn0.split(",");
			var b1:Array = homeData.downBtn1.split(",");
			var len1:int = b0.length;
			for(i=0;i<len1;i++)
			{
				bBtn = new CButton(new Array(homeData.mainurl+b0[i],homeData.mainurl+b1[i]),false);
				bgroup.add(bBtn);
				bBtn.addEventListener(MouseEvent.CLICK,bClickHandler);
				backSprite.addChild(bBtn);
				bBtn.x = 75 + i*184;
				bBtn.y = 15;
				bBtn.data = "b" + i;
			}
			bgroup.addEventListener(Cevent.SELECT_CHANGE,bSelectChangeHandler);
			
			fgroup.add(jjbtn);
			bgroup.add(jjbtn);
			fgroup.selectById(0);
			
//			frontSprite.y = -frontSprite.height/2;
//			backSprite.y = -backSprite.height/2;
			
		}
		private var hidBtn:CButton;	//和宾馆按钮重合
		private var jjbtn:CButton;
		/**
		 *buttonBar 旋转 
		 * 
		 */		
		public function rotationSelf():void
		{
			
			trace(buttonSprite.rotationX);
			buttonSprite.addEventListener(Event.ENTER_FRAME,rotationNewHandler);
			
		}
		private function rotationNewHandler(event:Event):void
		{
			if(isFront)
			{
				buttonSprite.scaleY -= 0.1;
			}
			else
			{
				buttonSprite.scaleY += 0.1;
			}
			
			if(buttonSprite.scaleY<0&&isFront)
			{
				frontSprite.visible = false;
			}
			if(buttonSprite.scaleY>0&&!isFront)
			{
				frontSprite.visible = true;
			}
			if(buttonSprite.scaleY<=-1)
			{
				buttonSprite.scaleY = -1;
				isFront = false;
				buttonSprite.removeEventListener(Event.ENTER_FRAME,rotationNewHandler);
			}
			if(buttonSprite.scaleY>1)
			{
				buttonSprite.scaleY = 1;
				isFront = true;
				buttonSprite.removeEventListener(Event.ENTER_FRAME,rotationNewHandler);
			}
		}
		private var isFront:Boolean = true;//是否是正面
		private function rotationHandler(event:Event):void
		{
			if(isFront)
			{
				//<1?1:(180 - buttonSprite.rotationX%360)*0.05
//				trace((180 - buttonSprite.rotationX%360)*0.05<1?1:(180 - buttonSprite.rotationX%360)*0.05);
				var r:Number = (180 - buttonSprite.rotationX%360)*0.1<1?1:(180 - buttonSprite.rotationX%360)*0.1;
				buttonSprite.rotationX = buttonSprite.rotationX%360 + r;
			}
			else
			{
				//<1?1:(360 - buttonSprite.rotationX%360)*0.05
				var rr:Number = (360 - buttonSprite.rotationX%360)*0.1<1?1:(360 - buttonSprite.rotationX%360)*0.1;
				buttonSprite.rotationX = buttonSprite.rotationX%360 + rr;
			}
			if(rotationX>=88&&isFront)
			{
				frontSprite.visible = false;
			}
			if(rotationX>=268&&!isFront)
			{
				
				frontSprite.visible = true;
			}
			if(Math.abs(180 - rotationX)<1)
			{
				rotationX = 180;
				if(isFront)
				{
					isFront = false;
				}
				else
				{
					isFront = true;
				}
				buttonSprite.removeEventListener(Event.ENTER_FRAME,rotationHandler);
			}
			else if(Math.abs(360 - rotationX)<1)
			{
				rotationX = 0;
				if(isFront)
				{
					isFront = false;
				}
				else
				{
					isFront = true;
				}
				buttonSprite.removeEventListener(Event.ENTER_FRAME,rotationHandler);
			}
		}
		private var dataEvent:DataEvent;
		private function fselectChangeHandler(event:Event):void
		{
			var fb:CButton = fgroup.getCurrentObj() as CButton;
			if(dataEvent)
			{
				dataEvent = null;
			}
			dataEvent = new DataEvent(DataEvent.CLICK);
			dataEvent.data = fb.data;
			trace("==data=dispatchEvent=f==",fb.data);
			dispatchEvent(dataEvent)
		}
		public function resetGroup():void
		{
//			bgroup.selectById(-1);
			bgroup.selectById(-1);
			fgroup.selectById(0);
			jjbtn.select(false);
//			bgroup.resetCurrentItem();
//			fgroup.resetCurrentItem();
		}
		/**
		 *猎取当前选中按钮的ID 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getCurrentId(type:String = "f"):int
		{
			if(type == "f")
			{
				return fgroup.getCurrentId();
			}
			else
			{
				return bgroup.getCurrentId();
			}
				
		}
		private var nowState:int = 1;
		/**
		 *自动切换两个界面 
		 * 
		 */		
		public function atuoChange():void
		{
//			var id:int = nowState%2 == 1?1:0;
//			if(fgroup.getCurrentId() == id)
//			{
//				nowState++;
//				id = nowState%2 == 1?1:0;
//			}
			fgroup.selectById(0);
		}
		private function fclickHandler(event:MouseEvent):void
		{
			var btn:CButton = event.currentTarget as CButton;
			fgroup.selectByItem(btn);
			jjbtn.select(false);
			if(btn.data == "f1")//景点查询
			{
//				rotationSelf();
				bgroup.selectById(0);
//				fgroup.selectById(-1);
				safeSprite.visible = true;
				upMove();
			}
		}
		
		
		private function bSelectChangeHandler(event:Event):void
		{
			var bb:CButton = bgroup.getCurrentObj() as CButton;
			
			if(dataEvent)
			{
				dataEvent = null;
			}
			dataEvent = new DataEvent(DataEvent.CLICK);
			dataEvent.data = bb.data;
			dispatchEvent(dataEvent)
//			trace("==data=dispatchEvent=f==",bb.data);
//			trace("==data==f==",bb.data);
		}
		private function bClickHandler(event:MouseEvent):void
		{
			var b:CButton = event.currentTarget as CButton;
			bgroup.selectByItem(b);
			jjbtn.select(false);
			trace("==data==f==",b.data);
			if(b.data == "b3")	//返回
			{
				fgroup.selectById(0);
				safeSprite.visible = true;
//				rotationSelf();
				downMove();
			}
		}
		private function upMove():void
		{
			backSprite.addEventListener(Event.ENTER_FRAME,upHandler);
			
		}
		
		public function downMove():void
		{
			backSprite.addEventListener(Event.ENTER_FRAME,downHandler);
		}
		private function upHandler(event:Event):void
		{
			backSprite.y -= moveSpeed;
			if(backSprite.y<=0)
			{
				backSprite.y = 0;
				backSprite.removeEventListener(Event.ENTER_FRAME,upHandler);
				safeSprite.visible = false;
				this.dispatchEvent(new Event("btnUpOver",true));
			}
//			fgroup.selectById(-1);
			
		}
		private var moveSpeed:Number = 10;
		private function downHandler(event:Event):void
		{
			backSprite.y += moveSpeed;
			if(backSprite.y>=frontSprite.height)
			{
				safeSprite.visible = false;
				backSprite.y = frontSprite.height;
				backSprite.removeEventListener(Event.ENTER_FRAME,downHandler);
			}
		}
		/**
		 *设置所有按钮都未选中 
		 * @param event
		 * 
		 */		
		private function jjbgHandler(event:MouseEvent):void
		{
			bgroup.selectById(-1);
			fgroup.selectById(-1);
//			hidBtn.visible = true;
//			jjbtn.visible = false;
			if(dataEvent)
			{
				dataEvent = null;
			}
			dataEvent = new DataEvent(DataEvent.CLICK);
			dataEvent.data = jjbtn.data;
			dispatchEvent(dataEvent)
		}
		private function hidenHandler(event:MouseEvent):void
		{
//			jjbtn.visible = true;
//			hidBtn.visible = false;
			bgroup.selectById(-1);
			fgroup.selectById(-1);
			if(dataEvent)
			{
				dataEvent = null;
			}
			dataEvent = new DataEvent(DataEvent.CLICK);
			dataEvent.data = hidBtn.data;
			dispatchEvent(dataEvent)
		}
	}
}