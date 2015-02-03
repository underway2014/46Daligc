package com
{
	import core.baseComponent.CMoveClip;
	import core.config.AdvertiseMentData;
	import core.string.StringSlice;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class FullscreenAdvertise extends Sprite
	{
		public function FullscreenAdvertise(data:AdvertiseMentData)
		{
			super();
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xffffff,1);
			shape.graphics.drawRect(0,0,1080,1920);
			shape.graphics.endFill();
			addChild(shape);
						
			var arr:Array = data.pic.split(",");
			StringSlice.addString(arr,data.mainUrl,2);
			cMovie = new CMoveClip(arr,0.1,100,true,13);
			cMovie.addEventListener(CMoveClip.LOAD_OVER,sourceLoadOkHandler);
			cMovie.addEventListener(CMoveClip.PLAY_OVER,playOverHandler);
			addChild(cMovie);
		}
		private var isLoaded:Boolean;
		private var cMovie:CMoveClip;
		private function sourceLoadOkHandler(event:Event):void
		{
			isLoaded = true;
			cMovie.play();
		}
		private function playOverHandler(event:Event):void
		{
			dispatchEvent(new Event(CMoveClip.PLAY_OVER));
		}
		public function play():void
		{
			if(isLoaded)
			cMovie.play();
		}
		public function stop():void
		{
			cMovie.stop();
		}
	}
}