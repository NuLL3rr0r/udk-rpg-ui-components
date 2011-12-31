package RpgUi {
	import flash.events.Event;

	public class ScrollMenuEvent extends Event {

		public static const ITEM_ROLL_OVER:String = "itemRollOver";
		public static const ITEM_SELECTED:String = "itemSelected";

		protected var m_item:ScrollMenuItem;

		public function get Item():ScrollMenuItem {
            return m_item;
        }
 
        public function set Item(value:ScrollMenuItem):void {
             m_item = value;
        }

		public function ScrollMenuEvent(type:String, item:ScrollMenuItem = null) {
			super(type);
			
			m_item = item;
		}

		override public function toString():String {
			return formatToString("ScrollMenuEvent", "type", "Item");
		}

		override public function clone():Event {
			return new ScrollMenuEvent(type, m_item);
		}
	}
}
