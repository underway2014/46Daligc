package core.component.advertisement
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class SingleAdvertise extends Sprite
	{
		/**
		 *一条单独广告 
		 * @param _displayObject
		 * @param type
		 * 
		 */		
		public function SingleAdvertise(_displayObject:DisplayObject,type:int)
		{
			super();
			addChild(_displayObject);
//			if(type%2!=0)
//			{
//				_displayObject.scaleY = -1;
//				_displayObject.y = _displayObject.height;
//			}
		}
		public var url:String;
	}
}