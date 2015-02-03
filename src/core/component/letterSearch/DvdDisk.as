package core.component.letterSearch
{
	import core.loadEvents.CLoader;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class DvdDisk extends Sprite
	{
		/**
		 *一张DVK盘 
		 * 
		 */		
		public function DvdDisk(srcUrl:String)
		{
			super();
			
			loader = new CLoader();
			loader.load(srcUrl);
			loader.addEventListener(CLoader.LOADE_COMPLETE,okHandler);
			
		}
//		private var shape:Shape;
		private var loader:CLoader;
		
		private function okHandler(event:Event):void
		{
			addChild(loader._loader);
			loader._loader.x = -loader._loader.width/2;
			loader._loader.y = -loader._loader.height/2;
//			addChild(shape);
//			this.addEventListener(Event.ENTER_FRAME,rotionHandler);
		}
		private function rotionHandler(event:Event):void
		{
			loader._loader.rotation += 10;
		}
	}
}