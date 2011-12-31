package RpgUi {
	import flash.display.Sprite;
	import flash.text.*;

	public class ScrollMenuItem extends Sprite {
		private var m_colorDisabled:Object;
		private var m_colorEnabled:Object;
		private var m_colorSelected:Object;
		private var m_id:int;
		private var m_isChecked:Boolean;
		private var m_isEnabled:Boolean;
		private var m_isSelected:Boolean;
		private var m_text:TextField;

		private var m_parent:ScrollMenuItemParent;

		[Inspectable(defaultValue="Menu Item", type="String")]
		public function get Text():String {
			return m_text.text;
		}
		public function set Text(text:String):void {
			m_text.text = text;
			Draw();
		}

		[Inspectable(defaultValue="", type="Number")]
		public function get Id():int {
			return m_id;
		}
		public function set Id(id:int):void {
			m_id = id;
		}

		[Inspectable(defaultValue="", type="uint", format="Color")]
		public function get ColorDisabled():Object {
			return m_colorDisabled;
		}
		public function set ColorDisabled(color:Object):void {
			m_colorDisabled = color;
			Draw();
		}

		[Inspectable(defaultValue="", type="uint", format="Color")]
		public function get ColorEnabled():Object {
			return m_colorEnabled;
		}
		public function set ColorEnabled(color:Object):void {
			m_colorEnabled = color;
			Draw();
		}

		[Inspectable(defaultValue="", type="uint", format="Color")]
		public function get ColorSelected():Object {
			return m_colorSelected;
		}
		public function set ColorSelected(color:Object):void {
			m_colorSelected = color;
			Draw();
		}

		[Inspectable(defaultValue="false", type="Boolean")]
		public function get IsChecked():Boolean {
			return m_isChecked;
		}
		public function set IsChecked(checked:Boolean):void {
			m_isChecked = checked;
			Draw();
		}

		[Inspectable(defaultValue="true", type="Boolean")]
		public function get IsEnabled():Boolean {
			return m_isEnabled;
		}
		public function set IsEnabled(enabled:Boolean):void {
			m_isEnabled = enabled;
			Draw();
		}

		public function get Height():Number {
			return m_text.height;
		}

		public function get IsSelected():Boolean {
			return m_isSelected;
		}
		public function set IsSelected(selected:Boolean):void {
			m_isSelected = selected;
			Draw();
		}

		public function get TextHeight():Number {
			return m_text.textHeight;
		}

		public function get TextWidth():Number {
			return m_text.textWidth;
		}

		public function get Width():Number {
			return m_text.width;
		}

		public function ScrollMenuItem() {
			super();
			Init();
		}
		
		public function SetParent(parent:ScrollMenuItemParent) {
			m_parent = parent;
			Draw();
		}

		public function Draw():void {
			if (m_text == null || m_parent == null)
				return;

			for (var i:Number = 0; i < this.numChildren; ++i) {
				if (this.getChildAt(i) is CheckMark) {
					this.removeChildAt(i);
					break;
				}
			}

			var format:TextFormat = new TextFormat();
			format.font = m_parent.FontName;

			if (!m_isSelected) {
				format.size =  m_parent.FontSize;
				format.color = m_isEnabled ? (m_colorEnabled == null || m_colorEnabled == "" ? m_parent.ColorEnabled : m_colorEnabled) :
											(m_colorDisabled == null || m_colorDisabled == "" ? m_parent.ColorDisabled : m_colorDisabled);
			} else {
				format.size = m_parent.FontSizeSelected;
				format.color = (m_colorSelected == null || m_colorSelected == "" ? m_parent.ColorSelected : m_colorSelected);
			}

			m_text.setTextFormat(format);

			m_text.x = 0.0;
			m_text.y = 0.0;
			
			var chk:CheckMark = new CheckMark(format.size, format.color, m_isChecked,
											  Number(m_parent.FontSizeSelected));
			addChild(chk);

			if (m_parent.IsRightToLeft) {
				chk.x = m_text.textWidth;
			} else {
				chk.x = 0.0;
				m_text.x += chk.width;
			}
		}

		private function Init():void {
			m_text = new TextField();
			m_text.autoSize = TextFieldAutoSize.LEFT;
			m_text.selectable = false;
			m_text.text = "Menu Item";
			addChild(m_text);
			
			m_id = 0;

			m_colorDisabled = new Object();
			m_colorEnabled = new Object();
			m_colorSelected = new Object();
			
			m_isChecked = false;
			m_isEnabled = true;
			m_isSelected = false;
		}

		override public function toString():String {
			return m_text.text;
		}
	}
}
