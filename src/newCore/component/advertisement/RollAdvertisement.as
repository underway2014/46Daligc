package newCore.component.advertisement
{
	import newCore.collect.CollectData;
	import newCore.component.homePage.HomePage;
	import newCore.config.AdvertiseMentData;
	import core.config.BaseConfig;
	import newCore.config.HomePageData;
	import core.constant.Const;
	import core.layout.Layout;
	import core.loadEvents.CLoaderMany;
	import core.loadEvents.Cevent;
	import core.loadEvents.DataEvent;
	import core.string.StringSlice;
	import core.xmlclass.MainXmlList;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.sampler.NewObjectSample;
	import flash.utils.Timer;
	
	import org.osmf.media.LoadableElementBase;
	
	/**
	 *下方广告中间可滚动的广告 
	 * @author bin.li
	 * 
	 */	
	
	public class RollAdvertisement extends Sprite
	{
		
		private var loader:CLoaderMany;
		
		private var picarr:Array;	//别人的广告
		private var urlarr:Array;	//广告的打开地址
		private var idArr:Array;	//每条广告的身份证
		
		public var selfarr:Array;		//下方广告中公司自己广告
		public var selfUrlArr:Array;
		
		public function RollAdvertisement()
		{
			super();
			picarr = [];
			urlarr = [];
			idArr = [];
			selfarr = [];
			selfUrlArr = [];
			var config:BaseConfig;
			var configData:AdvertiseMentData;
			var shareObj:SharedObject;
			
			for each(var name:String in MainXmlList.advertiseNameArr)
			{
				config = new BaseConfig(name);
				configData = config.getSampleById(0) as AdvertiseMentData;
				picarr.push(Const.ADVERTISE_ROOT_BOTTOM + configData.pic);
				urlarr.push(Const.ADVERTISE_ROOT_BOTTOM + configData.targetUrl);
				idArr.push(configData.id);
				
				MainXmlList.advertiseIDArr.push(configData.id);
				shareObj = SharedObject.getLocal(configData.id);
			}
			for each(var n:String in MainXmlList.selfAdvertiseName)
			{
				config = new BaseConfig(n);
				configData = config.getSampleById(0) as AdvertiseMentData;
				selfarr.push(Const.ADVERTISE_ROOT_BOTTOM + configData.pic);
				selfUrlArr.push(configData.targetUrl);
				
				MainXmlList.advertiseIDArr.push(configData.id);
				shareObj = SharedObject.getLocal(configData.id);
			}
			
			trace("==RollAdvertisement===RollAdvertisement==",picarr);
			
			///////////////////////////
//			var config:BaseConfig = new BaseConfig("homepage");
//			var configData:HomePageData = config.getSampleById(2) as HomePageData;
//			
//			selfarr = StringSlice.addString(configData.normalArr1.split(","),configData.mainurl,2);
//			selfUrlArr = StringSlice.addString(configData.urlarr1.split(","),configData.mainurl,2);
//			
//			picarr = StringSlice.addString(configData.normalArr0.split(","),configData.mainurl,2);
//			urlarr = StringSlice.addString(configData.urlarr0.split(","),configData.mainurl,2);
//			trace("&&&&***",picarr);
//			
			_picWidth = Const.PIC_BOTTOM_WIDTH;
			_picHeight = Const.PIC_BOTTOM_HEIGHT;
			_picNumber = urlarr.length;
//			
			loader = new CLoaderMany();
			loader.load(picarr);
			loader.addEventListener(CLoaderMany.LOADE_COMPLETE,loadOkHandler);
			
			spriteArr = new Vector.<MovieClip>();
			spriteArr.push(firSprite);
			spriteArr.push(secSprite);
			spriteArr.push(thiSprite);
			spriteArr.push(fouSprite);
			firSprite["isfront"] = secSprite["isfront"] = thiSprite["isfront"]= fouSprite["isfront"] = true;
			i=0;
			for each(var s:Sprite in spriteArr)
			{
				addChild(s);
				s.x = i*180;
				i++;
			}
			
		}
		private var i:int;
		
		private var layout:Layout;
		private var _picWidth:Number;	//图片宽度
		private var _picHeight:Number;
		private var _picNumber:int;	//图片个数
		
		private var firSprite:MovieClip = new MovieClip();
		private var secSprite:MovieClip = new MovieClip();
		private var thiSprite:MovieClip = new MovieClip();
		private var fouSprite:MovieClip = new MovieClip();
		
		private var spriteArr:Vector.<MovieClip>;
		
		private function loadOkHandler(event:Event):void
		{
//			layout = new Layout(urlarr.length,1,loader._loaderContent[0].width,1);
			
			i = 0;
			
//				layout.add(dis);
			var singleAdvertise:SingleAdvertise;
			for each(var dis:Loader in loader._loaderContent)
			{
				singleAdvertise = new SingleAdvertise(dis,i/4);
				singleAdvertise.y = -singleAdvertise.height/2;
				addChild(singleAdvertise);
				singleAdvertise.name = idArr[i];	//广告的NAME ID
				singleAdvertise.url = urlarr[i];	//广告链接地址
				if(i>3)
				{
					singleAdvertise.visible = false;
				}
//				dis["id"] = "ss";
				switch(i%4)
				{
					case 0:	firSprite.addChild(singleAdvertise);	break;
					case 1:	secSprite.addChild(singleAdvertise);	break;
					case 2:	thiSprite.addChild(singleAdvertise);	break;
					case 3:	fouSprite.addChild(singleAdvertise);	break;
				}
				singleAdvertise.addEventListener(MouseEvent.CLICK,clickHandler);
				i++;
			}
			totalPage = urlarr.length/4-1;
			
			var timer:Timer = new Timer(10000);	//切换广告
			timer.addEventListener(TimerEvent.TIMER,rotionAdvertisement);
			timer.start();
			
			//将所有广告ID名字存放起来
			CollectData.saveAllID(idArr);
			
			
		}
		public var totalPage:int;	//总共还有多个套广告0,1,2...
		public var currentPage:int;	//当前是第几套
		public var nextPage:int;		//下一套
		/**
		 *广告翻页 
		 * 
		 */		
		public function rotionAdvertisement(event:TimerEvent):void
		{
			i = 0;
			if(!totalPage)
			{
				return;
			}
//			currentPage = _cpage;
			this.addEventListener(Event.ENTER_FRAME,beginRotionHandler);
		}
		private var isFront:Boolean = true;	//是否是在正面
		private var isSmall:Boolean = false;	//是否是到达最小
		private var isBig:Boolean;			//是否达到最大
		private function beginRotionHandler(event:Event):void
		{
			nextPage = currentPage+1;
//			isFront = spriteArr[i]["isfront"];
			if(nextPage>totalPage)
			{
				nextPage = 0;
			}
			if(!isSmall)
			{
				spriteArr[i].scaleY -= 0.05;
				if(spriteArr[i].scaleY<=0)
				{
					isSmall = true;
					spriteArr[i].scaleY = 0;
				}
			}
			else
			{
				spriteArr[i].scaleY += 0.05;
				if(spriteArr[i].scaleY>=1)
				{
					isBig = true;
					spriteArr[i].scaleY = 1;
				}
			}
			
			if(isSmall)
			{
				spriteArr[i].getChildAt(currentPage).visible = false;
				spriteArr[i].getChildAt(nextPage).visible = true;
			}
//			if(spriteArr[i].scaleY>0&&!isFront)
//			{
//				spriteArr[i].getChildAt(currentPage).visible = false;
//				spriteArr[i].getChildAt(nextPage).visible = true;
//			}
			if(isBig)
			{
//				spriteArr[i].scaleY = -1;
//				spriteArr[i]["isfront"] = false;
				isBig = false;
				isSmall = false;
				i++;
				if(i>3)
				{
					this.removeEventListener(Event.ENTER_FRAME,beginRotionHandler);
					currentPage = nextPage;
				}
				return;
			}
//			if(spriteArr[i].scaleY>1)
//			{
//				spriteArr[i].scaleY = 1;
//				spriteArr[i]["isfront"] = true;
//				i++;
////				spriteArr[i].removeEventListener(Event.ENTER_FRAME,beginRotionHandler);
//				if(i>3)
//				{
//					this.removeEventListener(Event.ENTER_FRAME,beginRotionHandler);
//					currentPage = nextPage;
//				}
//				return;
//			}
			
		}
		
		
		
		
		/**
		 *点击广告 
		 * @param event
		 * 
		 */		
		private function clickHandler(event:MouseEvent):void
		{
			var l:SingleAdvertise = event.currentTarget as SingleAdvertise;
			
			trace("===sy==",loader._loaderContent.indexOf(l));	//打开广告相关视频的索引
			
			CollectData.addCount(l.name);	//增加当前广告点击次数   urlarr[loader._loaderContent.indexOf(l)]
//			trace("xxxxxxxxx===",l.name,"[NAME=]",MainXmlList.advertiseIDArr);
//			HomePage.instance.playAdvertisement();
			if(dataevent)
			{
				dataevent = null;
			}
			dataevent = new DataEvent(DataEvent.CLICK,true);
			dataevent.data = l.url;
			dispatchEvent(dataevent);
		}
		private var dataevent:DataEvent;

		public function get picWidth():Number
		{
			return _picWidth;
		}

		public function set picWidth(value:Number):void
		{
			_picWidth = value;
		}

		public function get picHeight():Number
		{
			return _picHeight;
		}

		public function set picHeight(value:Number):void
		{
			_picHeight = value;
		}

		public function get picNumber():int
		{
			return _picNumber;
		}

		public function set picNumber(value:int):void
		{
			_picNumber = value;
		}


	}
}