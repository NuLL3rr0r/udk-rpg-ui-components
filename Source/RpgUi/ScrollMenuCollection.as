package RpgUi {
	public class ScrollMenuCollection {
		private var m_items:Array;

		public function ScrollMenuCollection() {
			super();
			m_items = new Array();
		}

		public function addItem(item:Object):Boolean {
			if (item != null) {
				m_items.push(item);
				return true;
			}
			return false;
		}

		public function clear():void {
			m_items = new Array();
		}

		public function getItemAt(index:Number):Object {
			return(m_items[index]);
		}

		public function get length():int {
			return m_items.length;
		}
	}
}
