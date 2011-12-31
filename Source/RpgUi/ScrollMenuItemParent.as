package RpgUi {
	import flash.text.*;

	public class ScrollMenuItemParent {
		private var m_colorDisabled:Object;
		private var m_colorEnabled:Object;
		private var m_colorSelected:Object;
		private var m_fontName:String;
		private var m_fontSize:Object;
		private var m_fontSizeSelected:Object;
		private var m_isRightToLeft:Boolean;

		[Inspectable(defaultValue="#999999" ,type="Color")]
		public function get ColorDisabled():Object {
			return m_colorDisabled;
		}
		public function set ColorDisabled(color:Object):void {
			m_colorDisabled = color;
		}

		[Inspectable(defaultValue="#333333", type="Color")]
		public function get ColorEnabled():Object {
			return m_colorEnabled;
		}
		public function set ColorEnabled(color:Object):void {
			m_colorEnabled = color;
		}

		[Inspectable(defaultValue="#000000", type="Color")]
		public function get ColorSelected():Object {
			return m_colorSelected;
		}
		public function set ColorSelected(color:Object):void {
			m_colorSelected = color;
		}

		[Inspectable(defaultValue="Verdana", type="Font Name")]
		public function get FontName():String {
			return m_fontName;
		}
		public function set FontName(name:String):void {
			m_fontName = name;
		}

		[Inspectable(defaultValue="24.0", type="Number")]
		public function get FontSize():Object {
			return m_fontSize;
		}
		public function set FontSize(size:Object):void {
			m_fontSize = size;
		}

		[Inspectable(defaultValue="30.0", type="Number")]
		public function get FontSizeSelected():Object {
			return m_fontSizeSelected;
		}
		public function set FontSizeSelected(name:Object):void {
			m_fontSizeSelected = name;
		}

		[Inspectable(defaultValue="true", type="Boolean")]
		public function get IsRightToLeft():Boolean {
			return m_isRightToLeft;
		}
		public function set IsRightToLeft(enabled:Boolean):void {
			m_isRightToLeft = enabled;
		}

		public function ScrollMenuItemParent() {
			super();
		}		
	}
}