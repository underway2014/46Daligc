package core.component.homePage
{
	import core.admin.Administrator;
	import core.baseComponent.CButton;
	import core.baseComponent.CSprite;
	import core.baseComponent.CVideo;
	import core.baseComponent.CZoomMoveClip;
	import core.config.MapPgeData;
	import core.config.PublicData;
	import core.filter.CFilter;
	import core.layout.Manager;
	import core.loadEvents.CLoader;
	import core.loadEvents.CLoaderMany;
	import core.loadEvents.CXmlLoader;
	import core.loadEvents.Cevent;
	import core.math.MathMethod;
	import core.memefree.GC;
	import core.string.StringSlice;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class MapPage extends Sprite
	{
		private var xmlLoader:CXmlLoader;
		
		private var publicData:PublicData;
		private var ctrlBtnWidth:int = 37;
		private var ctrlBtnHeight:int = 66;
		private var threeSprite:Sprite = new Sprite();//装三级页面
		
		private var mapSprite:Sprite = new Sprite();
		/**
		 * 
		 * @param xmlUrl
		 * @param publicData
		 * 
		 */		
		public function MapPage(xmlUrl:String, publicData:PublicData)
		{
			super();
			
			this.publicData = publicData;
			
			xmlLoader = new CXmlLoader();
			xmlLoader.loader(xmlUrl);
			xmlLoader.addEventListener(CXmlLoader.LOADER_COMPLETE,xmlOkHandler);
		}
		private var mapPageData:MapPgeData;
		private var bgArr:Array;
		private function xmlOkHandler(event:Event):void
		{
			mapPageData = xmlLoader.getDataById(0) as MapPgeData;
//			loader = new CLoader();
			bgArr = StringSlice.addString(mapPageData.backGround.split(","),mapPageData.mainurl,2);
			
			bitmapArr.push(smallSprite);
			bitmapArr.push(bigSprite);
			
			mapSprite.addChild(bigSprite);
			mapSprite.addChild(smallSprite);
			
			addChild(mapSprite);
			addChild(tipMapSprite);
			tipMapSprite.addChild(tipBitmap);
			tipMapSprite.visible = false;
			tipMapSprite.addEventListener(MouseEvent.CLICK,changeViewHandler);
			
			timer.addEventListener(TimerEvent.TIMER,loadBackgroundHandler);
			timer.start();
		}
		private var role:Sprite;
		private var tipBitmap:Bitmap = new Bitmap();
		private var timer:Timer = new Timer(10,2);
		private function loadBackgroundHandler(event:TimerEvent):void
		{
			
			var loader:CLoaderMany = new CLoaderMany();
			
			if(timer.currentCount == 1)
			{
				loader.load([bgArr[0]]);
				loader.addEventListener(CLoaderMany.LOADE_COMPLETE,smallOkHandler);
			}
			else
			{
				loader.load([bgArr[1]]);
				loader.addEventListener(CLoaderMany.LOADE_COMPLETE,bigOkHandler);
				timer.removeEventListener(TimerEvent.TIMER,loadBackgroundHandler);
			}
		}
		private var bitmap:Bitmap;
		private var bd:BitmapData;
		private var bitmapArr:Array = [];
		
		private var btnArr:Vector.<CButton> = new Vector.<CButton>();
		private var bigSprite:Sprite = new Sprite();
		private var smallSprite:Sprite = new Sprite();
		private var tipMapSprite:Sprite = new Sprite();
		private var btnCtrlArr:Vector.<Sprite> = new Vector.<Sprite>();
		private function smallOkHandler(event:Event):void
		{
			var l:CLoaderMany = event.target as CLoaderMany;
			smallSprite.addChild(l._loaderContent[0]);
			
			backBtn = new CButton([publicData.backButton,publicData.backButton],false);
			backBtn.y = 550;
			backBtn.x = 950;
			backBtn.visible = false;
			backBtn.addEventListener(MouseEvent.CLICK,backVideoHandler);
			var btnArr:Array = StringSlice.addString(mapPageData.videoButton.split(","),mapPageData.mainurl,2);
			var videoButton:CButton = new CButton(btnArr,false);
			videoButton.y = publicData.zoomPos.y;
			videoButton.data = [mapPageData.mainurl + mapPageData.videoUrl,"古城一日游"];
			videoButton.addEventListener(MouseEvent.CLICK,showVideoHandler);
//			addChild(videoButton);
			videoSprite = new Sprite();
			videoSprite.addChild(backBtn);
			
			tipLoader =new CLoaderMany();
			tipLoader.load([mapPageData.mainurl+mapPageData.tipMap,mapPageData.mainurl+mapPageData.tipRect]);
			tipLoader.addEventListener(CLoaderMany.LOADE_COMPLETE,tipMapOkHandler);
			
			this.addChild(buttonBgSprite);
			this.addChild(videoSprite);
			
		}
		private var tipLoader:CLoaderMany;
		private function tipMapOkHandler(event:Event):void
		{
//			tipLoader._loaderContent[0].width = 216;
//			tipLoader._loaderContent[0].height = 121;
//			var tipBitmapData:BitmapData = new BitmapData(216,121);
//			tipBitmapData.draw(tipLoader._loaderContent[0]);
//			tipBitmap.bitmapData = tipBitmapData;
//			tipBitmap.alpha = 0.8;
			
			tipMapSprite.addChild(tipLoader._loaderContent[0]);
			tipPoint = new Point(tipLoader._loaderContent[0].width,tipLoader._loaderContent[0].height);
			
			
			role = new Sprite();
			role.addChild(tipLoader._loaderContent[1]);
			role.x = tipPoint.x/2 - role.width/2;
			role.y = tipPoint.y/2 - role.height/2;
			tipMapSprite.x = 1080 - tipPoint.x - 10;
			tipMapSprite.y = 608 - 185;
			tipMapSprite.addChild(role);
		}
		private var tipPoint:Point;	//存放小地图宽高，以防生变
		private function bigOkHandler(event:Event):void
		{
			var lb:CLoaderMany = event.target as CLoaderMany;
			
			var bigBitmap1:Bitmap = new Bitmap();
			var bd1:BitmapData = new BitmapData(lb._loaderContent[0].width,lb._loaderContent[0].height);
			bd1.draw(lb._loaderContent[0]);
			bigBitmap1.bitmapData = bd1;
	
//			var bigBitmap:Bitmap = new Bitmap();
//			var bd:BitmapData = new BitmapData(lb._loaderContent[1].width,lb._loaderContent[1].height);
//			bd.draw(lb._loaderContent[1]);
//			bigBitmap.bitmapData = bd;
//			bigBitmap.x = bigBitmap1.width;
			
//			bigSprite.addChild(bigBitmap);
			bigSprite.addChild(bigBitmap1);
			lb._loaderContent[0].unload();
			lb._loaderContent[0] = null;
//			lb._loaderContent[1] = null;
			
//			lb.clear();
//			(lb._loaderContent[0].content as Bitmap).bitmapData.dispose();
//			(lb._loaderContent[1].content as Bitmap).bitmapData.dispose();
//			bigSprite.addChild(lb._loaderContent[0]);
//			bigSprite.addChild(lb._loaderContent[1]);
//			lb._loaderContent[1].x = lb._loaderContent[0].width;
			
			
			var btnArr:Array =  mapPageData.buttonArr.split(",");
			StringSlice.addString(btnArr,mapPageData.mainurl,2);
			
			coordArr = StringSlice.getPointArr(mapPageData.coorArr,"$",",");
			urlArr = StringSlice.addString(mapPageData.urlArr.split(","),mapPageData.mainurl,2);
			
			videoName = mapPageData.name.split(",");
			
//			btnLoader = new CLoaderMany();
//			btnLoader.load(btnArr);
//			btnLoader.addEventListener(CLoaderMany.LOADE_COMPLETE,btnOkHandler);
			
			
			/////
			var controlUrls:Array = publicData.controlUrls.split(',');
			var arrZoom:Array = [controlUrls[0], controlUrls[1]];
			zoomMC = new CZoomMoveClip(arrZoom, publicData.zoomPos);
			zoomMC.addEventListener(MouseEvent.CLICK,changeMap);
			buttonBgSprite.addChild(zoomMC);
			/////
			
//			var testBtn:CLoader = new CLoader();
//			testBtn.load("source/yunnan/main/homepage/lijianggucheng/yhms.png");
//			testBtn.addEventListener(CLoader.LOADE_COMPLETE,testOkHandler);
			
			nameCoor = StringSlice.getPointArr(mapPageData.nameCoor,"$",",");
			var titleUrlarr:Array = mapPageData.buttonNmae.split(",");
			StringSlice.addString(titleUrlarr,mapPageData.mainurl,2);
			
			i = 0;
			var nameButton:CButton;
//			for each(var url:String in titleUrlarr)
//			{
//				nameButton = new CButton([url],false);
//				nameButton.data = [urlArr[i],videoName[i]];
//				bigSprite.addChild(nameButton);
//				nameButton.x = nameCoor[i].x;
//				nameButton.y = nameCoor[i].y;
//				nameButton.addEventListener(MouseEvent.CLICK,showVideoHandler);
//				i++;
//			}
			
		}
		private function initTitle():void
		{
			
		}
		private var btnLoader:CLoaderMany;
		private var titleLoader:CLoaderMany;
		private var coordArr:Vector.<Point>;
		private var nameCoor:Vector.<Point>;
		private var urlArr:Array = [];
		private var videoName:Array = [];
		private var manger:Manager = new Manager();
//		private var videoSprite:Sprite = new Sprite();
		private function btnOkHandler(event:Event):void
		{
			var scenicSprite:CSprite;
			var i:int;
			
			for each(var l:Loader in btnLoader._loaderContent)
			{
				scenicSprite = new CSprite();
				scenicSprite.x = coordArr[i].x;//774
				scenicSprite.y = coordArr[i].y;
				
				scenicSprite["data"] = [urlArr[i],videoName[i]];
				scenicSprite.addChild(l);
				scenicSprite.filters = CFilter.blueYellowFilter;
				
				i++;
				
				scenicSprite.addEventListener(MouseEvent.CLICK,showVideoHandler);
				manger.add(scenicSprite);
				bigSprite.addChild(scenicSprite);
//				l = null;
			}
//			btnLoader.clear();
			GC.gc();
//			btnLoader = null;
			
//			bigSprite.scaleX = bigSprite.scaleY = 0.6;
			
			var controlUrls:Array = publicData.controlUrls.split(',');
			var arrZoom:Array = [controlUrls[0], controlUrls[1]];
			zoomMC = new CZoomMoveClip(arrZoom, publicData.zoomPos);
			zoomMC.addEventListener(MouseEvent.CLICK,changeMap);
			buttonBgSprite.addChild(zoomMC);
			
			var arr:Array = MathMethod.randomArr(manger.getItemArr().length);
			sonArr = MathMethod.sliceArr(arr,6);
			trace(sonArr[0],"**",sonArr[1],"**",sonArr[1],"*",sonArr[2],"**",sonArr[3]);
			timerShowFilter.addEventListener(TimerEvent.TIMER,showFilter);
//			timerShowFilter.start();
			
			
		}
		
		private var sonArr:Array = [];
		private var timerShowFilter:Timer = new Timer(100);
		private var i:uint = 0;
		private function showFilter(event:TimerEvent):void
		{
			if(i>sonArr.length-1)
			{
				i = 0;
			}
			trace("sonArr[",i,"]=",sonArr[i]);
			for(var j:int = 0;j<sonArr[i].length;j++)
			{
				
				var s:Sprite = manger.getItemArr()[sonArr[i][j]] as Sprite;
				if(s.filters.length)
				{
					s.filters = [];
					s.filters = null;
				}
				else
				{
					s.filters = CFilter.blueYellowFilter;
				}
			}
			i++;
		}
		
		private function scenicPlayOverHandler(event:Event):void
		{
			
		}
		private function removeHandler(event:Event):void
		{
			
		}
		private function testOkHandler(event:Event):void
		{
//			var l:CLoader = event.target as CLoader;
//			
//			var tSprite:Sprite = new Sprite();
//			tSprite.addChild(CBitmap.getBitmap(l._loader));
//			l._loader = null;
//			addChild(tSprite);
//			tSprite.filters = CFilter.glowFilter;
//			tSprite.addEventListener(MouseEvent.ROLL_OVER,testOverHandler);
//			tSprite.addEventListener(MouseEvent.ROLL_OUT,testOutHandler);
		}
		private function testOverHandler(event:MouseEvent):void
		{
			trace("Mouse over now...");
		}
		private function testOutHandler(event:MouseEvent):void
		{
			trace("Mouse out now...");
		}
		private var backBtn:CButton;
		private var videoSprite:Sprite;
		private var video:CVideo;
		public var isPlaying:Boolean;
		private function showVideoHandler(event:MouseEvent):void
		{
			var s:* = event.currentTarget;
			backBtn.visible = true;
			isPlaying = true;
			video = new CVideo();
			video.addEventListener(Event.REMOVED_FROM_STAGE,closeStreamHandler);
			video.addEventListener(CVideo.VIDEO_PLAY_OVER,playOverHandler);
			video.url = (s["data"])[0];
			videoSprite.addChildAt(video,0);
			dispatchEvent(new Event("soundoff",true));
			Administrator.sendData((s["data"])[1]);
		}
		private function playOverHandler(event:Event):void
		{
			backBtn.visible = false;
			isPlaying = false;
			trace("in home play over...");
			videoSprite.removeChild(video);
//			video = null;
			Administrator.instance.dispatchEvent(new Event(Cevent.VIDEO_SOUND_OPEN));
		}
		private function closeStreamHandler(event:Event):void
		{
			
			video.close();
			isPlaying = false;
			video.removeEventListener(Event.REMOVED_FROM_STAGE,closeStreamHandler);
			video.removeEventListener(CVideo.VIDEO_PLAY_OVER,playOverHandler);
			video = null;
			backBtn.visible = false;
			dispatchEvent(new Event("soundon",true));
		}
		public function backVideoHandler(event:MouseEvent):void
		{
			videoSprite.removeChild(video);
		}

		private function createCtrlBtn():void
		{
			var btnCtrl:Sprite;
			for(var i:int=0;i<4;i++)
			{
				btnCtrl = new Sprite();
				btnCtrl.graphics.beginFill(0x000000);
				btnCtrl.graphics.drawRect(0,0,(i==0 || i==1)?ctrlBtnHeight:ctrlBtnWidth,(i==0 || i==1)?ctrlBtnWidth:ctrlBtnHeight);
				btnCtrl.graphics.endFill();
				this.addChild(btnCtrl);
				btnCtrl.x = publicData.getCtrlBtnsPos()[i].x;
				btnCtrl.y = publicData.getCtrlBtnsPos()[i].y;
				btnCtrl.visible = false;
				btnCtrl.alpha = 0;
				btnCtrl.buttonMode = true;
				btnCtrl.addEventListener(MouseEvent.CLICK,mapMoveHandler);
				btnCtrlArr.push(btnCtrl);
			}
		}
		
		private function mapMoveHandler(event:MouseEvent):void
		{
			var i:int = 1;
			var b:Sprite = event.currentTarget as Sprite;
			for each(var s:Sprite in btnCtrlArr)
			{
				if(b == s)
				{
					switch(i)
					{
						case 1:
							mapSprite.y +=  200;
							break;
						case 2:
							mapSprite.y -=  200;
							break;
						case 3:
							mapSprite.x +=  300;
							break;
						case 4:
							mapSprite.x -=  300;
							break;
					}
					checkImage();
					break;
				}
				i++;
			}
		
		}
		
		private function checkImage():void
		{
			//判断坐标是否出界
			if (mapSprite.y < -608)
			{
				mapSprite.y = -608;
			}
			if (mapSprite.x < -1080)
			{
				mapSprite.x = -1080;
			}
			if (mapSprite.y > 0)
			{
				mapSprite.y = 0;
			}
			if (mapSprite.x > 0)
			{
				mapSprite.x = 0;
			}
		}
		
		private var buttonBgSprite:Sprite = new Sprite();
		private var controlLoader:CLoader;
		private function controlOkHander(event:Event):void
		{
			trace("control ok....");
			buttonBgSprite.addChild(controlLoader._loader);
			controlLoader._loader.x = publicData.controlPos.x;
			controlLoader._loader.y = publicData.controlPos.y;
		}

		private var nameLoader:CLoader;
		private function nameOkHandler(event:Event):void
		{
			this.addChild(nameLoader._loader);
			nameLoader._loader.y = 24;
			
			threeSprite.alpha = 0.8;
			this.addChild(threeSprite);
		}
		
		private var currentState:Boolean;  //true:zoomIn  false:ZoomOut
		private var zoomMC:CZoomMoveClip;
		private function changeMap(event:MouseEvent):void
		{
			if(bitmapArr.length<2)
			{
				trace("mapSprite.numChildren=",bitmapArr.length);
				return;
			}
//			if(currentState)
//			{
//				timerShowFilter.stop();
//			}
//			else
//			{
//				timerShowFilter.start();
//			}
			currentState = !currentState;
			changeVision(currentState);
			
			zoomMC.changeZoomType(!currentState);
			
//			for each(var s:Sprite in btnCtrlArr)
//			{
//				s.visible = currentState;
//			}
		}
		public function resetState(b:Boolean = true):void
		{
			if(currentState)
			changeMap(null);
		}
		private var l:CLoaderMany;
		private function clickHandler(event:MouseEvent):void
		{
			var curBtn:CButton = event.currentTarget as CButton;

			trace("second click..");
			trace("click////",curBtn.data);
			l = new CLoaderMany();
			l.load(new Array(curBtn.data));
			l.addEventListener(CLoader.LOADE_COMPLETE,openThreePageHandler);
		}
		private function openThreePageHandler(event:Event):void
		{	
			clearThreeSprite();
			trace("===open three page===");
			threeSprite.addChild(l._loaderContent[0]);
		}
		
		private var beginPoint:Point = new Point();

		public function changeVision(b:Boolean):void
		{
			bitmapArr[0].visible = !b;
			bitmapArr[1].visible = b;
			tipMapSprite.visible = b;
			
			if(b)
			{
				beginPoint.x = mapSprite.x = (1080-bitmapArr[1].width)/2;
				beginPoint.y = mapSprite.y = (608-bitmapArr[1].height)/2;
				
				mapSprite.addEventListener(MouseEvent.MOUSE_DOWN,mapDragHandler);
				mapSprite.addEventListener(MouseEvent.MOUSE_UP,mapStopHanndler);
			}
			else
			{
//				bitmapArr[0].x = 0;
//				bitmapArr[0].y = 0;
				mapSprite.x = 0;
				mapSprite.y = 0;
				trace("===set 00000=====");
				mapSprite.removeEventListener(MouseEvent.MOUSE_DOWN,mapDragHandler);
				mapSprite.removeEventListener(MouseEvent.MOUSE_UP,mapStopHanndler);
				mapStopHanndler(null);
				
			}
		}
		private function changeViewHandler(event:MouseEvent):void
		{
			mapSprite.x = -(mapSprite.width - 1080)*tipMapSprite.mouseX/tipPoint.x;
			mapSprite.y = -(mapSprite.height - 608)*tipMapSprite.mouseY/tipPoint.y;
			roleWalkHandler(null);
		}
		private function roleWalkHandler(event:Event):void
		{
			role.x =tipPoint.x/2 - role.width/2 + (tipPoint.x - role.width)*((beginPoint.x - mapSprite.x)/(mapSprite.width - 1080));
			trace("XY====",mapSprite.x,mapSprite.y,beginPoint);
			role.y =tipPoint.y/2 - role.height/2 + (tipPoint.y - role.height)*((beginPoint.y - mapSprite.y)/(mapSprite.height - 608));
		}
		private function mapDragHandler(event:MouseEvent):void
		{
			role.addEventListener(Event.ENTER_FRAME,roleWalkHandler);
			trace("===bitmapArr[1].width===",bitmapArr[1].width,bitmapArr[1].height);
			mapSprite.startDrag(false,new Rectangle(1080-bitmapArr[1].width,608-bitmapArr[1].height,bitmapArr[1].width-1080,bitmapArr[1].height-608));
		}
		
		private function mapStopHanndler(event:MouseEvent):void
		{
			role.removeEventListener(Event.ENTER_FRAME,roleWalkHandler);
			mapSprite.stopDrag();
		}
		
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				if (currentState)
				{
					changeMap(null);
				}
				else
				{
					trace("back");
					dispatchEvent(new Event("backToHomeEvent",true));
					this.parent.removeChild(this);
				}
				
				clearThreeSprite();
			}
		}
		
		private function homeHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				trace("home");
				dispatchEvent(new Event("backToHomeEvent",true));
				this.parent.removeChild(this);
				clearThreeSprite();
			}
		}
		
		private function clearThreeSprite():void
		{
			var i:int = 0;
			while(threeSprite.numChildren)
			{
				var mc:MovieClip = threeSprite.getChildAt(i) as MovieClip;
				threeSprite.removeChildAt(i);
				mc = null;
				i++;
				
				trace("clear three sprite child", i);
			}
		}
	}
}