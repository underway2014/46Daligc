package core.component.hotel
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Hotel extends MovieClip
	{
		public function Hotel()
		{
			super();
			
//			var mc:MovieClip = this["test"];
//			
//			mc.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		private function clickHandler(event:MouseEvent):void
		{
			trace(" success test...");
		}
	}
}