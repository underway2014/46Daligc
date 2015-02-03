package newCore.component.letterSearch
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import core.admin.Administrator;
	import core.baseComponent.CButton;
	import core.constant.Const;
	import core.filter.CFilter;
	import core.layout.Group;
	import core.layout.Layout;
	import core.layout.PageLayout;
	import core.loadEvents.CLoader;
	import core.loadEvents.CLoaderMany;
	import core.loadEvents.CXmlLoader;
	import core.loadEvents.Cevent;
	import core.loadEvents.DataEvent;
	import core.moveClass.DisplayObjectEffect;
	import core.string.StringSlice;
	
	import newCore.config.CommonData;
	import newCore.config.LetterSearchData;
	
	/**
	 *字母查询首页
	 * @author yn.gao
	 * 
	 */	
	
	public class LetterSearchPage extends Sprite
	{
		private var PAGE_WIDTH:int = 1000;
		private var ITEM_NUM_PER_PAGE:int = 8;
		
		private var PUBLIC_SRC:String = "letter_common";
		
		private var letterGroup:Group = new Group();
		private var letterLayout:Layout = new Layout(26,1,32,0,63,0);
		private var contentLayout:PageLayout;
		
		private var contentMask:Shape;	//中部景点按钮遮罩
		private var showMask:Shape;	//DM，攻略遮罩
		
		private var scenicType:String;
		private var curSid:int = 0;
		
		private var s:Stage;
		
		private var commonData:CommonData;
		
		private var loaderPublic:CXmlLoader;
		private var loaderScenicList:CXmlLoader;
		private var listLoader:CXmlLoader;
		public function LetterSearchPage(type:String,_s:Stage,_loader:CXmlLoader)
		{
			scenicType = type;
			
			listLoader = _loader;
			
			loaderPublic  = new CXmlLoader();
			loaderPublic.loader(listLoader.getUrlByName(PUBLIC_SRC));
			trace(listLoader.getUrlByName(PUBLIC_SRC));
			loaderPublic.addEventListener(CXmlLoader.LOADER_COMPLETE,publicOkHandler);
			
			s = _s;
		}
		
		/**
		 *公共资源加载完毕
		 * @param event
		 * 
		 */	
		private function publicOkHandler(event:Event):void
		{
			commonData = loaderPublic.getDataById(0) as CommonData;
			
			loaderScenicList = new CXmlLoader();
			loaderScenicList.loader(listLoader.getUrlByName(scenicType));
			loaderScenicList.addEventListener(CXmlLoader.LOADER_COMPLETE,configOkHandler);
		}
		
		private function configOkHandler(event:Event):void
		{
			contentPannel = new Sprite();
			
			initBg();
			
			if(!maskShape)
			{
				maskShape = new Sprite();
				maskShape.graphics.beginFill(0xaa00cc,0);
				maskShape.graphics.drawRect(0,0,1080,864);
				maskShape.graphics.endFill();
				maskShape.y = 1056;
				s.addChild(maskShape);
				maskShape.visible = false;
			}
			
			//			if(type != Const.RECOMMEND)	//用于支持拖动翻页
			//			{
			//				//				contentPannel.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			//				//				contentPannel.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			//			}
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			Administrator.instance.addEventListener(Cevent.CLEAR_DM_QGL,clearAllHandler);
			
			//点击字母查询时，按钮有放大，缩小效果，要等效果完成才能进行下一步处理
			DisplayObjectEffect.instance.addEventListener("scaleOver",scaleOverHandler);
			
			//			this.addEventListener("bfs2Event",clearDmHandler);
			//			this.addEventListener("xdqEvent",clearQglHandler);
			
			addRemoveListener();
		}
		private function initBg():void
		{
			var l:CLoaderMany = new CLoaderMany();
			var bgArr:Array = new Array();
			bgArr.push(loaderScenicList.getRootAttribute("bg"));
			bgArr.push(loaderScenicList.getRootAttribute("titlebg"));
			bgArr.push(loaderScenicList.getRootAttribute("info"));
			bgArr.push(loaderScenicList.getRootAttribute("title"));
			trace(bgArr);
			l.load(bgArr);
			l.addEventListener(CLoader.LOADE_COMPLETE,bgLoadHandler);
		}
		private function scaleOverHandler(event:Event):void
		{
			trace("get scaleOver event..");
			maskShape.visible = false;
		}
		
		/**
		 *字母查询栏目中的DM OR 攻略清除 
		 * @param event
		 * 
		 */		
		public function clearAllHandler(event:Event):void
		{
			//			trace("get back event clear..");
			//			var o:DisplayObject;
			while(contentSprite.numChildren)
			{
				contentSprite.removeChildAt(0);
			}
			if(currentType=="DM")
			{
				DisplayObjectEffect.reset();
			}
			else if(currentType=="QGL")
			{
				btn.move(true);
			}
			if(scenicType != Const.RECOMMEND)
			{
				setTurnButton(false);
			}
			if(maskShape)
				maskShape.visible = false;
			isMoving = false;
		}
		/**
		 *DM单清除 
		 * @param event
		 * 
		 */		
		private function clearDmHandler(event:Event):void
		{
			trace("get back event haha..");
			while(contentSprite.numChildren)
			{
				contentSprite.removeChildAt(0);
			}
			loader._loader = null;
			loader = null;
			DisplayObjectEffect.reset();
			setTurnButton(false);
		}
		/**
		 *清除全攻略 
		 * @param event
		 * 
		 */		
		private function clearQglHandler(event:Event):void
		{
			trace("get clear event.new..",event.type);
			while(contentSprite.numChildren)
			{
				contentSprite.removeChildAt(0);
			}
			//			loader._loader = null;
			//			loader = null;
			////			showDisk();
			if(currentType!="DM")
			{
				trace("set disk.visible is true");
				disk.visible = true;
				maskShape.visible = true;
				ControlMove.backMove();
				setTurnButton(false);
			}
			else
			{
				DisplayObjectEffect.reset();
				setTurnButton(false);
			}
		}
		private var mousePoint:Point = new Point();	//记录MOUSE DOWN 时的坐标
		private function mouseDownHandler(event:MouseEvent):void
		{
			if(isMoving)	return;
			mousePoint.x = mouseX;
			mousePoint.y = mouseY;
			contentPannel.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
		}
		private var maskShape:Sprite;	//用于翻页和按钮点击间的冲突
		private function mouseMoveHandler(event:MouseEvent):void
		{
			maskShape.visible = true;
			maskShape.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}
		private function mouseUpHandler(event:MouseEvent):void
		{
			if(isMoving||Math.abs(mousePoint.x-mouseX)<22) return;
			if(mousePoint.x>mouseX)
			{
				trace("next page");
				nextBtnClickHandler(null);
			}
			else if(mousePoint.x<mouseX)
			{
				prevBtnClickHandler(null);
				trace("pre page..");
			}
			contentPannel.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			maskShape.visible = false;
			maskShape.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}
		
		private function bgLoadHandler(event:Event):void
		{
			var ll:CLoaderMany = event.currentTarget as CLoaderMany;
			ll._loaderContent[0].y = 18;
			ll._loaderContent[2].x = 222;
			ll._loaderContent[2].y = 69;
			ll._loaderContent[3].x = 370;
			ll._loaderContent[3].y = 10;
			for each(var l:Loader in ll._loaderContent)
			{
				this.addChild(l);
			}
			
			if(scenicType == Const.RECOMMEND)
			{
				initContent();
				if(loaderScenicList.getLength()>8)
					initPageTurningBtn();
			}
			else if (scenicType == Const.SEARCH)
			{
				initLetter();
				initContent();
				initPageTurningBtn();
			}
		}
		
		/**
		 *初始化字母列表
		 */
		private var letterPannel:Sprite
		private function initLetter():void
		{
			letterPannel = new Sprite();
			this.addChild(letterPannel);
			
			var l:CLoader = new CLoader();
			l.load(commonData.letterUrl+commonData.letterBG);
			l.addEventListener(CLoader.LOADE_COMPLETE,letterBGLoadHandler);
		}
		
		private var letterPannelEndXY:Point = new Point(45, 616);
		private var letterXY:Point = new Point(45,846);	//下方字母条的最终坐标
		private function letterBGLoadHandler(event:Event):void
		{
			var ll:CLoader = event.currentTarget as CLoader;
			letterPannel.addChildAt(ll._loader,0);
			letterPannel.x = letterXY.x;
			letterPannel.y = letterXY.y;
			
			var narr:Array = commonData.letteNormal.split(",");
			var darr:Array = commonData.letteDown.split(",");
			
			for (var i:int=0; i<26; i++) 
			{
				var btnSrcArr:Array = new Array(commonData.letterUrl+narr[i], commonData.letterUrl+darr[i]);
				var btn:CButton = new CButton(btnSrcArr,false);
				btn.addEventListener("buttonOK",btnLoadOkHandler);
				//				trace("bbbbbbbbbbbbbb;...",btn.width);
				letterGroup.add(btn);
				//				letterPannel.addChild(btn);
				
				btn.data = Const.LETTERS.charAt(i);
				btn.addEventListener(MouseEvent.CLICK, letterClickHandler);
				
			}
			
			//			this.addEventListener(Event.ENTER_FRAME, letterBarUpHandler);
			letterGroup.addEventListener(Cevent.SELECT_CHANGE,selectChangeHandler);
			//			trace("==trace(letterGroup.getItmeArr().length);==**",letterGroup.getItmeArr().length);
			
		}
		public function resetLetterSelect():void
		{
			letterGroup.selectById(0);
		}
		private var i:int;
		private function btnLoadOkHandler(event:Event):void
		{
			//			var btn:CButton = event.target as CButton;
			//			trace("get letterLayout.addAppress(btn);...",btn.width);
			i++;
			if(i<26)	return;
			for each(var b:CButton in letterGroup.getItmeArr())
			{
				letterLayout.addAppress(b);
				letterPannel.addChild(b);
			}
		}
		private function letterClickHandler(event:MouseEvent):void
		{
			var b:CButton = event.currentTarget as CButton;
			var data:LetterSearchData =	loaderScenicList.getDataByAttribute(b.data, "group") as LetterSearchData;
			//			var data:LetterSearchData = config.getSampleByGroup(b.data);
			if(data == null)
				return;
			
			letterGroup.selectByItem(b);
		}
		private var currentObject:DisplayObject;	//点击某个字母时，当前第一个这类景点的按钮本身
		private function selectChangeHandler(event:Event):void
		{
			var tb:CButton = letterGroup.getCurrentObj() as CButton;
			//			var data:LetterSearchData = config.getSampleByGroup(tb.data);
			var data:LetterSearchData =	loaderScenicList.getDataByAttribute(tb.data, "group") as LetterSearchData;
			if(data == null)
				return;
			
			if(currentObject)
			{
				currentObject.filters = null;
			}
			currentObject = btnArr[data.sid] as DisplayObject;
			currentObject.filters = CFilter.glowFilter;
			//			DisplayObjectEffect.reset();
			maskShape.visible = true;
			DisplayObjectEffect.scale(currentObject,true);
			
			//contentLayout.resetPosition(data.sid);
			//contentPannel.x = data.sid == 0 ? 0 : 0-(int(data.sid/ITEM_NUM_PER_PAGE)+1)*PAGE_WIDTH;
			//			contentMask.x = data.sid == 0 ? 0 : (int(data.sid/ITEM_NUM_PER_PAGE+1))*PAGE_WIDTH;;
			//curSid = data.sid;
			
			var curPageIndex:int = data.sid == 0 ? 0 : int(data.sid/ITEM_NUM_PER_PAGE);
			contentPannel.x = data.sid == 0 ? 0 : 0-curPageIndex*PAGE_WIDTH;
			curSid = curPageIndex*8;
			discAnimation();
		}
		/**
		 *将LETTER的XY恢复到初始 
		 * 
		 */		
		public function recoverLetterXY():void
		{
			if(letterPannel)
			{
				letterPannel.y = letterXY.y;
			}
		}
		/**
		 *下边字母向上运动
		 * 
		 */		
		public function upMove():void
		{
			this.addEventListener(Event.ENTER_FRAME, letterBarUpHandler);
		}
		private function letterBarUpHandler(event:Event):void
		{
			letterPannel.y -= (letterPannel.y-letterPannelEndXY.y)*0.5;
			
			if(Math.abs(letterPannel.y-letterPannelEndXY.y)<1)
			{
				trace("==thirdPageDownHandler==");
				letterPannel.y = letterPannelEndXY.y;
				
			}
			if(letterPannel.y == letterPannelEndXY.y)
			{
				trace(letterGroup.getItmeArr().length);
				this.removeEventListener(Event.ENTER_FRAME,letterBarUpHandler);
				letterGroup.selectById(0);
			}
		}
		private var btnArr:Array;
		private function stepLoader(event:TimerEvent):void
		{
			var endIndex:int = currentIndex+8;
			if(endIndex>=loaderScenicList.getLength())
			{
				endIndex = loaderScenicList.getLength();
			}
			var letterCurData:LetterSearchData;
			for (var i:int=currentIndex; i<endIndex; i++)
			{
				letterCurData = loaderScenicList.getDataById(i) as LetterSearchData;
				if (letterCurData.type == "book")	//DM单
				{
					var btnSrcArr:Array = new Array(letterCurData.cover);
					var btn:CButton = new CButton(btnSrcArr,false);
					contentLayout.add(btn);
					btn.data = [letterCurData.name,letterCurData.url];
					btn.addEventListener(MouseEvent.CLICK,dmClickHandler);
					contentPannel.addChild(btn);
					btnArr.push(btn);
				}else if(letterCurData.type == "mobile")//mobile
				{
					var discCSrcArr:Array = new Array(letterCurData.cover, commonData.publicUrl+commonData.disc, 
						commonData.publicUrl+commonData.discBG);
					var discC:DiscCover = new DiscCover(discCSrcArr);
					contentLayout.add(discC);
					disc.data = [letterCurData.name,letterCurData.url,"mobile"];
					disc.addEventListener(MouseEvent.CLICK,contentClickHandler);
					contentPannel.addChild(disc);
					btnArr.push(disc);
				}
				else	//全攻略
				{
					var discSrcArr:Array = new Array(letterCurData.cover, commonData.publicUrl+commonData.disc, 
						commonData.publicUrl+commonData.discBG);
					var disc:DiscCover = new DiscCover(discSrcArr);
					contentLayout.add(disc);
					disc.data = [letterCurData.name,letterCurData.url];
					disc.addEventListener(MouseEvent.CLICK,contentClickHandler);
					contentPannel.addChild(disc);
					btnArr.push(disc);
				}
			}
			currentIndex += 8;
			
			if(endIndex == loaderScenicList.getLength())
			{
				loadTimer.stop();
				loadTimer.removeEventListener(TimerEvent.TIMER,stepLoader);
				loadTimer = null;
				discAnimation();
			}
		}
		private var contentPannel:Sprite;
		private var currentIndex:int;
		private var loadTimer:Timer;
		/**
		 *初始化景区列表
		 */
		private function initContent():void
		{
			
			this.addChild(contentPannel);
			
			if(scenicType == Const.RECOMMEND)
			{
				contentLayout = new PageLayout(2, 4, loaderScenicList.getLength(), 250, 260, 55, 120);
			}
			else
			{
				contentLayout = new PageLayout(2, 4, loaderScenicList.getLength(), 250, 250, 55, 120);
			}
			
			btnArr = [];
			
			loadTimer = new Timer(10);
			loadTimer.addEventListener(TimerEvent.TIMER,stepLoader);
			loadTimer.start();
			//			for (var i:int=0; i<config.length; i++)
			//			{
			//				if (config.getSample(i).type == "book")	//DM单
			//				{
			//					var btnSrcArr:Array = new Array( config.getSample(i).cover, config.getSample(i).cover);
			//					var btn:CButton = new CButton(btnSrcArr,false);
			//					contentLayout.add(btn);
			//					btn.data = config.getSample(i).url;
			//					btn.addEventListener(MouseEvent.CLICK,dmClickHandler);
			//					contentPannel.addChild(btn);
			//				}
			//				else	//全攻略
			//				{
			//					var discSrcArr:Array = new Array( config.getSample(i).cover, normalSource.disc, normalSource.discBG);
			//					var disc:DiscCover = new DiscCover(discSrcArr);
			//					contentLayout.add(disc);
			//					disc.data = config.getSample(i).url;
			//					disc.addEventListener(MouseEvent.CLICK,contentClickHandler);
			//					contentPannel.addChild(disc);
			//				}
			//			}
			
			
			initMask();
			
			///////////////////////////////////////////////////
			
			//			addChild(scaleSprite);	//暂时无用
			scaleSprite.x = 300;
			scaleSprite.addChild(scaleBitmap);
			
			///////////////////////
			addChild(contentSprite);
			
			//			trace("==contentPannel.width==contentPannel.width@@==",contentPannel.width);
			totalWidth = Math.ceil(loaderScenicList.getLength()/8) * 1000;
			var bgs:Sprite = new Sprite();
			bgs.graphics.beginFill(0xaa00ff,0);
			bgs.graphics.drawRect(0,100,totalWidth,508);
			bgs.graphics.endFill();
//			contentPannel.addChildAt(bgs,0);
		}
		private var totalWidth:int;	//字母查询的总宽度
		private function initMask():void
		{
			contentMask = new Shape();
			contentMask.graphics.beginFill(0xFFFFFF);
			contentMask.graphics.drawRect(25,0,1030,615);
			contentMask.graphics.endFill();
			this.addChild(contentMask);
			contentPannel.mask = contentMask;
			showMask = new Shape();
			showMask.graphics.beginFill(0xFFFFFF);
			showMask.graphics.drawRect(0,66,1080,680);
			showMask.graphics.endFill();
			this.addChild(showMask);
			contentSprite.mask = showMask;
		}
		
		private var scaleSprite:Sprite = new Sprite();
		private var scaleBitmap:Bitmap = new Bitmap();
		
		private var disk:DvdDisk;
		private var shape:Shape;
		
		private var contentSprite:Sprite = new Sprite();//用于装DM单 全攻略内容
		private var dmBtn:CButton;
		private var btn:DiscCover;
		private var currentUrl:String;
		private var loader:CLoader;
		
		private var currentType:String;
		/**
		 *加载显示DM单 
		 * @param event
		 * 
		 */		
		private function dmClickHandler(event:Event):void
		{
			
			dmBtn = event.currentTarget as CButton;
			currentUrl = dmBtn.data[1];
			Administrator.sendData(dmBtn.data[0]);
			if(!currentUrl)	return;
			currentType = "DM";
			maskShape.visible = true;
			DisplayObjectEffect.scale(dmBtn);
			
			if(currentObject)
			{
				currentObject.filters = null;
			}
			
			if (curDisc != null)
				curDisc.removeAnimation();
			
			clearContent();
			loader = new CLoader();
			trace("==dmBtn.data==",dmBtn.data,currentUrl.split(".")[1]);
			loader.load(currentUrl);
			if(scenicType == Const.RECOMMEND||(currentUrl.split("."))[1] == "xml")
			{
				loader.load(loaderScenicList.getRootAttribute("dmSwf"));
			}
			else
			{
				loader.load(currentUrl);
			}
			//			loader.load("E:/QuickWalkthrough/bin-debug/QuickWalkthrough.swf");
			loader.addEventListener(CLoader.LOADE_COMPLETE,dmOkHandler);
		}
		private function mobileClickHandler(event:MouseEvent):void
		{
			
		}
		private var background:Sprite;
		private var dataEvent:DataEvent;
		private function dmOkHandler(event:Event):void
		{
			//			var l:CLoader = event.target as CLoader;
			contentSprite.addChild(loader._loader);
			loader._loader.addEventListener(Event.REMOVED_FROM_STAGE,setItNull);
			loader._loader.y = 66;
			//			loader._loader.x = curContentPannelX;
			setTurnButton(true,0.5);
			//			s.focus = loader._loader;
			//			loader._loader.focusRect = null;
			
			if(scenicType == Const.RECOMMEND||(currentUrl.split("."))[1] == "xml")
			{
				if(dataEvent)
				{
					dataEvent = null;
				}
				dataEvent = new DataEvent(DataEvent.CLICK);
				dataEvent.data = currentUrl;
				Administrator.instance.dispatchEvent(dataEvent);
			}
			
		}
		private function mobileOkHandler(event:Event):void
		{
			contentSprite.addChild(loader._loader);
			loader._loader.addEventListener(Event.REMOVED_FROM_STAGE,setItNull);
//			loader._loader.y = 66;
			setTurnButton(true,0.5);
			
				if(dataEvent)
				{
					dataEvent = null;
				}
				dataEvent = new DataEvent(DataEvent.CLICK);
				dataEvent.data = currentUrl;
				Administrator.instance.dispatchEvent(dataEvent);
		}
		/**
		 *加载显示全攻略 
		 * @param event
		 * 
		 */		
		private function contentClickHandler(event:Event):void
		{
			btn = event.currentTarget as DiscCover;
			
			var arr:Array = btn.data;
			
			currentUrl = btn.data[1];
			Administrator.sendData(btn.data[0]);
			if(!currentUrl)	return;
			if(arr.length > 2)
			{
				currentType = "MB";
			}else{
				currentType = "QGL";
			}
			
			if(currentObject)
			{
				currentObject.filters = null;
			}
			
			isMoving = true;
			if(curDisc)
				curDisc.removeAnimation();
			
			var n:Point = contentPannel.localToGlobal(new Point(btn.x,btn.y));
			if(!disk)
			{
				disk = new DvdDisk(commonData.publicUrl+commonData.disc);
				s.addChild(disk);
				disk.addEventListener(Cevent.DISK_OUT_FIRSTEP_OVER,outFirstHandler);
				disk.addEventListener(Cevent.DISK_OUT_SECSTEP_OVER,outSecHandler);
				//			
				disk.addEventListener(Cevent.DISK_BACK_FIRSTEP_OVER,backFirstHandler);
				disk.addEventListener(Cevent.DISK_BACK_SECSTEP_OVER,diskBackHandler)
			}
			disk.x = n.x + 127;
			disk.y = n.y + 100;
			disk.visible = true;
			btn.move(false);
			ControlMove.beginMove(disk,192);
			if(!shape)
			{
				shape = new Shape();
				shape.graphics.beginFill(0xaacc00);
				shape.graphics.moveTo(0,32);
				shape.graphics.lineTo(0,113);
				shape.graphics.curveTo(5,140,32,145);
				shape.graphics.lineTo(62,145);
				shape.graphics.lineTo(62,175);
				shape.graphics.lineTo(1100,175);
				shape.graphics.lineTo(1100,-30);
				shape.graphics.lineTo(62,-30);
				shape.graphics.lineTo(62,0);
				shape.graphics.lineTo(32,0);
				shape.graphics.curveTo(5,5,0,32);
				shape.graphics.endFill();
				s.addChild(shape);
			}
			disk.mask = shape;
			shape.y = n.y + 28;
			shape.x = n.x +150;
			
			maskShape.visible = true;	//当蝶片运动时禁止一切活动
			
			//			trace("btn.x,btn.width=",btn.x,btn.y,"**n.x n.y=",n.x,n.y,"**disk.x=",disk.x,disk.y,"*shape.x=",shape.x,shape.y)
			//			var config:BaseConfig = new BaseConfig(btn.data);
			//			var bookData:BookData = config.getSampleById(3) as BookData;
			//			var book:Book = new Book(bookData);
			//			addChild(book);
			//			var data:LetterSearchData = config.getSample(btn.data) as LetterSearchData;
		}
		private function outFirstHandler(event:Event):void
		{
			trace("out fir event..");
			shape.visible = false;
			//			var o:DisplayObject = event.currentTarget as DisplayObject;
			//			o.mask = null;
			disk.mask = null;
		}
		private function outSecHandler(event:Event):void
		{
			trace("out sec event..");
			clearContent();
			
			loader = new CLoader();//加载全攻略
			if(currentType == "MB")
			{
				loader.load("source/mobileSwf/SpotGuide.swf");
				loader.addEventListener(CLoader.LOADE_COMPLETE,mobileOkHandler);
				
			}else{
				loader.load(currentUrl);
				loader.addEventListener(CLoader.LOADE_COMPLETE,qglOkHandler);
			}
		}
		private function clearContent():void
		{
			while(contentSprite.numChildren)
			{
				contentSprite.removeChildAt(0);
			}
		}
		private function qglOkHandler(event:Event):void
		{
			//			var l:CLoader = event.target as CLoader;
			//			showDisk(false);
			disk.visible = false;
			maskShape.visible = false;
			contentSprite.addChild(loader._loader);
			loader._loader.addEventListener(Event.REMOVED_FROM_STAGE,setItNull);
			loader._loader.y = 66;
			//			loader._loader.x = curContentPannelX;
			setTurnButton(true,0.5);
		}
		private function setItNull(event:Event):void
		{
			loader._loader.removeEventListener(Event.REMOVED_FROM_STAGE,setItNull);
			loader._loader = null;
			loader = null;
			
			trace("==DM OR QGL SET NULL。。。");
		}
		/**
		 *DISK 飞回卡片 
		 * @param event
		 * 
		 */		
		private function diskBackHandler(event:Event):void
		{
			trace("back fir event..");
			showDisk(false);
			btn.move(true);
			
			isMoving = false;
			//			var o:DisplayObject = event.currentTarget as DisplayObject;
			//			o.mask = shape;
		}
		private function showDisk(b:Boolean=true):void
		{
			disk.visible = b;
			shape.visible = b;
			maskShape.visible = b;
		}
		private function backFirstHandler(event:Event):void
		{
			trace("back sec event..");
			shape.visible = true;
			disk.mask = shape;
		}
		
		private function scaleXYHandler(event:Event):void
		{
			
		}
		
		/**
		 *初始化翻页按钮
		 */
		private function initPageTurningBtn():void
		{
			var n:Array = commonData.turnPage.split(",");
			
			
			var btnLoader:CLoaderMany = new CLoaderMany();
			btnLoader.load(StringSlice.addString(n,commonData.publicUrl,2));
			btnLoader.addEventListener(CLoader.LOADE_COMPLETE,btnLoadHandler);
		}
		
		private function btnLoadHandler(event:Event):void
		{
			var ll:CLoaderMany = event.currentTarget as CLoaderMany;
			var btnNext:SimpleButton = new SimpleButton();
			btnNext.upState = ll._loaderContent[0];
			btnNext.downState = ll._loaderContent[1];
			btnNext.overState = btnNext.upState;
			btnNext.hitTestState = btnNext.upState;
			btnNext.x = 1042;
			btnNext.y = 320;
			btnNext.addEventListener(MouseEvent.CLICK, nextBtnClickHandler);
			this.addChild(btnNext);
			
			var btnPrev:SimpleButton = new SimpleButton();
			btnPrev.upState = ll._loaderContent[2];
			btnPrev.downState = ll._loaderContent[3];
			btnPrev.overState = btnPrev.upState;
			btnPrev.hitTestState = btnPrev.upState;
			btnPrev.x = 5;
			btnPrev.y = 320;
			btnPrev.addEventListener(MouseEvent.CLICK, prevBtnClickHandler);
			this.addChild(btnPrev);
			
			turnPageBtnArr.push(btnNext);
			turnPageBtnArr.push(btnPrev);
		}
		private var turnPageBtnArr:Array = [];	//存放翻页按钮
		private var isMoving:Boolean = false;
		/**
		 *设置左右翻页按钮是否可点击 
		 * 
		 */		
		private function setTurnButton(bb:Boolean,a:int=1):void
		{
			for each(var b:SimpleButton in turnPageBtnArr)
			{
				b.mouseEnabled = !bb;
				b.enabled = !bb;
				b.alpha = a;
			}
		}
		private var nextPage:Boolean = true;
		private var curContentPannelX:int = 0;
		private function nextBtnClickHandler(event:MouseEvent):void
		{
			curContentPannelX = contentPannel.x;
			
			if(Math.abs(curContentPannelX-PAGE_WIDTH) >= totalWidth)
			{
				//				return;
				curContentPannelX = contentPannel.x = 1000;
			}
			
			nextPage = true;
			endX = curContentPannelX-PAGE_WIDTH;
			isMoving = true;
			setTurnButton(isMoving);
			this.addEventListener(Event.ENTER_FRAME, pageTurningHandler);
			//			contentMask.x += PAGE_WIDTH;
		}
		private var endX:Number;
		private function prevBtnClickHandler(event:MouseEvent):void
		{
			curContentPannelX = contentPannel.x;
			
			if (curContentPannelX == 0)
			{
				//				return;
				curContentPannelX = contentPannel.x = -totalWidth;
			}
			nextPage = false;
			endX = curContentPannelX+PAGE_WIDTH;
			isMoving = true;
			setTurnButton(isMoving);
			this.addEventListener(Event.ENTER_FRAME, pageTurningHandler);
			//			contentMask.x -= PAGE_WIDTH;
		}
		
		/**
		 *翻页动画
		 */
		private function pageTurningHandler(event:Event):void
		{
			if (nextPage) 
			{
				
				contentPannel.x -= Math.abs(endX - contentPannel.x)*0.3;
				
				if(Math.abs(endX - contentPannel.x)<1)
				{
					contentPannel.x = endX;
					this.removeEventListener(Event.ENTER_FRAME,pageTurningHandler);
					curContentPannelX = endX;
					if(scenicType == Const.SEARCH)
					{
						resetSelLetter();
					}
					isMoving = false;
					setTurnButton(isMoving);
					
				}
				//				if(contentPannel.x == endX)
				//				{
				//				}
			}
			else
			{
				
				
				contentPannel.x += Math.abs(contentPannel.x - endX)*0.3;
				if(Math.abs(endX - contentPannel.x)<1)
				{
					contentPannel.x = endX;
					this.removeEventListener(Event.ENTER_FRAME,pageTurningHandler);
					curContentPannelX = endX;
					if(scenicType == Const.SEARCH)
						resetSelLetter();
					
					isMoving = false;
					setTurnButton(isMoving);
					
				}
				//				if (endX == 0)
				//				{
				//					contentLayout.resetPosition(0);
				////					contentPannel.x = 0;
				////					this.removeEventListener(Event.ENTER_FRAME,pageTurningHandler);
				////					resetSelLetter();
				////					return;
				//				}
				//				if(contentPannel.x == endX)
				//				{
				//				}
			}
		}
		
		/**
		 *翻页后设置当前景点所在首字母
		 */
		private function resetSelLetter():void
		{
			curSid = nextPage ? curSid+ITEM_NUM_PER_PAGE : curSid-ITEM_NUM_PER_PAGE;
			//			if (curSid < 0)
			//				curSid = 0;
			if(curSid>loaderScenicList.getLength())
			{
				curSid = 0;
			}
			if(curSid<0)
			{
				curSid =Math.floor(loaderScenicList.getLength()/ITEM_NUM_PER_PAGE)*ITEM_NUM_PER_PAGE;
			}
			
			discAnimation();
			
			var group:String = (loaderScenicList.getDataById(curSid) as LetterSearchData).group;
			var index:int = Const.LETTERS.search(group);
			trace(letterGroup.getItmeArr().length);
			letterGroup.setItemSelected(index);
		}
		
		/**
		 *碟片依次转动动画
		 */
		private var discSidArr:Array = new Array();
		private var t:Timer=new Timer(5000); 
		private var curDisc:DiscCover = null;
		private var curIndex:int = 0;
		private function discAnimation():void
		{
			discSidArr.splice(0, discSidArr.length);
			if (curDisc != null)
				curDisc.removeAnimation();
			
			curIndex = 0;
			t.stop();
			t.removeEventListener (TimerEvent.TIMER, animation); 
			
			for (var i:int=curSid; i<ITEM_NUM_PER_PAGE+curSid; i++)
			{
				trace("==contentLayout.length()==contentLayout.length()=",contentLayout.length(),i);
				if (i >= contentLayout.length())
					break;
				
				var data:LetterSearchData = loaderScenicList.getDataById(i) as LetterSearchData;
				if (data == null)
					break;
				
				if (data.type == "disc" || data.type == "mobile")
					discSidArr.push(i);
			}
			
			if (discSidArr.length != 0)
			{
				t.addEventListener (TimerEvent.TIMER, animation); 
				t.start ();
			}
		}
		
		private function animation(_evt:TimerEvent):void
		{
			if (curDisc != null)
				curDisc.removeAnimation();
			
			if (curIndex == discSidArr.length)
				curIndex = 0;
			
			var disc:DiscCover = contentLayout.getItem(discSidArr[curIndex]) as DiscCover;
			curDisc = disc;
			disc.animation(isMoving);
			
			curIndex++;
		}
		
		/**
		 *删除事件，释放资源
		 */
		private function destroy(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, pageTurningHandler);
			
			t.stop();
			t.removeEventListener (TimerEvent.TIMER, animation); 
			t = null;
			
			discSidArr = null;
		}
		
		private function addRemoveListener():void
		{
			var sjarr:Array = ["tgcy2Event","tjh2Event","taopingqiangzhai2","ttsEvent","tzs2Event","wccEvent","whcEvent","wxh2Event","xlxsEvent","xdqEvent","xls2Event","yylsbwg2Event",
				"yzg2Event","ybgz2Event","ywg2Event","yls2Event","zjs2Event","zdqjng2Event","zhgc2Event",
				"zfs2Event","zgsh2Event","zhzljgy2","zdgl2Event","zkjgz2Event","zgklbwg2Event","regEvent",
				"sch2Event","sshx2Event","ssc2Event","sxdEvent","sl2Event","sml2Event","shdx2Event",
				"sxhEvent","smgz2Event","snzhEvent","scbwy2Event","scscbwg2Event","sgnsEvent","mds2Event","mznhc2Event",
				"myx2Event","mgcEvent","nkcEvent","nsh2Event","pzs2Event","plgzEvent","qfy2Event","qcsEvent",
				"qygEvent","qhlsEvent","qqs2Event","lsdfEvent","lbjng2Event","lqs2Event","lys2Event",
				"ljgz2Event","lszyEvent","lzgz2Event","lfgz2Event","ltrd2Event","lghEvent","ldgz2Event",
				"ljs2Event","lzljgbjc2Event","jjzz2Event","jcbwg2Event","jmgEvent","jdhysj2Event",
				"jzgz2Event","jhs2Event","jsyzEvent","jhsywd2Event","jzgEvent","kzxzEvent","lbh2","lms2Event",
				"lzgcEvent","guchengshan123","guosetianxiang","hlg1Event","hjd2Event","hk2Event","hhdyw2",
				"huang1long2","hlxEvent","hzs2Event","hlgEvent","hwrj2Event","hys2Event","hlgc2Event",
				"aysk2Event","bfs2Event","bggh2Event","bfxEvent","cddxEvent","cygl2","cch2Event","cyl2Event",
				"dysh2Event","dcydEvent","dxpgl2Event","dhkdzgy2Event","dls2Event","dzth2Event","dcs2",
				"dfctEvent","djyEvent","dhkdzyzgy2Event","emeishan2","fs2Event","fybly2Event","fbgz2Event","gfs2Event",
				"gsl2Event","gds2Event","gws2Event"];
			for each(var estr:String in sjarr)
			{
				this.addEventListener(estr,clearQglHandler);
			}
			this.addEventListener(Cevent.SCENIC_PAGE_BACK,clearQglHandler);
		}
	}
}