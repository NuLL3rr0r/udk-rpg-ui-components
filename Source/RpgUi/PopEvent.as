package RpgUi {
	import flash.events.Event;

	public class PopEvent extends Event {

		public static const POPUP:String = "popup";
		public static const POPOUT:String = "popout";

		protected var m_pop:String;

		public function get Pop():String {
            return m_pop;
        }
 
        public function set Pop(value:String):void {
             m_pop = value;
        }

		public function PopEvent(type:String, pop:String = "") {
			super(type);

			m_pop = pop;
		}

		override public function toString():String {
			return formatToString("PopEvent", "type", "pop");
		}

		override public function clone():Event {
			return new PopEvent(type, m_pop);
		}
	}
}
