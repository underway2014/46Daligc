package core.component.homePage
{
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.admin.Administrator;
	import core.baseComponent.BackButton;
	import core.baseComponent.CVideo;
	import core.component.buttonBar.ButtonBar;
	import core.component.letterSearch.LetterSearchPage;
	import core.config.HomePageData;
	import core.config.PublicData;
	import core.constant.Const;
	import core.interfaces.ClearAll;
	import core.loadEvents.CLoader;
	import core.loadEvents.CLoaderMany;
	import core.loadEvents.CXmlLoader;
	import core.loadEvents.Cevent;
	import core.loadEvents.DataEvent;
	import core.memefree.GC;
	import core.timer.TimerDevice;
	
	/**
	 *首页 
	 * @author bin.li
	 * 
	 */	
	public class HomePage extends Sprite implements ClearAll
	{
		private var frameLoader:CXmlLoader;	//整个框架的主要XML LIST
		private var frameXmlUrlArr:Array;	//存放各个模块对应的XMLLIST 的路径
		private var s:Stage;
		
		
		/**
		 * 
		 * @param _s
		 * 
		 */
		public function HomePage(_s:Stage,xmlloader:CXmlLoader)
		{
			super();
			frameLoader = xmlloader;
			frameXmlUrlArr = frameLoader.parseXmlList();

			loadConfig();
			s = _s;

			/*
			 *内部DM单OR 全攻略放视频时 
			*/
			this.addEventListener("soundoff",topCloseSoundHandler);
			this.addEventListener("soundon",topSoundOpenHandler);
			this.addEventListener(Cevent.XML_LOAD_COMPLETE, xmlLoadOKHandler);
			
			s.addEventListener(MouseEvent.MOUSE_DOWN,stageClickHandler);		//检测是否有人操作
		
		}
		private var homeListLoader:CXmlLoader;//加载首页配置文件
		private function loadConfig():void
		{
			trace(frameLoader.getUrlByName("mainXml"));
			homeListLoader = new CXmlLoader();
			homeListLoader.loader(frameLoader.getUrlByName("mainXml"));	//加载首页LIST XML
//			homeLoader.loader(["source/data/sichuan/source/xmlData/homePage.xml"]);
			homeListLoader.addEventListener(CXmlLoader.LOADER_COMPLETE,homeListOkHandler);
			
		}
		private var homeLoader:CXmlLoader;
		private function homeListOkHandler(event:Event):void
		{
			trace(homeListLoader.parseXmlList());
			homeLoader = new CXmlLoader();
			homeLoader.loader(homeListLoader.getUrlByName("homepage"));
			homeLoader.addEventListener(CXmlLoader.LOADER_COMPLETE,homeOkHandler);
		}
		private var publicSrcLoader:CXmlLoader;
		private function homeOkHandler(event:Event):void
		{
			homeData = homeLoader.getDataById(2) as HomePageData;
			publicSrcLoader = new CXmlLoader();
			publicSrcLoader.loader(homeListLoader.getUrlByName("public_source"));
			publicSrcLoader.addEventListener(CXmlLoader.LOADER_COMPLETE,publicSrcOkHandler);
			
			trace("homeData==",homeData.oneMinuteUrl,homeData.jjbtn);
		}
		
		private function publicSrcOkHandler(event:Event):void
		{
			publicData = publicSrcLoader.getDataById(0) as PublicData;
				
			initTop();
			initMiddleBG();
//	
			checkTime();
		}
		
		private function stageClickHandler(event:MouseEvent):void
		{
			trace("stage has been click...");
			TimerDevice.resetTime();
		}
		private function topCloseSoundHandler(event:Event):void
		{
			trace("get trace sound off ha");
			checkTimes = Const.TOTAL_BACK_LONG_TIME;
			Administrator.instance.dispatchEvent(new Event(Cevent.VIDEO_SOUND_CLOSE));
		}
		private function topSoundOpenHandler(event:Event):void
		{
			trace("get trace sound on");
			checkTimes = Const.TOTAL_BACK_SHORT_TIME;
			Administrator.instance.dispatchEvent(new Event(Cevent.VIDEO_SOUND_OPEN));
		}
		private var nowY:Number = 0;
		
		private var advertiseSprite:Sprite;	//播放下方广告容器
		private var showContentSprite:Sprite;	//当前展示内容(字母查询)
		
		private var swfSprite:Sprite;	//SWF 容器(周边，地图，线路)
		
		private var mapSprite:Sprite = new Sprite();
		
		private var fullSprite:Sprite;//全屏广告
		
		
		private function initTop():void
		{
			var shaper:Shape = new Shape();
			shaper.graphics.beginFill(0xaacc00,0);
			shaper.graphics.drawRect(0,0,Const.SCREEN_WIDTH,Const.TOP_HEIGHT);
			shaper.graphics.endFill();
			addChild(shaper);
			
//			var topAdvertise:AdvertiseFLV = new AdvertiseFLV(homeListLoader.getUrlByName("topAdvertise"));
//			addChild(topAdvertise);
//			nowY += topAdvertise.height;
		}
		
		private function initMiddleBG():void
		{
			var l:CLoaderMany = new CLoaderMany();
			var bgArr:Array = new Array();
			
			bgArr.push(publicData.bg);
			bgArr.push(publicData.titlebg);
			//bgArr.push(publicData.titleinfo);
			l.load(bgArr);
			l.addEventListener(CLoader.LOADE_COMPLETE,bgLoadHandler);
		}
		
		private var titleLoader:CLoader = null;
		private function bgLoadHandler(event:Event):void
		{
			var ll:CLoaderMany = event.currentTarget as CLoaderMany;
			ll._loaderContent[0].y = Const.TOP_HEIGHT+18;
			ll._loaderContent[1].y = Const.TOP_HEIGHT;
//			ll._loaderContent[2].x = 222;
//			ll._loaderContent[2].y = Const.TOP_HEIGHT+69;
			
			for each(var l:Loader in ll._loaderContent)
			{
				this.addChild(l);
			}
			
			
			initMiddle();
			initBottom();
			
			setTitle(publicData.titleRecommend);
		}
		
		private function setTitle(titleUrl:String):void
		{
			if (titleLoader == null)
				titleLoader = new CLoader();
			
			titleLoader.load(titleUrl);
			titleLoader.addEventListener(CLoader.LOADE_COMPLETE,titleLoadHandler);
		}
		
		private function titleLoadHandler(event:Event):void
		{
			titleLoader._loader.x = (Const.SCREEN_WIDTH-titleLoader._loader.width)/2;
			titleLoader._loader.y = Const.TOP_HEIGHT - 2;
			this.addChild(titleLoader._loader);
		}
		
		private var recommendContent:LetterSearchPage;
//		private var fullscreen:FullScreenAdvertise;
		private var homeData:HomePageData;
		private var publicData:PublicData;
		private function initMiddle():void
		{
//			var config:XmlBaseConfig = new XmlBaseConfig("homepage");
//			homeData = config.getSampleById(2) as HomePageData;
			
//			recommendContent = new LetterSearchPage(Const.RECOMMEND,s,homeListLoader);//推荐景显示
//			recommendContent.visible = false;
//			this.addChild(recommendContent);
			advertiseSprite = new Sprite();
			showContentSprite = new Sprite();
			addChild(showContentSprite);
			swfSprite = new Sprite();
			addChild(swfSprite);
			showContentSprite.y = Const.TOP_HEIGHT+1;// = recommendContent.y 
			addChild(mapSprite);
			
			var shape1:Shape = new Shape();	//避免老资源超出舞台还在显示
			shape1.graphics.beginFill(0xaacc00,0.4);
			shape1.graphics.drawRect(0,0,Const.SCREEN_WIDTH,Const.MIDDLE_HEIGHT);
			shape1.graphics.endFill();
			addChild(shape1);
			swfSprite.mask = shape1;
			
			var shape:Shape = new Shape();	//避免老资源超出舞台还在显示
			shape.graphics.beginFill(0xaacc00,0.4);
			shape.graphics.drawRect(0,0,Const.SCREEN_WIDTH,Const.MIDDLE_HEIGHT);
			shape.graphics.endFill();
			addChild(shape);
			mapSprite.mask = shape;
			
			fullSprite = new Sprite();
			addChild(fullSprite);
			
//			fullscreen = new FullScreenAdvertise();
//			addChild(fullscreen);
			
			buttonBar = new ButtonBar(homeListLoader.getUrlByName("homepage"));
//			buttonBar.y = 672;
			buttonBar.y = 1728;
			addChild(buttonBar);
//			nowY += recommendContent.height;
			addChild(advertiseSprite);
//			shape.y = swfSprite.y = advertiseSprite.y = 63;
			shape1.y = mapSprite.y = shape.y = swfSprite.y = advertiseSprite.y = 1120;
			buttonBar.addEventListener(DataEvent.CLICK,showContentHandler);
			buttonBar.addEventListener("btnUpOver",letterPanelUpHandler);
			
	//////////////////////测试返回按钮		
//			backButton = new BackButton();
//			backButton.visible = false;
//			backButton.y = 1700;
//			backButton.x = 1000;
//			addChild(backButton);
//			backButton.addEventListener(MouseEvent.CLICK,backHandler);
			
			//////////////////////////将全部版块都加载进来
			
		}
		
		/**
		 *在按钮上来后，字母再出现 
		 * @param event
		 * 
		 */		
		private function letterPanelUpHandler(event:Event):void
		{
			trace("get btnupover event..");
			scenicspotSearch.upMove();
		}
		private var buttonBar:ButtonBar;
		private var scenicspotSearch:LetterSearchPage;
		private var currentData:*;	//当前是那块 地图查询 OR 线路 OR 周边
		
//		private var l:CLoader;
		private var entraceName:String = "";
		/**
		 *显示不同内容 
		 * @param event
		 * 
		 */		
		private var isNation:Boolean = false;
		private function showContentHandler(event:DataEvent):void
		{
			isNation = false;
			
			trace("==in home  DataEvent==",event.data);
			if(currentData == event.data)//当前是那块 地图查询 OR 线路 OR 周边
			{
				return;
			}
			if(mapPage)
			{
				mapPage.resetState();
			}
			clear(advertiseSprite);
			Administrator.instance.dispatchEvent(new Event(Cevent.VIDEO_SOUND_OPEN));
			currentData = event.data;
			checkTimes = Const.TOTAL_BACK_SHORT_TIME;
			
			trace("swfSprite.numChildren=====",event.data);
			switch(event.data)
			{
				case "f0":
					entraceName = "大研古城";
					setTitle(publicData.titleLiJiang);
					mapPageLoad(homeData.circumUrl);
					break;
				case "f3":
					entraceName = "丽江周边";
					swfLoader(homeData.fastGuideUrl);
					setTitle(publicData.titleRecommend);
//					scenicspotSearch.visible = false;
//					recommendContent.visible = true;
//					closeMapInfo();
////					clearSwf(true);
//					while(swfSprite.numChildren)
//					{
//						swfSprite.removeChildAt(0);
//					}
//					showContentSprite.visible = false;
//					currentData = "";
//					currentUrl = null;
					GC.gc();
					break;
				case "f2":	//一分攻略
					
					//d"多彩民族"
					entraceName = "多彩民族";
					isNation = true;
					swfLoader(homeData.oneMinuteUrl);
					setTitle(publicData.titleOneMinute);
//					swfLoader("E:/多彩MZ/duocaiminzu/bin-debug/duocaiminzu.swf");
					
					break;
				case "f1":	//景区查询
					entraceName = "云南百大景区查询";
					if(!scenicspotSearch)
					{
						scenicspotSearch = new LetterSearchPage(Const.SEARCH,s,homeListLoader);
						showContentSprite.addChild(scenicspotSearch);
					}
//					recommendContent.clearAllHandler(null);
//					recommendContent.visible = true;
					clearSwf(true);
					showContentSprite.visible = true;
					setTitle(publicData.titleRecommend);
					break;
				
				case "":
					break;
				case "b0":	//字母查询
					entraceName = "云南字母查询";
					scenicspotSearch.clearAllHandler(null);
//					recommendContent.visible = false;
					scenicspotSearch.visible = true;
					setTitle(publicData.titleLetter);
					clearSwf(true);
					break;
				case "b1":	//线路查询
					entraceName = "云南线路查询";
					swfLoader(homeData.linsearchUrl);
					setTitle(publicData.titleRoute);
					break;
				case "b2":	// 地图查询
					entraceName = "云南地图查询";
					swfLoader(homeData.mapsearchUrl);
					setTitle(publicData.titleMap);
					break;
				case "hiden":
					swfLoader(publicData.lyjPic.split(",")[1]);
					break;
				case "jjbg":	//宾馆
					entraceName = "云南定制按钮";
//					navigateToURL(new URLRequest("http://www.baidu.com"));
					trace("点击了铁管");
					swfLoader(publicData.lyjPic.split(",")[0]);
//					var hotel:Hotel = new Hotel();
//					hotel.y = 304;
//					hotel.x = 540;
//					swfSprite.addChild(hotel);
//					clearSwf();
//					recommendContent.clearAllHandler(null);
//					if(scenicspotSearch)
//					{
//						scenicspotSearch.clearAllHandler(null);
//					}
					break;
				case "b3":	//返回
					entraceName = "大研古城";
//					Memory.gc();
					setTitle(publicData.titleRecommend);
					scenicspotSearch.visible = false;
					mapPage.visible = true;
//					recommendContent.visible = true;
					clearSwf(true);
					showContentSprite.visible = false;
					scenicspotSearch.clearAllHandler(null);
					scenicspotSearch.recoverLetterXY();
					scenicspotSearch.resetLetterSelect();
					buttonBar.resetGroup();
					currentData = "";
					currentUrl = null;
					GC.gc();
					break;
			}
			Administrator.sendData(entraceName);
		}
		private var swfLoad:CLoader;
		private function swfLoader(_url:String):void
		{
//			clearSwf();
			swfLoad = new CLoader();
			swfLoad.load(_url);
			swfLoad.addEventListener(CLoader.LOADE_COMPLETE,swfHandler);
		}
		
		private var mapPage:MapPage;
		private function mapPageLoad(url:String):void
		{
			if(!mapPage)
			{
				mapPage = new MapPage(url, publicData);
				mapSprite.addChild(mapPage);
			}
			clearSwf(true);
//			mapPage.changeVision(true);
			mapPage.visible = true;
//			mapPage.resetState();
//			recommendContent.clearAllHandler(null);
					
		}
		
		/**
		 *返回主页 
		 * @param event
		 * 
		 */		
		private function backHandler(event:MouseEvent):void
		{
			clear(advertiseSprite);
			currentUrl = "";
			Administrator.instance.dispatchEvent(new Event(Cevent.VIDEO_SOUND_OPEN));
		}
		private var backButton:BackButton;
		private function initBottom():void
		{
//			var bottomAddvertise:AdvertisementBar = new AdvertisementBar();
//			addChild(bottomAddvertise);
//			bottomAddvertise.addEventListener(DataEvent.CLICK,playVideoHandler);
//			bottomAddvertise.y = 1838;
			
			var cloader:CLoader = new CLoader();
			cloader.load("source/yunnan/main/publicpic/ganggao.png");
			cloader.addEventListener(CLoader.LOADE_COMPLETE,bottomOkHandler);
		}
		private function bottomOkHandler(event:Event):void
		{
			var lb:CLoader = event.target as CLoader;
			addChild(lb._loader);
			lb._loader.y = 1824;
//			lb._loader.y = 784;
		}
		private var currentUrl:String;	//当前下文广告播放地址
		/**
		 *播放下方的一个广告 
		 * @param event
		 * 
		 */		
		private function playVideoHandler(event:DataEvent):void
		{
			trace(currentUrl,"**",event.data);
			if(currentUrl == event.data)
			{
				trace("**相同之处 URL==");
				return;
			}
			Administrator.instance.dispatchEvent(new Event(Cevent.CLEAR_DM_QGL));
			currentUrl = event.data;
			trace(currentUrl,"*==*",event.data);
			playAdvertisement(event.data);
		}
		
		private var video:CVideo;
		private var loader:CLoader;
		/**
		 *播放广告 
		 * @param _url
		 * 
		 */		
		private function playAdvertisement(_url:String="source/data/sichuan/source/homepage/advertisement/bottom/ba1/2.flv"):void
		{
			trace("in homepage==",_url);
//			clear(advertiseSprite);
			clearSwf();
			if(!backButton.visible)
			{
				backButton.visible = true;
			}
			if(!judgement(_url))
			{
				if(loader)
				{
					loader._loader = null;
					loader = null;
				}

				loader = new CLoader();
				loader.load(_url);
				loader.addEventListener(CLoader.LOADE_COMPLETE,swfOkHandler);
				Administrator.instance.dispatchEvent(new Event(Cevent.VIDEO_SOUND_OPEN));
			}
			else
			{
			
				if(!video)
				{
					video = new CVideo();
					video.addEventListener(Event.REMOVED_FROM_STAGE,closeStreamHandler);
					video.addEventListener(CVideo.VIDEO_PLAY_OVER,playOverHandler);
					advertiseSprite.addChild(video);
				}
				video.url = _url;
				Administrator.instance.dispatchEvent(new Event(Cevent.VIDEO_SOUND_CLOSE));
			}
		}
		/**
		 *关闭流 
		 * @param event
		 * 
		 */		
		private function closeStreamHandler(event:Event):void
		{
			video.close();
			
			video.removeEventListener(Event.REMOVED_FROM_STAGE,closeStreamHandler);
			video.removeEventListener(CVideo.VIDEO_PLAY_OVER,playOverHandler);
			video = null;
		}
		/**
		 *视频自然播放完成 
		 * @param event
		 * 
		 */		
		private function playOverHandler(event:Event):void
		{
			trace("in home play over...");
			currentUrl = "";
			clear(advertiseSprite);
			Administrator.instance.dispatchEvent(new Event(Cevent.VIDEO_SOUND_OPEN));
		}
		/**
		 *添加SWF视频 
		 * @param event
		 * 
		 */		
		private function swfOkHandler(event:Event):void
		{
			advertiseSprite.addChild(loader._loader);
		}
		/**
		 *清除 swfSprite 中内容
		 * 
		 */		
		private function clearSwf(b:Boolean = false):void
		{
			if(!b)
			{
				
				while(swfSprite.numChildren>1)
				{
					swfSprite.removeChildAt(0);
				}
			}
			else
			{
				if(swfSprite.numChildren)
					swfSprite.removeChildAt(0);
			}
			
			if (mapPage != null)
			{
				closeMapInfo();
			}
		}
		private function closeMapInfo():void
		{
			mapPage.visible = false;
			if(mapPage.isPlaying)
			{
				mapPage.backVideoHandler(null);
			}
		}
				
		private function swfHandler(event:Event):void
		{
			swfSprite.addChild(swfLoad._loader);
			swfLoad._loader.addEventListener(Event.REMOVED_FROM_STAGE,setNull);

			if (!isNation)
			{
//				recommendContent.clearAllHandler(null);
				clearSwf();
			}
			else
			{
				clearTimer = new Timer(100,1);
				clearTimer.addEventListener(TimerEvent.TIMER,timerHandler);
			}
		}
		private var clearTimer:Timer;
		private function timerHandler(event:TimerEvent):void
		{
//			recommendContent.clearAllHandler(null);
			clearTimer.removeEventListener(TimerEvent.TIMER,timerHandler);
			clearTimer = null;
		}
		private function xmlLoadOKHandler(event:Event):void
		{
//			recommendContent.clearAllHandler(null);
			clearSwf();
			isNation = false
		}
		
		private function canClearHandler(event:Event):void
		{
			trace("get okok event",event.type);
		}
		
		private function setNull(event:Event):void
		{
			trace("****设置为NULL。。。。");
			swfLoad._loader.removeEventListener(Event.REMOVED_FROM_STAGE,setNull);
			swfLoad._loader = null;
			swfLoad = null;
			GC.gc();
		}
		/**
		 *清除广告内容 
		 * 
		 */		
		private function clear(s:Sprite):void
		{
			trace("==清空广告视频===");
			while(s.numChildren)
			{
				s.removeChildAt(0);
			}
//			backButton.visible = false;
//			currentUrl = "";
		}
		/**
		 * 
		 * 判断是FLV还是SWF
		 */		
		private function judgement(str:String):Boolean
		{
			var a:Array = str.split(".");
			if(a[1] == "swf")
			{
				return false;	//是SWF型文件
			}
			return true;	//FLV型视频
		}
		/**
		 *执行无操作返回程式 / 播全屏广告
		 * 
		 */		
		private function checkTime():void
		{
			var timer:Timer = new Timer(Const.CHECK_TIME);
			timer.addEventListener(TimerEvent.TIMER,beginCheckHandler);
			timer.start();
			
//			var timerFull:Timer = new Timer(Const.FULLSCREEN_ADVERTISE_TIME);
//			timerFull.addEventListener(TimerEvent.TIMER,fullPlayHandler);
//			timerFull.start();
		}
		private var checkTimes:int = Const.TOTAL_BACK_SHORT_TIME;	//多长时间返回
		private function beginCheckHandler(event:TimerEvent):void
		{
			trace("checkTimes=YN=",checkTimes);
			if(TimerDevice.check(checkTimes))
			{
				backHomepage();
				trace("I WILL BACK..");
				
				dispatchEvent(new Event("SHOW_YN"));
			}
		}
		private function backHomepage():void
		{
			var beforBackStage:int = buttonBar.getCurrentId();
			trace("=state===",buttonBar.getCurrentId(),buttonBar.getCurrentId(""));
			buttonBar.downMove();
			clearSwf(true);
			showContentSprite.visible = false;
			if(scenicspotSearch)
			{
				scenicspotSearch.clearAllHandler(null);
			}
//			recommendContent.clearAllHandler(null);
//			recommendContent.visible = true;
			
			setTitle(publicData.titleLiJiang);
			buttonBar.resetGroup();
			currentData = null;
			
			var afterState:int = buttonBar.getCurrentId();
			trace("==afterState==",afterState);
			if(beforBackStage == 0)
			{
				mapPage.visible = true;
			}else
			{
				buttonBar.atuoChange();
			}
		}
		public function clearAll():void
		{
			backHomepage();
		}
		private function fullPlayHandler(event:TimerEvent):void
		{
			if(TimerDevice.getSpaceTime())
			{
//				fullscreen.play();
			}
		}
	}
}