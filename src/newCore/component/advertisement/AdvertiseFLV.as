package newCore.component.advertisement
{
	import core.admin.Administrator;
	import core.baseComponent.CVideo;
	import newCore.config.AdvertiseMentData;
	import newCore.config.HomePageData;
	import core.constant.Const;
	import core.loadEvents.CLoaderMany;
	import core.loadEvents.Cevent;
	import core.string.StringSlice;
	import core.xmlclass.MainXmlList;
	import core.xmlclass.XmlBaseConfig;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 *首页上方SWF + FLV 广告 
	 * @author bin.li
	 * 
	 */	
	public class AdvertiseFLV extends Sprite
	{
		private var loader:CLoaderMany;
		private var video:CVideo;
		
		private var swfArr:Array;
		private var flvArr:Array;
		private var wdArr:Array;	//视频宽高
		public function AdvertiseFLV()
		{
			super();
			
			var config:XmlBaseConfig;
			var configData:AdvertiseMentData;
			
			swfArr = [];
			flvArr = [];
			wdArr = [];
			for each(var name:String in MainXmlList.topAdvertiseName)
			{
				config = new XmlBaseConfig(name);
				configData = config.getSampleById(0) as AdvertiseMentData;
				swfArr.push(StringSlice.addString(configData.swf.split(","),Const.ADVERTISE_ROOT_TOP,2));
				flvArr.push(Const.ADVERTISE_ROOT_TOP + configData.targetUrl);
				wdArr.push(new Point(configData.w,configData.h));
			}
			count = flvArr.length;
//			var urlarr:Array = StringSlice.split(configData.normalArr0);	//子项为不同的广告，含FLV，SWF
			
			video = new CVideo(1080,608);
			video.isList = true;
			addChild(video);
			video.addEventListener(CVideo.VIDEO_PLAY_OVER,playNextHandler);
			Administrator.instance.addEventListener(Cevent.VIDEO_SOUND_CLOSE,soundCloseHandler);
			Administrator.instance.addEventListener(Cevent.VIDEO_SOUND_OPEN,soundOpenHandler);
			beginShow();
		
		}
		private function soundCloseHandler(event:Event):void
		{
			trace(" in flv VIDEO_SOUND_CLOSE");
			video.soundCloseHandler(null);
		}
		private function soundOpenHandler(event:Event):void
		{
			video.soundOpenHandler(null);
			trace(" in flv VIDEO_SOUND_OPEN");
		}
		private function setVideo():void
		{
			var p:Point = wdArr[index];
			video.height = 1080*p.y/p.x;
			trace("====setVideo==",video.height);
		}
		private var count:int;
		private var index:int;
		
		private function beginShow():void
		{
			var nowVolume:Number = video.volume;
			loader = new CLoaderMany();
			loader.addEventListener(CLoaderMany.LOADE_COMPLETE,swfOkHandler);
			loader.load(swfArr[index]);
			video.url = flvArr[index];
			if(nowVolume != -1&&nowVolume == 0)
			{
				soundCloseHandler(null);
			}
			setVideo();
			trace("==index==",flvArr[index],count,swfArr[index]);
			
			trace("==in adverFLV==VOLUME=AFTER=",video.volume);
			index++;
			if(index>=count)
			{
				index = 0;
			}
		}
		private function swfOkHandler(event:Event):void
		{
			trace("==flv swf ok===",loader._loaderContent[0].height,loader._loaderContent[1].height);
			addChild(loader._loaderContent[0]);
			addChild(loader._loaderContent[1]);
//			loader._loaderContent[0].height = 101;
//			loader._loaderContent[1].height = 102;
			video.y = 528 - video.height/2;
			loader._loaderContent[1].y = 1056 - loader._loaderContent[1].height;
//			loader._loaderContent[1].y = video.y + video.height;
		}
		private function playNextHandler(event:Event):void
		{
			trace("$$$$$$playe next==");
//			loader.clear();
			trace("==in adverFLV==VOLUME==",video.volume);
			
			removeSwf();
			beginShow();
		}
		private function removeSwf():void
		{
			loader.removeEventListener(CLoaderMany.LOADE_COMPLETE,swfOkHandler);
			for each(var l:Loader in loader._loaderContent)
			{
				removeChild(l);
				l = null;
			}
			loader = null;
		}
	}
}