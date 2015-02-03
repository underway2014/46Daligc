package
{
	import com.ChoseProvicData;
	import com.FullscreenAdvertise;
	import com.ListWindow;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.fscommand;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import core.admin.Administrator;
	import core.baseComponent.CMoveClip;
	import core.component.advertisement.AdvertiseFLV;
	import core.component.homePage.HomePage;
	import core.config.AdvertiseMentData;
	import core.interfaces.ClearAll;
	import core.loadEvents.CLoaderMany;
	import core.loadEvents.CXmlLoader;
	import core.socket.CSocket;
	import core.timer.TimerDevice;
	
	import newCore.component.homePage.HomePage;
	
	
	[SWF(width="1080",height="1920",align="center")]	
	public class Main_46 extends Sprite
	{
		private var homeArr:Array;
		private var secondStepLoader:CXmlLoader;
		private var yunnanLoader:CXmlLoader;
		private var provicLoader:CXmlLoader;
		private var provinceName:String = "云南";
		public function Main_46()
		{
			stage.addEventListener(MouseEvent.RIGHT_CLICK,hidenRightHandler);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,hidenRightHandler);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,hidenRightHandler);
			declarationClass();
			fscommand("fullscreen","true");
			Mouse.hide();
			stage.showDefaultContextMenu = false;
			
			homeArr = [];
			
			fullSprite = new Sprite();
			
			/////////////////
			
			provicLoader = new CXmlLoader();
			provicLoader.loader("source/combinData/xml/choseProvinc.xml");
			provicLoader.addEventListener(CXmlLoader.LOADER_COMPLETE,provicOkHandler);
			
			////////////////
			
//			yunnanLoader = new CXmlLoader();
//			yunnanLoader.loader("source/yunnan/main/mainFrameList.xml");//D:\DSIS\raw\zip
////			yunnanLoader.loader("source/yunnan/main/mainFrameList.xml");
//			yunnanLoader.addEventListener(CXmlLoader.LOADER_COMPLETE,yunNanHandler);
			
//			timer = new Timer(200,1);
//			timer.addEventListener(TimerEvent.TIMER,timerHandler);
//			timer.start();
			
			this.addEventListener(SDataEvent.CLICK,ceventHandler);
		}
		private function hidenRightHandler(event:MouseEvent):void
		{
			return;
		}
		private var needLoadArray:Array;
		private var firstLoader:CXmlLoader;
		private function provicOkHandler(event:Event):void
		{
			needLoadArray = new Array();
			firstLoader = new CXmlLoader();
			var len:int = provicLoader.getLength();
			var provicData:ChoseProvicData;
			for(var j:int = 0;j<len;j++)
			{
				provicData = provicLoader.getDataById(j) as ChoseProvicData;
				if(provicData.isLoad)//是否需要加载显示
				{
					if(provicData.isFirstShow == 1)
					{
						needLoadArray.unshift(provicData);//第一个显示
						
						firstLoader.loader(provicData.province);
						firstLoader.addEventListener(CXmlLoader.LOADER_COMPLETE,firtProvicHandler);
					}
					else
					{
						needLoadArray.push(provicData);
					}
				}
				
				
			}
			if(needLoadArray.length > 1)
			{
				timer = new Timer(100,needLoadArray.length - 1);
				timer.addEventListener(TimerEvent.TIMER,timerHandler);
				timer.start();
			}
		}
		private function firtProvicHandler(event:Event):void
		{
			var C:Class = getDefinitionByName(firstLoader.getRootAttribute("class")) as Class;
			var ynHome:Object = new C(stage,firstLoader);
			addChild(ynHome as DisplayObject);
			homeArr.unshift(ynHome);
			ynHome.addEventListener("SHOW_YN",backYnHandler);
			
			fullscreenXMLloader = new CXmlLoader();
			fullscreenXMLloader.loader("source/advertisement/fullScreen/fullScreen.xml");
			fullscreenXMLloader.addEventListener(CXmlLoader.LOADER_COMPLETE,fullXMLHandler);
			
			listContain = new Sprite();
			addChild(listContain);
			listContain.y = 1057;
			
			
			btnSprite = new Sprite();
			btnSprite.y = 1050+6;
			btnSprite.x = 900 + 8;
			addChild(btnSprite);
			currentObject = homeArr[0];
			btnSprite.addEventListener(MouseEvent.CLICK,showListWindow);
			//			
			
			btnLoader = new CLoaderMany();
			btnLoader.load(["source/combinData/picture/listWindow/more_n.png","source/combinData/picture/listWindow/more_d.png"]);
			btnLoader.addEventListener(CLoaderMany.LOADE_COMPLETE,btnOkHandler);
			
			initTop();
		}
		
		private var socket:CSocket;
		private function ceventHandler(event:SDataEvent):void
		{
			Administrator.sendData(event.data);
//			trace("get sceinic click info = ",event.data);
		}
		private function socketDataHandler(event:Event):void
		{
			
		}
		private function socketErrorHandler(event:Event):void
		{
			trace("connect error...");
		}
		private var timer:Timer;
		private var senderName:String = "";
		private function yunNanHandler(event:Event):void
		{
			var C:Class = getDefinitionByName(yunnanLoader.getRootAttribute("class")) as Class;
//			var ynHome:core.component.homePage.HomePage = new core.component.homePage.HomePage(stage,yunnanLoader);
			var ynHome:Object = new C(stage,yunnanLoader);
			addChild(ynHome as DisplayObject);
//			currentObject = ynHome;
			ynHome.visible = false;
//			currentScenicId = 1;
			homeArr.push(ynHome);
			ynHome.addEventListener("SHOW_YN",backYnHandler);
		}
		private function showFull():void
		{
			if(fullData.pic == "")
			{
				return;
			}
			
			if(!fullAdver)
			{
				fullAdver = new FullscreenAdvertise(fullData);
				fullSprite.addChild(fullAdver);
				addChild(fullSprite);
				fullAdver.addEventListener(MouseEvent.CLICK,hidFullHandler);
				fullAdver.addEventListener(CMoveClip.PLAY_OVER,hidFullHandler);
			}
			if(!fullAdver.visible)
			{
				fullAdver.play();
				fullAdver.visible = true;
			}			
		}
		private function backYnHandler(event:Event):void
		{
			
			showFull();
			Administrator.sendData(provinceName);
			//			btnArr[0].visible = true;
			//			btnArr[1].visible = false;
			
			if(listWindow&&listWindow.visible)
			{
				//				listWindow.visible = false;
				showListWindow(null);
			}
			trace("I WILL BACK.HOME.");
			if(currentObject == homeArr[0]) return;
			currentScenicId = 0;
			showScenic(currentScenicId);
		}
		private var currentScenicId:uint = 0;
		private function timerHandler(event:TimerEvent):void
		{
			secondStepLoader = new CXmlLoader();
			secondStepLoader.loader((needLoadArray[timer.currentCount] as ChoseProvicData).province);
			secondStepLoader.addEventListener(CXmlLoader.LOADER_COMPLETE,nextProvicOk);
		}
		private var fullscreenXMLloader:CXmlLoader;
		private function nextProvicOk(event:Event):void
		{
			
			var C:Class = getDefinitionByName(secondStepLoader.getRootAttribute("class")) as Class;
			var scHome:Object = new C(stage,secondStepLoader);
//			var scHome:newCore.component.homePage.HomePage = new newCore.component.homePage.HomePage(stage,sichuanLoader);
			addChildAt(scHome as DisplayObject,0);
			scHome.addEventListener("SHOW_YN",backYnHandler);
			homeArr.push(scHome);
			scHome.visible = false;
			
		}
		private var fullData:AdvertiseMentData;
		private function fullXMLHandler(event:Event):void
		{
			fullData = fullscreenXMLloader.getDataById(0) as AdvertiseMentData;
			
			showFull();
		}
		private function initTop():void
		{
			var topAdvertise:AdvertiseFLV = new AdvertiseFLV("source/advertisement/top/topAdvertise.xml");
			addChild(topAdvertise);	
		}
		private var listContain:Sprite;
		private var fullSprite:Sprite;
		private function chageBtnState():void
		{
			if(btnArr[0].visible)
			{
				btnArr[0].visible = false;
				btnArr[1].visible = true;
			}
			else
			{
				btnArr[0].visible = true;
				btnArr[1].visible = false;
			}
		}
		private var listXmlLoader:CXmlLoader;
		private function showListWindow(event:MouseEvent):void
		{
			chageBtnState();
			if(!listXmlLoader&&!listWindow)
			{
				listXmlLoader = new CXmlLoader();
				listXmlLoader.loader("source/combinData/xml/listWindow.xml");
				listXmlLoader.addEventListener(CXmlLoader.LOADER_COMPLETE,listXmlOkHandler);
			}
			else
			{
				if(listWindow.visible)
				{
					listWindow.visible = false;
				}
				else
				{
					listWindow.visible = true;
				}
			}
			
		}
		private var listWindow:ListWindow;
		private function listXmlOkHandler(event:Event):void
		{
			listWindow = new ListWindow(listXmlLoader);
			listWindow.addEventListener(ListWindow.LIST_CHANGE,changeScenicHandler);
			listContain.addChild(listWindow);
		}
		private var fullAdver:FullscreenAdvertise;
		private function changeScenicHandler(event:Event):void
		{
			showScenic(listWindow.curentScenicId);
			chageBtnState();
			if(provinceName != listWindow.nameArray[listWindow.curentScenicId])
			{
				provinceName = listWindow.nameArray[listWindow.curentScenicId]
				Administrator.sendData(provinceName);
			}
		}
		private function hidFullHandler(event:Event):void
		{
			TimerDevice.resetTime();
			fullAdver.visible = false;
			fullAdver.stop();
		}
		private var btnSprite:Sprite;
		private var btnLoader:CLoaderMany;
		private var currentObject:ClearAll;
		private var btnArr:Array = [];
		private function btnOkHandler(event:Event):void
		{
			btnSprite.addChild(btnLoader._loaderContent[0]);
			btnSprite.addChild(btnLoader._loaderContent[1]);
			btnLoader._loaderContent[1].visible = false;
			btnArr.push(btnLoader._loaderContent[0]);
			btnArr.push(btnLoader._loaderContent[1]);
		}
		private function prepareHandler(event:MouseEvent):void
		{
			trace(" mouse click...btnSprite.mouseX = ",btnSprite.mouseX);
			
		}
		private var currentState:String = "yn";
		private function showScenic(sId:uint):void
		{
			if(sId > homeArr.length - 1)	return;
			currentObject.clearAll();
			(currentObject as DisplayObject).visible = false;
			currentObject = homeArr[sId];
			currentScenicId = sId;
			(currentObject as DisplayObject).visible = true;
			//			chageBtnState();
		}
		private function declarationClass():void
		{
			var u1:newCore.component.homePage.HomePage;
			var u2:core.component.homePage.HomePage;
		}
	}
}