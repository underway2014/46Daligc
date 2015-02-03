package core.collect
{
	import core.constant.Const;
	
	import flash.net.SharedObject;

	public class CollectData
	{
		/**
		 *数据采集 
		 * 
		 */		
		public function CollectData()
		{
		}
//		private var shareObject:SharedObject;
		/**
		 * 广告增加一次点击数
		 * @param _name	
		 * 
		 */		
		public static function addCount(_name:String):void
		{
			var date:Date = new Date();
			
			var shareObject:SharedObject = SharedObject.getLocal(_name);
			if(shareObject.data["count"])
			{
				shareObject.data["count"] += 1;	//点击次数 +1
				shareObject.data["time"] += date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.getHours()+":"+date.getMinutes()+",";
				
			}
			else
			{
				shareObject.data["count"] = 1;	//点击次数 +1
				shareObject.data["time"] = date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+"	 "+date.getHours()+":"+date.getMinutes()+",";
			}
			shareObject.flush();
//			getAllAdvertiseInfo();
		}
		/**
		 * 保存所有广告的ID 
		 * @param arr
		 * 
		 */		
		public static function saveAllID(arr:Array):void
		{
			var allID:SharedObject = SharedObject.getLocal(Const.ALL_ADVERTISE_ID);
			if(allID.data["str"])
			{
				var a:Array = String(allID.data["str"]).split(",");
				trace("==saveid==",a);
				for each(var s:String in arr)
				{
					if(a.indexOf(s)!=-1)
					{
						continue;
					}
					a.push(s);
				}
				allID.data["str"] = a.join(",");
			}
			else
			{
				allID.data["str"] = arr.join(",");
			}
		}
		/**
		 *获取所有广告的点击信息 
		 * 
		 */		
		public  static function getAllAdvertiseInfo():void
		{
			var allID:SharedObject = SharedObject.getLocal(Const.ALL_ADVERTISE_ID);
			var a:Array = String(allID.data["str"]).split(",");
			var obj:SharedObject;
			for each(var str:String in a)
			{
				obj = SharedObject.getLocal(str);
				trace("####=",str,obj.data["count"],obj.data["time"]);
				trace("@@@@@@@@@");
			}
		}
		/**
		 *清除所有对象的属性 或 对象本身
		 * 
		 */		
		public static function clear(type:Boolean=false):void
		{
			var allID:SharedObject = SharedObject.getLocal(Const.ALL_ADVERTISE_ID);
			var a:Array = String(allID.data["str"]).split(",");
			var obj:SharedObject;
			for each(var str:String in a)
			{
				obj = SharedObject.getLocal(str);
				delete obj.data["count"];
				delete obj.data["time"];
				trace("####=",str,obj.data["count"],obj.data["time"]);
				trace("@@@@@@@@@");
				if(type)
				{
					//清除所有共享对象
					obj = null;
				}
			}
		}
	}
}