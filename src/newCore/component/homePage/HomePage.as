package newCore.component.homePage
{
	import core.admin.Administrator;
	import core.baseComponent.BackButton;
	import core.baseComponent.CVideo;
	import core.constant.Const;
	import core.interfaces.ClearAll;
	import core.loadEvents.CLoader;
	import core.loadEvents.CXmlLoader;
	import core.loadEvents.Cevent;
	import core.loadEvents.DataEvent;
	import core.memefree.GC;
	import core.memefree.Memory;
	import core.timer.TimerDevice;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import newCore.BottomAdvertise.AdvertiseFir;
	import newCore.BottomAdvertise.AdvertiseFour;
	import newCore.BottomAdvertise.AdvertiseSec;
	import newCore.BottomAdvertise.AdvertiseThir;
	import newCore.BottomAdvertise.SelfLeftAvertise;
	import newCore.BottomAdvertise.SelfRightAvertise;
	import newCore.component.advertisement.FullScreenAdvertise;
	import newCore.component.buttonBar.ButtonBar;
	import newCore.component.letterSearch.LetterSearchPage;
	import newCore.config.HomePageData;
	
//	import mx.core.mx_internal;
//	
//	import org.osmf.events.BufferEvent;
	
	/**
	 *首页 
	 * @author bin.li
	 * 
	 */	
	public class HomePage extends Sprite implements ClearAll
	{
		private var s:Stage;
		private var frameLoader:CXmlLoader;
		/**
		 * 
		 * @param _s
		 * 
		 */
		public function HomePage(_s:Stage,xmlloader:CXmlLoader)
		{
			super();
			s = _s;
			frameLoader = xmlloader;
			loadHomeConfig();
			
			checkTime();
			
			/*
			 *内部DM单OR 全攻略放视频时 
			*/
			this.addEventListener("soundoff",topCloseSoundHandler);
			this.addEventListener("soundon",topSoundOpenHandler);
			
			s.addEventListener(MouseEvent.CLICK,stageClickHandler);		//检测是否有人操作
		
		}
		private function stageClickHandler(event:MouseEvent):void
		{
			trace("stage has been click...");
			TimerDevice.resetTime();
		}
		private function topCloseSoundHandler(event:Event):void
		{
			trace("get trace sound off ha");
			checkTimes = Const.TOTAL_BACK_TIME;
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
		
		private var fullSprite:Sprite;//全屏广告
		
		
		private function initTop():void
		{
			var shaper:Shape = new Shape();
			shaper.graphics.beginFill(0xaacc00,0);
			shaper.graphics.drawRect(0,0,1080,1056);
			shaper.graphics.endFill();
			addChild(shaper);
			
//			var topAdvertise:AdvertiseFLV = new AdvertiseFLV();
//			addChild(topAdvertise);
//			nowY += topAdvertise.height;
			
		}
		private var homeListXmlLoader:CXmlLoader;
		private function loadHomeConfig():void
		{
			homeListXmlLoader = new CXmlLoader();
			homeListXmlLoader.loader(frameLoader.getUrlByName("mainXml"));	//加载首页LIST XML
			homeListXmlLoader.addEventListener(CXmlLoader.LOADER_COMPLETE,listOkHandler);
		}
		private var homeXmlLoader:CXmlLoader;
		private function listOkHandler(event:Event):void
		{
			homeListXmlLoader.removeEventListener(CXmlLoader.LOADER_COMPLETE,listOkHandler);
			homeXmlLoader = new CXmlLoader();
			homeXmlLoader.loader(homeListXmlLoader.getUrlByName("homepage"));
			homeXmlLoader.addEventListener(CXmlLoader.LOADER_COMPLETE,homeXMLHandler);
				
		}
		private var publicXmlLoader:CXmlLoader;
		private function homeXMLHandler(evet:Event):void
		{
			homeXmlLoader.removeEventListener(CXmlLoader.LOADER_COMPLETE,homeXMLHandler);
			publicXmlLoader = new CXmlLoader();
			publicXmlLoader.loader(homeListXmlLoader.getUrlByName("public_source"));//public_source
			publicXmlLoader.addEventListener(CXmlLoader.LOADER_COMPLETE,homeConfigOk);
		}
		private function homeConfigOk(event:Event):void
		{
			
			initTop();
			initMiddle();
			initBottom();
		}
		private var recommendContent:LetterSearchPage;
		private var fullscreen:FullScreenAdvertise;
		private var homeData:HomePageData;
		private function initMiddle():void
		{
			
//			var config:XmlBaseConfig = new XmlBaseConfig("homepage");
			homeData = homeXmlLoader.getDataById(2) as HomePageData;
			
			recommendContent = new LetterSearchPage(Const.RECOMMEND,s,homeListXmlLoader);//推荐景显示
			this.addChild(recommendContent);
			advertiseSprite = new Sprite();
			showContentSprite = new Sprite();
			addChild(showContentSprite);
			swfSprite = new Sprite();
			addChild(swfSprite);
			showContentSprite.y = recommendContent.y = 1056;
			
			var shape:Shape = new Shape();	//避免老资源超出舞台还在显示
			shape.graphics.beginFill(0xaacc00,0.4);
			shape.graphics.drawRect(0,0,1080,708);
			shape.graphics.endFill();
			addChild(shape);
			swfSprite.mask = shape;
			
			fullSprite = new Sprite();
			addChild(fullSprite);
			
			fullscreen = new FullScreenAdvertise();
			addChild(fullscreen);
			
			buttonBar = new ButtonBar(homeXmlLoader);
//			buttonBar.y = 672;
			buttonBar.y = 1728;
			addChild(buttonBar);
			nowY += recommendContent.height;
			addChild(advertiseSprite);
//			shape.y = swfSprite.y = advertiseSprite.y = 63;
			shape.y = swfSprite.y = advertiseSprite.y = 1120;
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
		private var entraceName:String = "景区推荐";
		/**
		 *显示不同内容 
		 * @param event
		 * 
		 */		
		private function showContentHandler(event:DataEvent):void
		{
			trace("==in home  DataEvent==",event.data);
			if(currentData == event.data)//当前是那块 地图查询 OR 线路 OR 周边
			{
				return;
			}
			if(event.data != "b1"&&event.data != "b2")
			{
				clear(advertiseSprite);
			}
			Administrator.instance.dispatchEvent(new Event(Cevent.VIDEO_SOUND_OPEN));
			currentData = event.data;
			checkTimes = Const.TOTAL_BACK_SHORT_TIME;
			switch(event.data)
			{
				case "f0":	//景区查询
					entraceName = "字母查询";
					recommendContent.clearAllHandler(null);
					if(!scenicspotSearch)
					{
						scenicspotSearch = new LetterSearchPage(Const.SEARCH,s,homeListXmlLoader);
						showContentSprite.addChild(scenicspotSearch);
//						scenicspotSearch = null;
					}
					clearSwf(true);
//					scenicspotSearch.resetLetterXY();
					showContentSprite.visible = true;
					break;
				case "f1":	//一分攻略
					entraceName = "快速攻略";
					swfLoader(homeData.oneMinuteUrl);
//					var fastGuid:FastGuid = new FastGuid();
//					fastGuid.y = 304;
//					fastGuid.x = 540;
//					swfSprite.addChild(fastGuid);
//					clearSwf();
					recommendContent.clearAllHandler(null);
					break;
				case "f2":	//周边
					entraceName = "我的周边";
//					var circum:Circum = new Circum();
//					circum.y = 304;
//					circum.x = 540;
//					swfSprite.addChild(circum);
//					clearSwf();
					swfLoader(homeData.circumUrl);
					recommendContent.clearAllHandler(null);
					break;
				case "":
					break;
				case "b0":	//字母查询
					entraceName = "字母查询";
					scenicspotSearch.clearAllHandler(null);
					clearSwf(true);
					break;
				case "b1":	//线路查询
					entraceName = "线路查询";
					swfLoader(homeData.linsearchUrl);
					break;
				case "b2":	// 地图查询
					entraceName = "地图查询";
					swfLoader(homeData.mapsearchUrl);
					break;
				case "jjbg":	//宾馆
					entraceName = "宾馆";
					trace("点击了铁管");
					swfLoader(homeData.jjbgUrl);
//					var hotel:Hotel = new Hotel();
//					hotel.y = 304;
//					hotel.x = 540;
//					swfSprite.addChild(hotel);
//					clearSwf();
					recommendContent.clearAllHandler(null);
					if(scenicspotSearch)
					{
						scenicspotSearch.clearAllHandler(null);
					}
					break;
				case "b3":	//返回
					entraceName = "景区推荐";
//					Memory.gc();
					clearSwf(true);
					showContentSprite.visible = false;
					scenicspotSearch.clearAllHandler(null);
					scenicspotSearch.recoverLetterXY();
					scenicspotSearch.resetLetterSelect();
					currentData = "";
					currentUrl = "";
					GC.gc();
					break;
			}
			Administrator.sendData(entraceName);
		}
		private var swfLoaderT:CLoader;
		private function swfLoader(_url:String):void
		{
//			clearSwf();
			if(swfLoaderT)
			{
				swfLoaderT = null;
			}
			swfLoaderT = new CLoader();
			swfLoaderT.load(_url);
			swfLoaderT.addEventListener(CLoader.LOADE_COMPLETE,swfHandler);
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
			cloader.load("source/data/sichuan/source/publicpic/ganggao.png");
			cloader.addEventListener(CLoader.LOADE_COMPLETE,bottomOkHandler);
			
//			var adverBtn:AdvertiseButton = new AdvertiseButton();
//			adverBtn.addEventListener(DataEvent.CLICK,playBottomHandler);
//			addChild(adverBtn);
//			adverBtn.y = 1839;
		}
		private var adVideo:MovieClip;
		private function playBottomHandler(event:DataEvent):void
		{
			trace("bottom info====",currentUrl,"==",event.data);
			if(currentUrl == event.data)
			{
				return;
			}
			
//			if(adVideo)
//			{
//				advertiseSprite.removeChild(adVideo);
//			}
			switch(event.data)
			{
				case "ib1":
					clear(advertiseSprite);
//					advertiseSprite.removeChild(adVideo);
					adVideo = new AdvertiseFir();
					break;
				case "ib2":
					clear(advertiseSprite);
					adVideo = new AdvertiseSec();
					break;
				case "ib3":
					clear(advertiseSprite);
					adVideo = new AdvertiseThir();
					break;
				case "ib4":
					clear(advertiseSprite);
					adVideo = new AdvertiseFour();
					break;
				case "is1":
					clear(advertiseSprite);
					adVideo = new SelfLeftAvertise();
					break;
				case "is2":
					clear(advertiseSprite);
					adVideo = new SelfRightAvertise();
					break;
				default:
					return;
			}
			currentUrl = event.data;
			Administrator.instance.dispatchEvent(new Event(Cevent.CLEAR_DM_QGL));
			
			advertiseSprite.addChild(adVideo);
			
			adVideo.addEventListener(Event.REMOVED_FROM_STAGE,playOverHandler);
			adVideo.addEventListener("playover",playOverHandler1);
//			Administrator.instance.dispatchEvent(new Event(Cevent.VIDEO_SOUND_CLOSE));
			
		}
		private function bottomOkHandler(event:Event):void
		{
			var lb:CLoader = event.target as CLoader;
			addChild(lb._loader);
			lb._loader.y = 1839;
//			lb._loader.y = 784;
		}
		private var currentUrl:String = "";	//当前下文广告播放地址
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
		private function closeStreamHandler1(event:Event):void
		{
			video.close();
			
			video.removeEventListener(Event.REMOVED_FROM_STAGE,closeStreamHandler);
			video.removeEventListener(CVideo.VIDEO_PLAY_OVER,playOverHandler);
			video = null;
		}
		private function playOverHandler(event:Event):void
		{
			trace("claer video..next null..");
			if(adVideo.hasEventListener(Event.REMOVED_FROM_STAGE))
			adVideo.removeEventListener(Event.REMOVED_FROM_STAGE,playOverHandler);
			if(adVideo.hasEventListener("playover"))
			adVideo.removeEventListener("playover",playOverHandler1);
			if(adVideo)
			{
				trace("set adVideo null...");
				adVideo = null;
				GC.gc();
			}
			currentUrl = "";
			Administrator.instance.dispatchEvent(new Event(Cevent.VIDEO_SOUND_OPEN));
		}
		/**
		 *视频自然播放完成 
		 * @param event
		 * 
		 */		
		private function playOverHandler1(event:Event):void
		{
			trace("in home play over...");
			currentUrl = "";
			clear(advertiseSprite);
//			Administrator.instance.dispatchEvent(new Event(Cevent.VIDEO_SOUND_OPEN));
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
				
				if(swfSprite.numChildren>1)
				{
					swfSprite.removeChildAt(0);
				}
			}
			else
			{
				if(swfSprite.numChildren)
					swfSprite.removeChildAt(0);
			}
		}
		private function swfHandler(event:Event):void
		{
//			var ll:CLoader = event.target as CLoader;
			swfSprite.addChild(swfLoaderT._loader);
			swfLoaderT._loader.addEventListener(Event.REMOVED_FROM_STAGE,setNull);
			if(scenicspotSearch)
			{
				scenicspotSearch.clearAllHandler(null);
			}
			clearSwf();
			clear(advertiseSprite);
		}
		private function setNull(event:Event):void
		{
			trace("****设置为NULL。。。。");
			var lll:Loader = event.currentTarget as Loader;
			lll.removeEventListener(Event.REMOVED_FROM_STAGE,setNull);
			lll = null;
			swfLoaderT = null;
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
			trace("checkTimes=SC=",checkTimes);
			if(TimerDevice.check(checkTimes))
			{
				backHome();
				dispatchEvent(new Event("SHOW_YN"));
			}
		}
		private function backHome():void
		{
				buttonBar.downMove();
				clearSwf(true);
				showContentSprite.visible = false;
				if(scenicspotSearch)
				{
					scenicspotSearch.clearAllHandler(null);
				}
				recommendContent.clearAllHandler(null);
				buttonBar.resetGroup();
				currentData = null;
			
		}
		public function clearAll():void
		{
			backHome();
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