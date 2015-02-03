package newCore.component.letterSearch
{
	public class NormalSource
	{
		public var fileRootPath:String = "source/data/sichuan/source/letterSearch/normal/";
		public var title:String;
		public var discBG:String = fileRootPath+"disc_bg.png";
		public var disc:String = fileRootPath+"disc.png";
		public var bgArr:Array = new Array(fileRootPath+"bg.png",fileRootPath+"title_bg.png",fileRootPath+"info.png") ;
	
		public var pageTurningBtns:Array = new Array(fileRootPath+"next.png",fileRootPath+"next_down.png",fileRootPath+"prev.png",fileRootPath+"prev_down.png");
		public var letterNormal:Array = new Array("a.png","b.png","c.png","d.png","e.png","f.png","g.png","h.png","i.png","j.png","k.png","l.png",
			"m.png","n.png","o.png","p.png","q.png","r.png","s.png","t.png","u.png","v.png","w.png","x.png","y.png","z.png");
		public var letterSelected:Array = new Array("a_down.png","b_down.png","c_down.png","d_down.png","e_down.png","f_down.png","g_down.png",
			"h_down.png","i_down.png","j_down.png","k_down.png","l_down.png","m_down.png","n_down.png","o_down.png","p_down.png","q_down.png",
			"r_down.png","s_down.png","t_down.png","u_down.png","v_down.png","w_down.png","x_down.png","y_down.png","z_down.png");;
		public var letterBG:String = fileRootPath+"letter_bg.png";
		
		public function NormalSource()
		{
			
		}
	}
}