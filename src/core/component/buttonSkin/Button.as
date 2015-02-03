package core.component.buttonSkin
{
	import core.interfaces.SelectItem;
	import core.loadEvents.CLoader;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import flashx.textLayout.operations.MoveChildrenOperation;

	/**
	 * 
	 * @author bin.li
	 * 
	 */
	public class Button extends Sprite implements SelectItem
	{
		private var bt:MovieClip;
		private var btname:TextField;//按钮名字
		
		private var normalState:MovieClip;
		private var overState:MovieClip;
		private var clickState:MovieClip;
		private var banState:MovieClip;
		
		private var currentState:MovieClip;
		
		private var _enable:Boolean;//是否可用
		
		private var _width:Number;
		private var _height:Number;
		
		public var data:*;//存放BUTTON上携带的数据
		public function Button(_mcSkin:MovieClip)
		{
			super();
			this.buttonMode = true;
			
			bt = _mcSkin;
			addChild(bt);
//			if(bt.nametxt)
//			{
//				btname = bt.nametxt;
//				btname.text = (_name==null)?"":_name;
//				btname.selectable = false;
//				btname.mouseEnabled = false;
//			}
			
			if(bt.st0)//正常状态
			{
				normalState = bt.st0;
			}
			currentState = normalState;
//			if(bt.st1)//划过，
//			{
//				overState = bt.st1;
//				overState.visible = false;
//			}
			if(bt.st2)//点击
			{
				clickState = bt.st2;
				clickState.visible = false;
			}
//			if(bt.st3)//禁止状态
//			{
//				banState = bt.st3;
//				banState.visible = false;
//			}
			this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			this.addEventListener(MouseEvent.CLICK,mouseClickHandler);
		}
		private function mouseClickHandler(event:MouseEvent):void
		{
			if(clickState&&currentState!=clickState)
			{
				currentState.visible = false;
				currentState = clickState;
				currentState.visible = true;
			}
		}
		private function mouseOverHandler(event:MouseEvent):void
		{
			if(overState&&currentState!=overState&&currentState!=clickState)
			{
				currentState.visible = false;
				currentState = overState;
				currentState.visible = true;
			}
			
		}
		private function mouseOutHandler(event:MouseEvent):void
		{
			if(normalState&&currentState!=normalState&&currentState!=clickState)
			{
				currentState.visible = false;
				currentState = normalState;
				currentState.visible = true;
			}
		}
		private function changeState():void
		{
			if(_enable)
			{
				if(currentState != normalState)
				{
					currentState.visible = false;
					currentState = normalState;
					currentState.visible = true;
				}
			}
			else
			{
				currentState.visible = false;
				currentState = banState;
				currentState.visible = true;
			}
		}
		/**
		 * 禁用时移除所有事件,启用时添加事件
		 * **/
		private function removeOrAddListener():void
		{
			this.buttonMode = _enable;
			if(!enable)
			{
				this.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
				this.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
				this.removeEventListener(MouseEvent.CLICK,mouseClickHandler);
			}
			else
			{
				this.addEventListener(MouseEvent.CLICK,mouseClickHandler);
				this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
				this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			}
		}
		/**
		 * 按钮是否选中
		 * **/
		public function select(b:Boolean):void
		{
			if(b)
			{
				mouseClickHandler(null);
			}
			else
			{
				if(currentState!=normalState)
				{
					currentState.visible = false;
					currentState = normalState;
					currentState.visible = true;
				}
			}
		}

		public function get enable():Boolean
		{
			return _enable;
		}

		public function set enable(value:Boolean):void
		{
			_enable = value;
			removeOrAddListener();
			changeState();
		}

		override public function set width(value:Number):void
		{
			bt.width = value;//容器是不能设置大小的
		}

		override public function set height(value:Number):void
		{
			bt.height = value;
		}
		public function move(b:Boolean):void
		{
			
		}
	}
}